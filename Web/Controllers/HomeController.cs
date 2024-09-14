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
    [CheckLoginOnly]
    public class HomeController : Controller
    {
        long LoginID = 0;
        string IPAddress = "";
        GetResponse getResponse;
        IHomeHelper Home;
        string MyDrivePath;
        public HomeController()
        {

            getResponse = new GetResponse();
            long.TryParse(ClsApplicationSetting.GetSessionValue("LoginID"), out LoginID);
            IPAddress = ClsApplicationSetting.GetIPAddress();
            getResponse.IPAddress = IPAddress;
            getResponse.LoginID = LoginID;
            Home = new HomeModal();
            MyDrivePath = ClsApplicationSetting.GetPhysicalPath("drive");

        }

        public ActionResult Dashboard()
        {
            return View();
        }

        public ActionResult ChangePassword()
        {
            ChangePassword Results = new ChangePassword();
            return View(Results);

        }
        [HttpPost]
        public ActionResult ChangePassword(ChangePassword Modal, string Command)
        {
            PostResponse Result = new PostResponse();
            Result.SuccessMessage = "Can't Update";
            if (Modal.ConfirmPassword != Modal.NewPassword)
            {
                Result.SuccessMessage = "Confirm Password and New Password must be matched";
                ModelState.AddModelError("NewPassword", Result.SuccessMessage);
            }
            if (ModelState.IsValid)
            {
                Modal.LoginID = LoginID;
                Modal.IPAddress = IPAddress;
                Result = Common_SPU.fnSetChangePassword(Modal);
            }
            if (Result.Status)
            {
                Result.RedirectURL = "/Home/Dashboard";
            }
            return Json(Result, JsonRequestBehavior.AllowGet);


        }

        public ActionResult MyProfile()
        {
            Profile Results = new Profile();
            Results = Common_SPU.GetProfile(getResponse);
            return View(Results);

        }

        [HttpPost]
        public ActionResult SaveProfileImageJson(Profile Modal)
        {
            PostResponse PostResult = new PostResponse();
            if (!string.IsNullOrEmpty(Modal.ImageBase64String))
            {
                FileResponse attachModal = new FileResponse();
                attachModal.ImageBase64String = Modal.ImageBase64String;
                attachModal.LoginID = LoginID;
                attachModal.IPAddress = IPAddress;
                attachModal.Doctype = "profilepic";
                PostResult = ClsApplicationSetting.UploadCameraImage(attachModal);
                ClsApplicationSetting.SetSessionValue("ImageURL", PostResult.SuccessMessage);

            }
            return Json(PostResult, JsonRequestBehavior.AllowGet);
        }

    }
}