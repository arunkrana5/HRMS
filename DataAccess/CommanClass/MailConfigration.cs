using DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.CommanClass
{
    public class MailConfigration
    {
        public static PostResponse SendMail(SMTPMail Modal)
        {
            PostResponse result = new PostResponse();
            try
            {
                MailMessage mailMessage = new MailMessage();
                mailMessage.From = new MailAddress(Modal.SMTP_EMAIL);

                if (!Modal.ToEmail.Contains(";"))
                {
                    mailMessage.To.Add(new MailAddress(Modal.ToEmail));
                }
                else
                {

                    string[] sMail = Modal.ToEmail.Split(';');
                    foreach (string word in sMail)
                    {
                        if (word.Trim() != "")
                        {
                            mailMessage.To.Add(new MailAddress(word));
                        }

                    }
                }

                if (!string.IsNullOrEmpty(Modal.CC))
                {
                    if (!Modal.CC.Contains(";"))
                    {
                        mailMessage.CC.Add(new MailAddress(Modal.CC));
                    }
                    else
                    {
                        string[] sMail = Modal.CC.Split(';');

                        foreach (string word in sMail)
                        {
                            if (word.Trim() != "")
                            {
                                mailMessage.CC.Add(new MailAddress(word));
                            }
                        }
                    }
                }

                if (!string.IsNullOrEmpty(Modal.BCC))
                {
                    if (!Modal.BCC.Contains(";"))
                    {
                        mailMessage.Bcc.Add(new MailAddress(Modal.BCC));
                    }
                    else
                    {
                        string[] sMail = Modal.BCC.Split(';');

                        foreach (string word in sMail)
                        {
                            if (word.Trim() != "")
                            {
                                mailMessage.CC.Add(new MailAddress(word));
                            }
                        }
                    }
                }

                mailMessage.Subject = Modal.Subject;
                mailMessage.Body = Modal.MailBody;
                try
                {

                    if (!string.IsNullOrEmpty(Modal.AttachmenPath))
                    {
                        if (!Modal.AttachmenPath.Contains(";"))
                        {
                            mailMessage.Attachments.Add(new System.Net.Mail.Attachment(Modal.AttachmenPath));

                        }
                        else
                        {
                            foreach (var item in Modal.AttachmenPath.Split(';'))
                            {
                                mailMessage.Attachments.Add(new System.Net.Mail.Attachment(item));
                            }
                        }
                    }
                }
                catch
                {
                }
                mailMessage.IsBodyHtml = true;
                mailMessage.Priority = MailPriority.High;
                SmtpClient smtpClient = new SmtpClient();
                smtpClient.Host = Modal.SMTP;
                smtpClient.Port = Modal.Port;
                smtpClient.EnableSsl = Modal.EnableSsl;

                smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;

                smtpClient.Credentials = new NetworkCredential(Modal.SMTP_USER, Modal.SMTP_PASSWORD);
                System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12;
                System.Net.ServicePointManager.ServerCertificateValidationCallback = AcceptAllCertifications;/* TODO ERROR: Skipped SkippedTokensTrivia */
                smtpClient.Send(mailMessage);

                result.Status = true;
                result.StatusCode = 1;
                result.SuccessMessage = "Mail Sent Successfully";
            }
            catch (Exception ex)
            {
                Common_SPU.LogError("Error during SendMail. The query was executed :", ex.ToString(), "SendMail()", "MailConfigration", "MailConfigration", 0, "");
                result.StatusCode = -1;
                result.SuccessMessage = ex.Message.ToString();
            }
            return result;
        }

        public static bool AcceptAllCertifications(object sender, System.Security.Cryptography.X509Certificates.X509Certificate certification, System.Security.Cryptography.X509Certificates.X509Chain chain, System.Net.Security.SslPolicyErrors sslPolicyErrors)
        {
            return true;
        }


    }
}
