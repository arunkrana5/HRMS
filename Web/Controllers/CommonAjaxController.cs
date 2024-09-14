using DataAccess.CommanClass;
using DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Web.Mvc;
using Web.CommonClass;

namespace Web.Controllers
{
    
    public class CommonAjaxController : Controller
    {
        long LoginID = 0;
        string IPAddress = "";
        GetResponse getResponse;
        public CommonAjaxController()
        {
            getResponse = new GetResponse();
            long.TryParse(ClsApplicationSetting.GetSessionValue("LoginID"), out LoginID);
            IPAddress = ClsApplicationSetting.GetIPAddress();
            getResponse.IPAddress = IPAddress;
            getResponse.LoginID = LoginID;
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public JsonResult GetDateTimeJson()
        {
            string MyTime = DateTime.Now.ToString("dddd, dd-MMM-yyyy hh:mm:ss tt");
            return Json(MyTime, JsonRequestBehavior.AllowGet);
        }

        [AcceptVerbs(HttpVerbs.Get)]
        public JsonResult EncryptJSON(string Value)
        {
            return Json(ClsCommon.Encrypt(Value), JsonRequestBehavior.AllowGet);
        }
        [AcceptVerbs(HttpVerbs.Get)]
        public JsonResult DecryptQueryStringJSON(string Value)
        {
            return Json(ClsApplicationSetting.DecryptQueryString(Value), JsonRequestBehavior.AllowGet);
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public JsonResult UpdateColumn_CommonJson(GetUpdateColumnResponse Modal)
        {
            PostResponse PostResult = new PostResponse();
            PostResult.SuccessMessage = "Action not saved";
            Modal.LoginID = LoginID;
            Modal.IPAddress = IPAddress;
            PostResult = Common_SPU.fnGetUpdateColumnResponse(Modal);
            return Json(PostResult, JsonRequestBehavior.AllowGet);
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public JsonResult GetDropDownListJson(GetDropDownResponse Modal)
        {
            List<DropDownlist> Result = new List<DropDownlist>();
            Modal.LoginID = LoginID;
            Modal.IPAddress = IPAddress;
            Result = Common_SPU.GetDropDownList(Modal);
            return Json(Result, JsonRequestBehavior.AllowGet);
        }
        [AcceptVerbs(HttpVerbs.Post)]
        public JsonResult DelRecordJson(GetResponse Modal)
        {
            PostResponse PostResult = new PostResponse();
            PostResult.SuccessMessage = "Action not saved";
            Modal.LoginID = LoginID;
            Modal.IPAddress = IPAddress;
            PostResult = Common_SPU.fnDelRecord(Modal);
            return Json(PostResult, JsonRequestBehavior.AllowGet);
        }
        [AcceptVerbs(HttpVerbs.Post)]

        public ActionResult IsSessionEndJSON(string ReturnURL)
        {
            PostResponse PostResult = new PostResponse();
            if (ClsApplicationSetting.IsSessionExpired("LoginID"))
            {
                if (!string.IsNullOrEmpty(ReturnURL))
                {
                    PostResult.RedirectURL = "/Accounts/Login?ReturnURL=" + ClsCommon.Encrypt(ReturnURL);
                }
                PostResult.Status = true;
            }
            return Json(PostResult, JsonRequestBehavior.AllowGet);

        }

        [AcceptVerbs(HttpVerbs.Post)]
        public JsonResult GetCheckRecordExistJson(GetRecordExitsResponse Modal)
        {
            PostResponse PostResult = new PostResponse();
            Modal.LoginID = LoginID;
            Modal.IPAddress = IPAddress;
            PostResult = Common_SPU.fnGetCheckRecordExist(Modal);
            return Json(PostResult, JsonRequestBehavior.AllowGet);
        }




        [AcceptVerbs(HttpVerbs.Get)]
        public JsonResult GetHelpdeskticketcountJson(GetResponse Modal)
        {
            Modal.LoginID = LoginID;
            Modal.IPAddress = IPAddress;
            return Json(Common_SPU.GetHelpdeskticketcount(Modal), JsonRequestBehavior.AllowGet);
        }


    }
}