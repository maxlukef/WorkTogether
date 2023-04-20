using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
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

        public UsersController(WT_DBContext context)
        {
            _context = context;
        }

        // GET: api/Users
        [HttpGet]
        public async Task<ActionResult<IEnumerable<User>>> GetUsers()
        {
          if (_context.Users == null)
          {
              return NotFound();
          }
            return await _context.Users.ToListAsync();
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
                user.Id = students[x].Id;
                user.Name = students[x].Name; 
                studentList.Add(user);
            }

            return studentList;
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

        // PUT: api/Users/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutUser(int id, User user)
        {
            if (id != user.Id)
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

        private bool UserExists(int id)
        {
            return (_context.Users?.Any(e => e.Id == id)).GetValueOrDefault();
        }
    }
}
