using System.Net.Mail;

namespace WorkTogether.Models
{
    public class EmailHelper
    {


        public bool SendEmail(string userEmail, string Message, string Title)
        {
            MailMessage mailMessage = new MailMessage();
            mailMessage.From = new MailAddress("wt@worktogether.site");
            mailMessage.To.Add(new MailAddress(userEmail));

            mailMessage.Subject = Title;
            mailMessage.IsBodyHtml = true;
            mailMessage.Body = Message;
            

            SmtpClient client = new SmtpClient();
            client.Credentials = new System.Net.NetworkCredential("maxlukef@comcast.net", "wGZRUS0cM9pj6Aam");
            client.Host = "smtp-relay.sendinblue.com";
            client.Port = 587;

            try
            {
                client.Send(mailMessage);
                return true;
            }
            catch (Exception ex)
            {
                // log exception
            }
            return false;
        }
    }
}