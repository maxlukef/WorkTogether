using System;
using System.Collections.Generic;
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
    public class ClassesController : ControllerBase
    {
        private readonly WT_DBContext _context;

        public ClassesController(WT_DBContext context)
        {
            _context = context;
        }

        // GET: api/Classes
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ClassDTO>>> GetClasses()
        {
            if (_context.Classes == null)
            {
                return NotFound();
            }
            var classList = await _context.Classes.ToListAsync();
            var classDTOList = new List<ClassDTO>();
            foreach (Class c in classList) 
            {
                classDTOList.Add(ClassToDTO(c));
            }

            return Ok(classDTOList);
        }

        // GET: api/Classes/5
        [HttpGet("{id}")]
        public async Task<ActionResult<ClassDTO>> GetClass(int id)
        {
            if (_context.Classes == null)
            {
                return NotFound();
            }
            var @class = ClassToDTO(await _context.Classes.FindAsync(id));

            if (@class == null)
            {
                return NotFound();
            }

            return @class;
        }

        //GET: api/Classes/getbystudentid/10
        [HttpGet("getbystudentID/{id}")]
        [Authorize]
        public async Task<ActionResult<IEnumerable<ClassDTO>>> GetClassesByStudentID(int id)
        {
            string userEmail = HttpContext.User.Identity.Name;
            User u1 = await _context.Users.Where(u => u.Email == userEmail).FirstOrDefaultAsync();

            if (u1.UserId != id)
            {
                return Unauthorized();
            }

            var result = await (from studentClass in _context.StudentClasses
                                join course in _context.Classes on studentClass.Class.Id equals course.Id
                                where studentClass.Student.UserId == id
                                select new { Id = course.Id, ProfessorID = course.ProfessorUserID, Name = course.Name, Description = course.Description }).ToListAsync();

            List<ClassDTO> classList = new List<ClassDTO>();

            foreach (var c in result) {
                classList.Add(ClassToDTO(new Class { Id = c.Id, ProfessorUserID = c.ProfessorID, Name = c.Name,  Description = c.Description}));
            }

            return classList;
        }

        // PUT: api/Classes/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutClass(int id, Class @class)
        {
            if (id != @class.Id)
            {
                return BadRequest();
            }

            _context.Entry(@class).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ClassExists(id))
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

        // POST: api/Classes
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Class>> PostClass(ClassDTO classDTO)
        {
            if (_context.Classes == null)
            {
                return Problem("Entity set 'WT_DBContext.Classes'  is null.");
            }
            
            Class @class = new Class
            {
                Id = classDTO.Id,
                Name = classDTO.Name,
                ProfessorUserID = classDTO.ProfessorID,
                Description = classDTO.Description
            };

            _context.Classes.Add(@class);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetClass", new { id = @class.Id }, @class);
        }

        // DELETE: api/Classes/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteClass(int id)
        {
            if (_context.Classes == null)
            {
                return NotFound();
            }
            var @class = await _context.Classes.FindAsync(id);
            if (@class == null)
            {
                return NotFound();
            }

            _context.Classes.Remove(@class);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ClassExists(int id)
        {
            return (_context.Classes?.Any(e => e.Id == id)).GetValueOrDefault();
        }


        private static ClassDTO ClassToDTO(Class curClass) =>
            new ClassDTO
            { 
                Id = curClass.Id,
                Name = curClass.Name,
                ProfessorID = curClass.ProfessorUserID,
                Description = curClass.Description
            };


    }
}
