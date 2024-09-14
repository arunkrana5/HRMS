using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Models
{
    public class SMTPMail
    {
        public string SMTP { get; set; }
        public string SMTP_USER { get; set; }
        public string SMTP_PASSWORD { get; set; }
        public string SMTP_EMAIL { get; set; }
        public int Port { get; set; }
        public bool EnableSsl { get; set; }
        public string ToEmail { get; set; }
        public string CC { get; set; }
        public string BCC { get; set; }
        public string AttachmenPath { get; set; }
        public string Subject { get; set; }
        public string MailBody { get; set; }
        public Template TemplateData { get; set; }
        public List<ConfigSetting> ConfigSettingList { get; set; }

    }

    public class Template
    {
        public string TemplateName { get; set; }
        public string Body { get; set; }
        public string Subject { get; set; }

        public string CCMail { get; set; }
        public string BCCMail { get; set; }
        public string Repository { get; set; }
        public string SMSBody { get; set; }
       

    }
}
