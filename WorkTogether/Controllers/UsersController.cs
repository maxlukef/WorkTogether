
﻿using System;
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

        // GET: api/Users
        [HttpGet]
        [Authorize]
        public async Task<ActionResult<IEnumerable<User>>> GetUsers()
        {
          if (_context.Users == null)
          {
              return NotFound();
          }
            return await _context.Users.ToListAsync();
        }

        // GET: api/Users/5
        [HttpGet("{id}")]
        public async Task<ActionResult<User>> GetUser(int id)
        {
          if (_context.Users == null)
          {
              return NotFound();
          }
            var user = await _context.Users.FindAsync(id);

            if (user == null)
            {
                return NotFound();
            }

            return user;
        }

        // GET: api/Users/profile/5
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

        //GET: api/Users/studentsbyclassid/10
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

        // PUT: api/Users/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutUser(int id, User user)
        {
            if (id != user.UserId)
            {
                return BadRequest();
            }

            _context.Entry(user).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UserExists(id))
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

        // PUT: api/Users/profile/5
        [HttpPut("profile/{id}")]
        public async Task<IActionResult> PutUserProfile(int id, UserProfileDTO userProfileDTO)
        {
            if (id != userProfileDTO.Id)
            {
                return BadRequest();
            }

            var user = await _context.Users.FindAsync(id);
            if (user == null)
            {
                return NotFound();
            }

            user.Name = userProfileDTO.Name;
            user.Email = userProfileDTO.Email;
            user.Bio = userProfileDTO.Bio;
            user.Major = userProfileDTO.Major;
            user.EmploymentStatus = userProfileDTO.EmploymentStatus;
            user.StudentStatus = userProfileDTO.StudentStatus;
            user.Interests = userProfileDTO.Interests;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                throw;
            }

            return NoContent();
        }

        // POST: api/Users
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<User>> PostUser(User user)
        {
          if (_context.Users == null)
          {
              return Problem("Entity set 'WT_DBContext.Users'  is null.");
          }
            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetUser", new { id = user.Id }, user);
        }

        //Post :api/Users/profile
        [HttpPost("profile")]
        [Authorize]
        public async Task<ActionResult<UserProfileDTO>> PostUserProfile(UserProfileDTO userDTO)
        {
            User u2 = await _um.FindByEmailAsync(userDTO.Email);
            User u1 = await _um.GetUserAsync(User);
            if(u1.UserId != u2.UserId)
            {
                return Unauthorized();
            }
            u2.Name = userDTO.Name;
            u2.Bio = userDTO.Bio;
            u2.Major = userDTO.Major;
            u2.StudentStatus = userDTO.StudentStatus;
            u2.EmploymentStatus = userDTO.EmploymentStatus;

            var result = _um.UpdateAsync(u2);
            if(result.IsCompletedSuccessfully)
            {
                return Ok();
            } else
            {
                return BadRequest();
            }
        }

        // DELETE: api/Users/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            if (_context.Users == null)
            {
                return NotFound();
            }
            var user = await _context.Users.FindAsync(id);
            if (user == null)
            {
                return NotFound();
            }

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        [HttpGet("email/{email}")]
        public async Task<ActionResult<UserProfileDTO>> GetUserProfile(String email)
        {
            if (_context.Users == null)
            {
                return NotFound();
            }

            var user = (from u in _context.Users where u.Email == email select u).First();

            if (user == null)
            {
                return NotFound();
            }

            return UsertoProfileDTO(user);
        }

        private bool UserExists(int id)
        {
            return (_context.Users?.Any(e => e.UserId == id)).GetValueOrDefault();
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

        

  