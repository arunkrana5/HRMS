using DataAccess.CommanClass;
using DataAccess.Models;
using DataAccess.ModelsMaster;
using DataAccess.ModelsMasterHelper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Web.Areas.Jobs.Controllers
{
    public class VirtualController : Controller
    {
        long LoginID = 0;
        string IPAddress = "";
        GetResponse getResponse;
        IOnboardingHelper onboard;

        public VirtualController()
        {
            getResponse = new GetResponse();
            long.TryParse(ClsApplicationSetting.GetSessionValue("LoginID"), out LoginID);
            IPAddress = ClsApplicationSetting.GetIPAddress();
            getResponse.IPAddress = IPAddress;
            getResponse.LoginID = LoginID;
            onboard = new OnboardingModal();
        }

        public ActionResult OnboardBasicDetails(string Key)
        {
            ViewBag.Key = Key;
            getResponse.Param1 = Key;
            getResponse.Doctype = "BasicDetails";
            var result = onboard.GetOnboarding_BasicDetails(getResponse);
            if (result != null)
            {
                if (result.Approved < 0 || result.Approved == 2)
                {
                    return View(result);
                }
                else
                {
                    return View("InfoPage");
                }
            }
            else
            {
                return View("ErrorPage");
            }
        }

        [HttpPost]
        public ActionResult OnboardBasicDetails(string Key, Onboarding.Users.BasicDetails Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.Key = Key;
            Modal.Token = Key;
            Result.SuccessMessage = "Basic Details Can't Update";
            if (ModelState.IsValid)
            {
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Result = onboard.fnSetOnboarding_BasicDetails(Modal);
            }
            if (Result.Status)
            {
                Result.RedirectURL = "/OnboardBankDetails/" + Key;
            }
            return Json(Result, JsonRequestBehavior.AllowGet);

        }

       
        public ActionResult OnboardBankDetails(string Key)
        {
            ViewBag.Key = Key;
            getResponse.Param1 = Key;
            var result = onboard.GetOnboarding_BankDetails(getResponse);
            if (result != null)
            {
                if (result.Approved < 0 || result.Approved == 2)
                {
                    return View(result);
                }
                else
                {
                    return View("InfoPage");
                }
            }
            else
            {
                return View("ErrorPage");
            }
        }
        [HttpPost]
        public ActionResult OnboardBankDetails(string Key, Onboarding.Users.BankDetails Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.Key = Key;
            Modal.Token = Key;
            Result.SuccessMessage = "Bank Details Can't Update";
            if (ModelState.IsValid)
            {
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Result = onboard.fnSetOnboarding_BankDetails(Modal);
            }
            if (Result.Status)
            {
                Result.RedirectURL = "/OnboardDocuments/" + Key;
            }
            return Json(Result, JsonRequestBehavior.AllowGet);

        }
        public ActionResult OnboardDocuments(string Key)
        {
            ViewBag.Key = Key;
            getResponse.Param1 = Key;
            getResponse.Doctype = "documents";
            var result = onboard.GetOnboarding_Documents(getResponse);
            if (result != null)
            {
                if (result.Approved < 0 || result.Approved == 2)
                {
                    return View(result);
                }
                else
                {
                    return View("InfoPage");
                }
            }
            else
            {
                return View("ErrorPage");
            }
        }
        [HttpPost]
        public ActionResult OnboardDocuments(string Key, Onboarding.Users.DocumentDetails Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.Key = Key;
            Modal.Token = Key;
            Result.SuccessMessage = "Documents Details Can't Update";
            if (Modal.DocumentsList == null || Modal.DocumentsList.Count == 0)
            {
                Result.SuccessMessage = "Documents List can't be blank";
                return Json(Result, JsonRequestBehavior.AllowGet);
            }
            else if (Modal.DocumentsList.Any(x => x.Attach_ID == null) && Modal.DocumentsList.Any(x => x.Upload == null))
            {
                Result.SuccessMessage = "Please upload file it can't be blank";
                return Json(Result, JsonRequestBehavior.AllowGet);
            }
            if (ModelState.IsValid)
            {
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;

                if (Modal.DocumentsList != null)
                {
                    UploadAttachment attachModal;
                    foreach (var item in Modal.DocumentsList)
                    {
                        if (item.Upload != null)
                        {
                            attachModal = new UploadAttachment();
                            attachModal.File = item.Upload;
                            attachModal.LoginID = LoginID;
                            attachModal.IPAddress = IPAddress;
                            attachModal.Token = Key;
                            attachModal.Doctype = "onboard";
                            attachModal.Description = item.Description;
                            attachModal.AttachID = item.Attach_ID;

                            var Attach = ClsApplicationSetting.UploadAttachment(attachModal);
                            if (!Attach.Status)
                            {
                                Result.SuccessMessage = Attach.SuccessMessage;
                                return Json(Result, JsonRequestBehavior.AllowGet);
                            }
                        }
                    }

                }
                Result = onboard.fnSetOnboarding_Final(Modal);
            }
            if (Result.Status)
            {
                Result.RedirectURL = "/InfoPage";
            }
            return Json(Result, JsonRequestBehavior.AllowGet);

        }
        public ActionResult ErrorPage()
        {
            return View();
        }
        public ActionResult InfoPage()
        {
            return View();
        }


    }
}