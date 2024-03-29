﻿using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics;
using WorkTogether.Models;

namespace WorkTogether.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NotificationsController : ControllerBase
    {
        private readonly WT_DBContext _context;

        public NotificationsController(WT_DBContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Gets the current user based on the HttpContext in the calling function
        /// </summary>
        /// <param name="httpContext">The HttpContext</param>
        /// <returns>The user calling the endpoint</returns>
        private User GetCurrentUser(HttpContext httpContext)
        {
            string userEmail = httpContext.User.Identity.Name;
            Debug.WriteLine("User Email: " + userEmail);
            User u1 = _context.Users.Where(u => u.Email == userEmail).FirstOrDefault();

            return u1;
        }



        /// <summary>
        /// Gets the current user's notifications
        /// </summary>
        /// <returns>A list of NotificationDTOs</returns>
        [HttpGet("GetForCurUser")]
        [Authorize]
        public async Task<ActionResult<IEnumerable<NotificationDTO>>> GetForCurUser()
        {
            if (_context.Notification == null)
            {
                return NotFound();
            }

            var user = GetCurrentUser(HttpContext);
            var notifications = await _context.Notification.Where(x => x.ToID == user.UserId).OrderByDescending(x => x.SentAt).ToListAsync();
            var notificationDTOs = new List<NotificationDTO>();
            foreach (var notification in notifications)
            {
                notificationDTOs.Add(NotificationToDTO(notification));
            }

            return notificationDTOs;
        }

        /// <summary>
        /// Add a notification for a single user
        /// </summary>
        /// <param name="notificationDTO">The notification</param>
        /// <returns>The notification</returns>
        [HttpPost("PostForSingleUser")]
        [Authorize]
        public async Task<ActionResult<Notification>> PostNotification(NotificationDTO notificationDTO)
        {
            if (_context.Notification == null)
            {
                return Problem("Entity set 'WT_DBContext.Notification'  is null.");
            }

            NotificationDTO newNotificationDTO = new NotificationDTO();

            // TODO: May not be best practice
            newNotificationDTO.Title = notificationDTO.Title;
            newNotificationDTO.Description = notificationDTO.Description;
            newNotificationDTO.IsInvite = notificationDTO.IsInvite;
            newNotificationDTO.ProjectID = notificationDTO.ProjectID;
            newNotificationDTO.ProjectName = notificationDTO.ProjectName;
            newNotificationDTO.ClassID = notificationDTO.ClassID;
            newNotificationDTO.ClassName = notificationDTO.ClassName;
            newNotificationDTO.FromID = notificationDTO.FromID;
            newNotificationDTO.FromName = notificationDTO.FromName;
            newNotificationDTO.ToID = notificationDTO.ToID;
            newNotificationDTO.ToName = notificationDTO.ToName;
            newNotificationDTO.SentAt = notificationDTO.SentAt;
            newNotificationDTO.Read = notificationDTO.Read;

            Notification notification = DTOToNotification(newNotificationDTO);

            _context.Notifications.Add(notification);
            await _context.SaveChangesAsync();
            User rec = _context.Users.Where(u => u.UserId == notification.ToID).FirstOrDefault();
            if (rec != null)
            {
                EmailNotification(notification, rec);
            }

            return CreatedAtAction("GetNotification", new { id = notification.Id }, notification);
        }

        /// <summary>
        /// Post a notification to multiple users
        /// </summary>
        /// <param name="users">The users that it will go to</param>
        /// <param name="notificationDTO">The notification</param>
        /// <returns>OK with the notification</returns>
        [HttpPost("PostForUsers")]
        [Authorize]
        public async Task<ActionResult<Notification>> PostForUsers([FromQuery] List<User> users, NotificationDTO notificationDTO)
        {
            if (_context.Notification == null)
            {
                return Problem("Entity set 'WT_DBContext.Notification'  is null.");
            }

            Notification notification = DTOToNotification(notificationDTO);

            foreach (var user in users)
            {
                notification.ToID = user.UserId;
                _context.Notification.Add(notification);
                EmailNotification(notification, user);
            }

            await _context.SaveChangesAsync();
            return CreatedAtAction("GetNotification", new { id = notification.Id }, notification);
        }

        // DELETE: api/Notifications/DeleteNotification/5
        [HttpDelete("DeleteNotification/{id}")]
        [Authorize]
        public async Task<IActionResult> DeleteNotification(int id)
        {
            if (_context.Notification == null)
            {
                return NotFound();
            }
            var notification = await _context.Notification.FindAsync(id);
            if (notification == null)
            {
                return NotFound();
            }

            _context.Notification.Remove(notification);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        /// <summary>
        /// Converts a notification to a DTO
        /// </summary>
        /// <param name="notification">The notification</param>
        /// <returns>The NotificationDTO</returns>
        private NotificationDTO NotificationToDTO(Notification notification)
        {

            Project proj = _context.Projects.Find(notification.AttachedProject);
            Class c = _context.Classes.Find(proj.ClassId);

            return new NotificationDTO
            {
                Id = notification.Id,
                Title = notification.Title,
                Description = notification.Description,
                IsInvite = notification.IsInvite,
                ProjectID = notification.AttachedProject,
                ProjectName = proj.Name,
                ClassID = proj.ClassId,
                ClassName = c.Name,
                FromID = notification.FromID,
                FromName = notification.FromName,
                ToID = notification.ToID,
                ToName = notification.ToName,
                SentAt = notification.SentAt,
                Read = notification.Read,
            };
        }
        /// <summary>
        /// Converts a NotificationDTO to a notification
        /// </summary>
        /// <param name="notification">The DTO</param>
        /// <returns>the Notification</returns>
        private Notification DTOToNotification(NotificationDTO notification)
        {
            return new Notification
            {
                Id = notification.Id,
                Title = notification.Title,
                Description = notification.Description,
                IsInvite = notification.IsInvite,
                AttachedProject = notification.ProjectID,
                FromID = notification.FromID,
                FromName = notification.FromName,
                ToID = notification.ToID,
                ToName = notification.ToName,
                SentAt = notification.SentAt,
                Read = notification.Read,

            };
        }

        /// <summary>
        /// Sends a notification to a user via email
        /// </summary>
        /// <param name="n">The notification</param>
        /// <param name="recipient">The user to receive it</param>
        private void EmailNotification(Notification n, User recipient)
        {
            //don't send emails to unconfirmed addresses. Don't want to spam u0000000...
            if (recipient.EmailConfirmed == false)
            {
                return;
            }
            string message = "You have a new notification from " + n.FromName + "<br><br>" +
                "Title: " + n.Title + "<br><br>" +
                "Description: " + n.Description + "<br><br> <a href=\"worktogether.site\">worktogether.site</a>";
            string addr = recipient.UserName;
            EmailHelper emailHelper = new EmailHelper();
            bool emailResponse = emailHelper.SendEmail(recipient.Email, message, "New Work Together Notification: " + n.Title);

        }
    }
}
