using System.Web.Mvc;

namespace Web.Areas.Jobs
{
    public class JobsAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return "Jobs";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {

            context.MapRoute(
            name: "ErrorPage",
            url: "ErrorPage",
            defaults: new { controller = "Virtual", action = "ErrorPage", AreaName = "Jobs" });

            context.MapRoute(
            name: "InfoPage",
            url: "InfoPage",
            defaults: new { controller = "Virtual", action = "InfoPage", AreaName = "Jobs" });


            context.MapRoute(
              name: "OnboardBasicDetails",
              url: "OnboardBasicDetails/{Key}",
              defaults: new { controller = "Virtual", action = "OnboardBasicDetails", AreaName= "Jobs" }
          );

            context.MapRoute(
            name: "OnboardBankDetails",
            url: "OnboardBankDetails/{Key}",
            defaults: new { controller = "Virtual", action = "OnboardBankDetails", AreaName = "Jobs" }
        );

            context.MapRoute(
            name: "OnboardDocuments",
            url: "OnboardDocuments/{Key}",
            defaults: new { controller = "Virtual", action = "OnboardDocuments", AreaName = "Jobs" }
        );

            context.MapRoute(
                "Jobs_default",
                "Jobs/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}