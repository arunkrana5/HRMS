
using DataAccess.CommanClass;
using DataAccess.DataModal.ModelsMaster;
using DataAccess.Models;
using DataAccess.ModelsMasterHelper;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using Web.CommonClass;

namespace Web.Controllers
{
    public class AccountsController : Controller
    {

        long LoginID = 0;
        string IPAddress = "";
        GetResponse getResponse;
        IAccountsHelper Account;
        public AccountsController()
        {
            getResponse = new GetResponse();
            long.TryParse(ClsApplicationSetting.GetSessionValue("LoginID"), out LoginID);
            IPAddress = ClsApplicationSetting.GetIPAddress();
            getResponse.IPAddress = IPAddress;
            getResponse.LoginID = LoginID;
            Account = new AccountsModel();
        }
        public ActionResult Login(string ReturnURL)
        {
            ViewBag.ReturnURL = ReturnURL;
            AdminUser.Login Modal = new AdminUser.Login();
            return View(Modal);
        }
        [HttpPost]
        public ActionResult Login(AdminUser.Login Modal, string ReturnURL, string Command)
        {
            if (ModelState.IsValid)
            {
                if (Command == "Submit")
                {

                    Modal.IPAddress = ClsCommon.GetIPAddress();
                    Modal.SessionID = HttpContext.Session.SessionID;
                    AdminUser.Details result = Account.GetLogin(Modal);

                    if (result.status)
                    {
                        ClsApplicationSetting.SetSessionValue("LoginID", result.LoginID.ToString());
                        ClsApplicationSetting.SetSessionValue("UserID", result.UserID.ToString());
                        ClsApplicationSetting.SetSessionValue("RoleID", result.RoleID.ToString());  
                        ClsApplicationSetting.SetSessionValue("Phone", result.Phone.ToString());
                        ClsApplicationSetting.SetSessionValue("Name", result.Name.ToString());
                        ClsApplicationSetting.SetSessionValue("RoleName", result.RoleName.ToString());
                        ClsApplicationSetting.SetSessionValue("IsFirstLogin", result.IsFirstLogin.ToString());

                        if(result.IsFirstLogin)
                        {
                            return RedirectToAction("ChangePassword", "Home");
                        }
                        else if (!string.IsNullOrEmpty(ReturnURL))
                        {
                            return Redirect(ClsCommon.Decrypt(ReturnURL));
                        }
                        else
                        {
                            return RedirectToAction("Dashboard", "Home");

                        }

                    }
                    else
                    {
                        TempData["LoginSuccess"] = "N";
                        TempData["LoginSuccessMsg"] = "User ID does not exist or User ID De-activated. Please Contact your system administrator";
                        return View(Modal);
                    }

                }
            }
            return View(Modal);

        }
        public ActionResult Logout()
        {

            ClsApplicationSetting.ClearSessionValues();
            return RedirectToAction("Login", "Accounts");
        }
        public ActionResult PageNotFound()
        {
            if (TempData["Message"] == null)
            {
                TempData["Message"] = "Page Not Found";
            }
            return View();
        }

        public ActionResult ForgotPassword()
        {
            ForgotPassword obj = new ForgotPassword();
            return View(obj);
        }

        public ActionResult SetPassword(string Token)
        {
            SetPassword obj = new SetPassword();
            string[] GetQueryString = ClsApplicationSetting.DecryptQueryString(Token);
            ViewBag.GetQueryString = GetQueryString;
            ViewBag.Token = GetQueryString[0];
            ViewBag.Date = GetQueryString[1];
            DateTime dt;
            DateTime.TryParse(ViewBag.Date, out dt);
            if (dt.AddMinutes(15) <= DateTime.Now)
            {
                TempData["Message"] = "Link has been expired";
                return RedirectToAction("PageNotFound", "Accounts");
            }
            return View(obj);
        }
      
    }
}