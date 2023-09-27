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
        /// Sends a message to the chat
        /// </summary>
        /// <param name="msg">a SendMessageDTO containing the chat ID and the message to send</param>
        /// <returns>an ActionResult, NotFound if the chat doesn't exist, Unauthorized if the user is not authorized to send to this chat, or Ok if all is well.</returns>
        [HttpPost("send")]
        [Authorize]
        public async Task<ActionResult> SendMessage(SendMessageDTO msg)
        {
            User u = GetCurrentUser(HttpContext);
            Chat c = await _context.Chats.Where(c => c.Id == msg.ChatID).Include(c=>c.Users).FirstOrDefaultAsync();
            if(c == null)
            {
                return NotFound();
            }
            if(!c.Users.Contains(u))
            {
                return Unauthorized();
            }
            Message m = new Message();
            m.Sender = u;
            m.Content = msg.Message;
            m.Sent = DateTime.Now;
            m.chat = c;
            _context.Messages.Add(m);
            c.Messages.Add(m);
            _context.SaveChanges();

            return Ok();
        }

        /// <summary>
        /// Gets the messages for a chat
        /// </summary>
        /// <param name="id">The ID of the chat</param>
        /// <returns>A list of MessageDTOs, or NotFound if there is no such chat, or Unauthorized if the user is not authorized</returns>
        [HttpGet("messages/{id}")]
        [Authorize]
        public async Task<ActionResult<List<MessageDTO>>> GetChatMessages(int id)
        {
            User u = GetCurrentUser(HttpContext);
            Chat c = await _context.Chats.Where(c => c.Id == id).Include(c => c.Users).FirstOrDefaultAsync();
            if (c == null)
            {
                return NotFound();
            }
            if (!c.Users.Contains(u))
            {
                return Unauthorized();
            }
            List<Message> msgs = await _context.Messages.Where(m => m.chat == c).Include(m => m.Sender).OrderByDescending(c => c.Sent).ToListAsync();
            List<MessageDTO> toreturn = new List<MessageDTO>();
            foreach(Message m in msgs)
            {
                toreturn.Add(MessageToDTO(m));
            }
            return toreturn;
        }


        /// <summary>
        /// Renames a chat
        /// </summary>
        /// <param name="chatId">The chat to rename</param>
        /// <param name="newName">The new name for the chat</param>
        /// <returns>200 OK if successful, otherwise notfound if no such chat, or unauthorized if the user cannot make these changes</returns>
        [HttpPost("rename")]
        [Authorize]
        public async Task<ActionResult> Rename(int chatId, string newName)
        {
            User u = GetCurrentUser(HttpContext);
            Chat c = await _context.Chats.Where(c => c.Id == chatId).Include(c=> c.Users).FirstOrDefaultAsync();
            if(c == null)
            {
                return NotFound();
            }
            if (!c.Users.Contains(u))
            {
                return Unauthorized();
            }
            c.Name = newName;
            _context.SaveChanges();
            return Ok();
        }


        /// <summary>
        /// Adds a user to a chat
        /// </summary>
        /// <param name="userId">The ID of the user to add</param>
        /// <param name="chatId">The ID of the chat to add the user to</param>
        /// <returns>NotFound if no such user or chat, Unauthorized if the current user is not in the chat, otherwise OK</returns>
        [HttpPost("adduser/{userId}/{chatId}")]
        [Authorize]
        public async Task<ActionResult> AddToChat(int userId, int chatId)
        {
            User u = GetCurrentUser(HttpContext);
            Chat c = await _context.Chats.Where(c => c.Id == chatId).Include(c => c.Users).FirstOrDefaultAsync();
            if (c == null)
            {
                return NotFound();
            }
            if (!c.Users.Contains(u))
            {
                return Unauthorized();
            }
            User toAdd = await _context.Users.Where(u => u.UserId == userId).FirstOrDefaultAsync();
            if (toAdd == null)
            {
                return NotFound();
            }
            if(c.Users.Contains(toAdd))
            {
                return Ok();
            }
            c.Users.Add(toAdd);
            return Ok();
        }

        /// <summary>
        /// Leaves the chat
        /// </summary>
        /// <param name="chatId">The chat to leave</param>
        /// <returns>NotFound if no such user or chat, Unauthorized if the current user is not in the chat, otherwise OK</returns>
        [HttpPost("leave/{chatId}")]
        [Authorize]
        public async Task<ActionResult> LeaveChat(int chatId)
        {
            User u = GetCurrentUser(HttpContext);
            Chat c = await _context.Chats.Where(c => c.Id == chatId).Include(c => c.Users).FirstOrDefaultAsync();
            if (c == null)
            {
                return NotFound();
            }
            if (!c.Users.Contains(u))
            {
                return Unauthorized();
            }
            c.Users.Remove(u);
            if(c.Users.Count == 1) {
                _context.Chats.Remove(c);
            }
            _context.SaveChanges();
            return Ok();
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


        private static MessageDTO MessageToDTO(Message msg)
        {
            MessageDTO toret = new MessageDTO();
            toret.Content = msg.Content;
            toret.SenderID = msg.Sender.UserId;
            toret.SenderName = msg.Sender.Name;
            string dt = msg.Sent.Date.ToString().Split(" ")[0] + ", " + msg.Sent.Hour.ToString() + ", " + msg.Sent.Minute.ToString();
            toret.Sent = dt;
            return toret;


        }
       
    }




}
