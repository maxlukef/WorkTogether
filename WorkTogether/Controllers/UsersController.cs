
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using WorkTogether.Models;

namespace WorkTogether.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly WT_DBContext _context;
        private readonly UserManager<User> _um;

        public UsersController(WT_DBContext context, UserManager<User> um)
        {
            _context = context;
            _um = um;
        }


        /// <summary>
        /// Get a user's profile
        /// </summary>
        /// <param name="id">The user's ID</param>
        /// <returns>a UserProfileDTO</returns>
        [HttpGet("profile/{id}")]
        public async Task<ActionResult<UserProfileDTO>> GetUserProfile(int id)
        {
            if (_context.Users == null)
            {
                return NotFound();
            }

            var user = await _context.Users.Where(u => u.UserId == id).FirstOrDefaultAsync();
            if (user == null)
            {
                return NotFound();
            }

            return UsertoProfileDTO(user);
        }

        /// <summary>
        /// Gets a JSON array of all students in a class.
        /// </summary>
        /// <param name="id">The class ID</param>
        /// <returns>A json array of UserProfileDTOs representing all students in the class</returns>
        [HttpGet("studentsbyclassID/{id}")]
        public async Task<ActionResult<IEnumerable<UserProfileDTO>>> GetStudentsByClassID(int id)
        {
            if (_context.Users == null)
            {
                return NotFound();
            }
            var @students = await _context.StudentClasses.Include(row => row.Student).Where<StudentClass>(row => row.Class.Id == id).Select(p => p.Student).ToListAsync();

            var studentList = new List<UserProfileDTO>();
            for (int x = 0; x < students.Count; x++)
            {
                UserProfileDTO user = new UserProfileDTO();
                user.StudentStatus = students[x].StudentStatus;
                user.Interests = students[x].Interests;
                user.Email = students[x].Email;
                user.EmploymentStatus = students[x].EmploymentStatus;
                user.Bio = students[x].Bio;
                user.Major = students[x].Major;
                user.Id = students[x].UserId;
                user.Name = students[x].Name;
                studentList.Add(user);
            }

            return studentList;
        }


        /// <summary>
        /// Used for updating user profiles.
        /// </summary>
        /// <param name="userDTO">The UserProfileDTO</param>
        /// <returns>the new User profile in DTO form</returns>
        [HttpPost("profile")]
        [Authorize]
        public async Task<ActionResult<UserProfileDTO>> PostUserProfile(UserProfileDTO userDTO)
        {
            User u2;
            try
            {
                u2 = await _context.Users.Where(u => u.UserId == userDTO.Id).FirstOrDefaultAsync();
            }
            catch
            {
                return BadRequest("User ID does not exist");
            }
            string userEmail = HttpContext.User.Identity.Name;
            User u1 = await _context.Users.Where(u => u.Email == userEmail).FirstOrDefaultAsync();
            if (u1.UserId != u2.UserId)
            {
                return Unauthorized();
            }
            u2.Name = userDTO.Name;
            u2.Bio = userDTO.Bio;
            u2.Major = userDTO.Major;
            u2.StudentStatus = userDTO.StudentStatus;
            u2.EmploymentStatus = userDTO.EmploymentStatus;
            u2.Interests = userDTO.Interests;

            var result = _um.UpdateAsync(u2);
            if (result.IsCompletedSuccessfully)
            {
                return Ok();
            }
            else
            {
                return BadRequest();
            }
        }

        /// <summary>
        /// Converts a User into a UserProfileDTO
        /// </summary>
        /// <param name="user">The user</param>
        /// <returns>a UserProfileDTO</returns>
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



