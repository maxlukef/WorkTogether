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
    public class StudentClassesController : ControllerBase
    {
        private readonly WT_DBContext _context;

        public StudentClassesController(WT_DBContext context)
        {
            _context = context;
        }

        // GET: api/StudentClasses
        [HttpGet]
        public async Task<ActionResult<IEnumerable<StudentClass>>> GetStudentClasses()
        {
          if (_context.StudentClasses == null)
          {
              return NotFound();
          }
            return await _context.StudentClasses.ToListAsync();
        }

        // GET: api/StudentClasses/5
        [HttpGet("{id}")]
        public async Task<ActionResult<StudentClass>> GetStudentClass(int id)
        {
          if (_context.StudentClasses == null)
          {
              return NotFound();
          }
            var studentClass = await _context.StudentClasses.FindAsync(id);

            if (studentClass == null)
            {
                return NotFound();
            }

            return studentClass;
        }

        // PUT: api/StudentClasses/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutStudentClass(int id, StudentClass studentClass)
        {
            if (id != studentClass.ID)
            {
                return BadRequest();
            }

            _context.Entry(studentClass).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!StudentClassExists(id))
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

        // POST: api/StudentClasses
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<StudentClass>> PostStudentClass(StudentClass studentClass)
        {
          if (_context.StudentClasses == null)
          {
              return Problem("Entity set 'WT_DBContext.StudentClasses'  is null.");
          }
            _context.StudentClasses.Add(studentClass);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetStudentClass", new { id = studentClass.ID }, studentClass);
        }

        // DELETE: api/StudentClasses/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteStudentClass(int id)
        {
            if (_context.StudentClasses == null)
            {
                return NotFound();
            }
            var studentClass = await _context.StudentClasses.FindAsync(id);
            if (studentClass == null)
            {
                return NotFound();
            }

            _context.StudentClasses.Remove(studentClass);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool StudentClassExists(int id)
        {
            return (_context.StudentClasses?.Any(e => e.ID == id)).GetValueOrDefault();
        }
    }
}
