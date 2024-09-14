
using DataAccess.CommanClass;
using System.Web;
using System.Web.Mvc;

namespace Web.CommonClass
{
    public class CheckLoginFilter : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            //string IgnoreAction = "markattendence,dashboard,_targetachievedlist";
            long LoginID = 0;
            long.TryParse(ClsApplicationSetting.GetSessionValue("LoginID"), out LoginID);
            
            string[] Requestedsrc = null;
            string actionName = (string)filterContext.RouteData.Values["action"];
            
            if (HttpContext.Current.Request.HttpMethod == "GET")
            {
                Requestedsrc = ClsApplicationSetting.DecryptQueryString(HttpContext.Current.Request.QueryString["src"]);
            }
            else
            {
                if (filterContext.Controller.ValueProvider.GetValue("src") != null)
                {
                    Requestedsrc = ClsApplicationSetting.DecryptQueryString(filterContext.Controller.ValueProvider.GetValue("src").AttemptedValue);
                }
            }

            if (HttpContext.Current.Session["LoginID"] == null)
            {
                string ReturnURL = HttpContext.Current.Request.Url.AbsoluteUri;
                HttpContext.Current.Response.Redirect("~/Accounts/Login?ReturnURL=" + ClsCommon.Encrypt(ReturnURL));
            }
            else if (ClsApplicationSetting.GetWebConfigValue("AllowURLEditing") == "true")
            {
                if (filterContext.HttpContext.Request.UrlReferrer == null ||
                        filterContext.HttpContext.Request.Url.Host != filterContext.HttpContext.Request.UrlReferrer.Host)
                {
                    HttpContext.Current.Response.Redirect("~/Accounts/PageNotFound");
                }

            }
            else if (Requestedsrc == null)
            {
                HttpContext.Current.Response.Redirect("~/Accounts/PageNotFound");
            }
            else if (HttpContext.Current.Request.Url.AbsolutePath.ToLower() != Requestedsrc[1].ToLower())
            {
                HttpContext.Current.Response.Redirect("~/Accounts/PageNotFound");
            }
            else if (Requestedsrc != null && !ClsApplicationSetting.CheckPageViewPermission(Requestedsrc[0]).ReadFlag)
            {
                HttpContext.Current.Response.Redirect("~/Accounts/PageNotFound");
            }
            else if(ClsApplicationSetting.GetWebConfigValue("AllowMultipleLogin") != "true" && !Common_SPU.fnGetSessionExists(filterContext.HttpContext.Session.SessionID.ToString(),LoginID).Status)
            {
                HttpContext.Current.Response.Redirect("/Accounts/Logout");
            }
            

        }
    }
}