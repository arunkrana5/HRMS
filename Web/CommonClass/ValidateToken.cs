
using DataAccess.CommanClass;
using System.Web;
using System.Web.Mvc;

namespace Web.CommonClass
{
    public class ValidateToken : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            string Token = "";
            string actionName = (string)filterContext.RouteData.Values["action"];
            
            if (HttpContext.Current.Request.HttpMethod == "GET")
            {
                Token = HttpContext.Current.Request.QueryString["Token"];
            }
            else
            {
                if (filterContext.Controller.ValueProvider.GetValue("Token") != null)
                {
                    Token = filterContext.Controller.ValueProvider.GetValue("Token").AttemptedValue;
                }
            }

            if (!Common_SPU.fnGetTokenExists(Token).Status)
            {
                HttpContext.Current.Response.Redirect("/Accounts/PageNotFound");
            }

        }
    }
}