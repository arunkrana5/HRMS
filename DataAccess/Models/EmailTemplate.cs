using System.ComponentModel.DataAnnotations;

namespace DataAccess.Models
{
    public class EmailTemplate
    {
        public class List
        {
            public int RowNum { get; set; }
            public long TemplateID { set; get; }


            public string TemplateName { get; set; }
            public string Body { get; set; }

            public string Subject { set; get; }
            public string SMSBody { get; set; }
            public string Repository { get; set; }
            public string CCMail { get; set; }
            public string BCCMail { get; set; }
            public bool IsActive { set; get; }
            public int Priority { set; get; }
            public string CreatedBy { get; set; }
            public string CreatedDate { get; set; }
            public string ModifiedDate { get; set; }
            public string ModifiedBy { get; set; }
            public string IPAddress { get; set; }
        }
        public class Add
        {
            public int TemplateID { set; get; }

            [Required(ErrorMessage = "Template Name Can't be Blank")]
            public string TemplateName { get; set; }
            public string Body { get; set; }
            [Required(ErrorMessage = "Subject Can't be Blank")]
            public string Subject { set; get; }
            public string SMSBody { get; set; }
            public string Repository { get; set; }
            public string CCMail { get; set; }
            public string BCCMail { get; set; }
            public bool IsActive { set; get; }
            public int? Priority { set; get; }
            public string IPAddress { get; set; }
            public long LoginID { get; set; }
        }
    }
}
