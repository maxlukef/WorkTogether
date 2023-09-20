using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Net;
using WorkTogether.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using System.Net.Http;

namespace WorkTogether.Controllers
{
    public class ChatController : ControllerBase
    {
        private readonly WT_DBContext _context;

        public ChatController(WT_DBContext context)
        {
            _context = context;
        }

        private User GetCurrentUser(HttpContext httpContext)
        {
            string userEmail = httpContext.User.Identity.Name;
            User u1 = _context.Users.Where(u => u.Email == userEmail).FirstOrDefault();
            return u1;
        }
        
        
        /// <summary>
        /// Creates a new chat with the user in it
        /// </summary>
        /// <param name="userIds">The IDs of the other users to add to the chat</param>
        /// <returns></returns>
        [HttpPost("new")]
        [Authorize]
        public async Task<ActionResult<ChatInfoDTO>> NewChat(List<int> userIds)
        {
            if(userIds.Count == 0)
            {
                return BadRequest("Did not specify users");
            }
            User curr = GetCurrentUser(HttpContext);
            User u;
            Chat chat = new Chat();
            chat.Users = new List<User>{curr};
            string cname = curr.Name;
            foreach (int id in userIds){
                u = await this._context.Users.Where(s => s.UserId == id).FirstOrDefaultAsync();
                if (u == null)
                {
                    return BadRequest("User " + id + " does not exist");
                }
                chat.Users.Add(u);
                cname += (", " + u.Name);
            }
            chat.Name = cname;
            _context.Chats.Add(chat);
            _context.SaveChanges();
            return ChatToDto(chat);
        }
        
        /// <summary>
        /// Gets ChatInfoDTOs of all of the current user's chats.
        /// </summary>
        /// <returns>a list of ChatInfoDTOs for each chat that the current user is a part of.</returns>
        [HttpGet("currentuserchats")]
        [Authorize]
        public async Task<ActionResult<List<ChatInfoDTO>>> GetCurrentUserChats()
        {
            string userEmail = HttpContext.User.Identity.Name;
            User u1 = await _context.Users.Where(u => u.Email == userEmail).Include(u => u.Chats).FirstOrDefaultAsync();
            var userchats = await _context.Chats.Include(c => c.Users).Where(c => c.Users.Contains(u1)).ToListAsync();
            List<ChatInfoDTO> toreturn = new List<ChatInfoDTO>();
            foreach(Chat chat in u1.Chats)
            {
                toreturn.Add(ChatToDto(chat));
            }

            return toreturn;
        }

        private static ChatInfoDTO ChatToDto(Chat chat)
        {
            ChatInfoDTO chatInfo = new ChatInfoDTO();
            chatInfo.Id = chat.Id;
            chatInfo.Name = chat.Name;
            chatInfo.Users = new List<UserProfileDTO>();
            foreach(User u in chat.Users) {
                chatInfo.Users.Add(UsertoProfileDTO(u));
            }
            return chatInfo;
        }

        private static UserProfileDTO UsertoProfileDTO(User user) =>
    new UserProfileDTO
    {
        Id = user.UserId,
        Name = user.Name,
        Email = user.Email,
        Bio = user.Bio,
        Major = user.Major,
        EmploymentStatus = user.EmploymentStatus,
        StudentStatus = user.StudentStatus,
        Interests = user.Interests
    };
    }


}
