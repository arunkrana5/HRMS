using DataAccess.CommanClass;
using DataAccess.Models;
using DataAccess.ModelsMaster;
using DataAccess.ModelsMasterHelper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Web.CommonClass;

namespace Web.Controllers
{
    [CheckLoginFilter]
    public class OnboardingController : Controller
    {
        long LoginID = 0;
        string IPAddress = "";
        GetResponse getResponse;
        IOnboardingHelper onboard;

        public OnboardingController()
        {

            getResponse = new GetResponse();
            long.TryParse(ClsApplicationSetting.GetSessionValue("LoginID"), out LoginID);
            IPAddress = ClsApplicationSetting.GetIPAddress();
            getResponse.IPAddress = IPAddress;
            getResponse.LoginID = LoginID;
            onboard = new OnboardingModal();

        }

        public ActionResult OnboardingList(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            MyTab.Approval Modal = new MyTab.Approval();
            Modal.Approved = -1;
            Modal.LoginID = LoginID;
            return View(Modal);
        }
        public ActionResult _OnboardingList(string src, MyTab.Approval Modal)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            Modal.LoginID = LoginID;
            Modal.IPAddress = IPAddress;
            List<Onboarding.List> result = new List<Onboarding.List>();
            result = onboard.GetOnboarding_List(Modal);
            return PartialView(result);

        }

        public ActionResult _CreateOnboarding(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            Onboarding.Create result = new Onboarding.Create();
            return PartialView(result);

        }

        [HttpPost]
        public ActionResult _CreateOnboarding(string src, Onboarding.Create Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            Result.SuccessMessage = "Can't Create";
            if (ModelState.IsValid)
            {
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Modal.Token= Guid.NewGuid().ToString();
                Result = onboard.fnSetOnboarding_Create(Modal);
                
            }
            return Json(Result, JsonRequestBehavior.AllowGet);

        }

        public ActionResult _ViewOnboarding(string src)
        {
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            ViewBag.AppID = GetQueryString[2];
            long AppID = 0;
            long.TryParse(ViewBag.AppID, out AppID);
            Onboarding.View result = new Onboarding.View();
            getResponse.ID = AppID;
            result = onboard.GetOnboarding_View(getResponse);
            return PartialView(result);

        }
        [HttpPost]
        public ActionResult OnboardingApprove(string src, FormCollection form, string Command)
        {
            PostResponse Result = new PostResponse();
            ViewBag.src = src;
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(src);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.MenuID = GetQueryString[0];
            int Approved = 0;
            int.TryParse(Command, out Approved);
            string AppID = form["AppID"].ToString();
            if (!string.IsNullOrEmpty(AppID))
            {
                Onboarding.ApprovalAction Modal = new Onboarding.ApprovalAction();
                Modal.Approved = Approved;
                Modal.ApprovedRemarks = form["ApproveRemarks"].ToString();
                if (string.IsNullOrEmpty(Modal.ApprovedRemarks))
                {
                    Result.SuccessMessage = "Remarks can't be blank";
                    return Json(Result, JsonRequestBehavior.AllowGet);
                }
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Modal.IDs = AppID.ToString();
                Result = onboard.fnSetOnboardingApproval(Modal);
            }
            return Json(Result, JsonRequestBehavior.AllowGet);
        }

    }
}