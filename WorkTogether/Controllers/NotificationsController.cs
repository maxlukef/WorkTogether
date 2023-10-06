using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
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

        private User GetCurrentUser(HttpContext httpContext)
        {
            string userEmail = httpContext.User.Identity.Name;
            Debug.WriteLine("User Email: " + userEmail);
            User u1 = _context.Users.Where(u => u.Email == userEmail).FirstOrDefault();

            return u1;
        }

        // GET: api/Notifications
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Notification>>> GetNotification()
        {
          if (_context.Notification == null)
          {
              return NotFound();
          }
            return await _context.Notification.ToListAsync();
        }

        // GET: api/Notifications/5
        [HttpGet("{id}")]
        public async Task<ActionResult<NotificationDTO>> GetNotification(int id)
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

            return NotificationToDTO(notification);
        }

        // GET: api/Notifications/GetForCurUser
        [HttpGet("GetForCurUser")]
        [Authorize]
        public async Task<ActionResult<IEnumerable<NotificationDTO>>> GetForCurUser()
        {
            if (_context.Notification == null)
            {
                return NotFound();
            }

            var user = GetCurrentUser(HttpContext);
            var notifications = await _context.Notification.Where(x => x.ToID == user.Id).ToListAsync();
            var notificationDTOs = new List<NotificationDTO>();
            foreach (var notification in notifications)
            {
                notificationDTOs.Add(NotificationToDTO(notification));
            }

            return notificationDTOs;
        }

        // PUT: api/Notifications/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutNotification(int id, NotificationDTO notificationDTO)
        {
            Notification notification = DTOToNotification(notificationDTO);

            if (id != notification.Id)
            {
                return BadRequest();
            }

            _context.Entry(notification).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!NotificationExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Notifications
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Notification>> PostNotification(NotificationDTO notificationDTO)
        {
          if (_context.Notification == null)
          {
              return Problem("Entity set 'WT_DBContext.Notification'  is null.");
          }
            Notification notification = DTOToNotification(notificationDTO);

            _context.Notifications.Add(notification);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetNotification", new { id = notification.Id }, notification);
        }

        [HttpPost("PostForUsers")]
        [Authorize]
        public async Task<ActionResult<Notification>> PostForUsers([FromQuery] List<User> users, NotificationDTO notificationDTO)
        {
            if (_context.Notification == null)
            {
                return Problem("Entity set 'WT_DBContext.Notification'  is null.");
            }

            Notification notification = DTOToNotification(notificationDTO);

            foreach(var user in users)
            {
                notification.ToID = user.Id;
                _context.Notification.Add(notification);
            }

            await _context.SaveChangesAsync();
            return CreatedAtAction("GetNotification", new { id = notification.Id }, notification);
        }

        // DELETE: api/Notifications/5
        [HttpDelete("{id}")]
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

        private bool NotificationExists(int id)
        {
            return (_context.Notification?.Any(e => e.Id == id)).GetValueOrDefault();
        }

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
                ToID = notification.ToID,
                SentAt = notification.SentAt,
                Read = notification.Read,
            };
        }

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
                ToID = notification.ToID,
                SentAt = notification.SentAt,
                Read = notification.Read,

            };
        }
    }
}
