
using DataAccess.CommanClass;
using System.Web;
using System.Web.Mvc;

namespace Web.CommonClass
{
    public class CheckLoginOnly : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {

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
            else if (ClsApplicationSetting.GetWebConfigValue("AllowMultipleLogin") != "true" && !Common_SPU.fnGetSessionExists(filterContext.HttpContext.Session.SessionID.ToString(), LoginID).Status)
            {
                HttpContext.Current.Response.Redirect("/Accounts/Logout");
            }

        }
    }
}