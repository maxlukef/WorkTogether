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
    public class TAClassesController : ControllerBase
    {
        private readonly WT_DBContext _context;

        public TAClassesController(WT_DBContext context)
        {
            _context = context;
        }

        // GET: api/TAClasses
        [HttpGet]
        public async Task<ActionResult<IEnumerable<TAClass>>> GetTAClasses()
        {
          if (_context.TAClasses == null)
          {
              return NotFound();
          }
            return await _context.TAClasses.ToListAsync();
        }

        // GET: api/TAClasses/5
        [HttpGet("{id}")]
        public async Task<ActionResult<TAClass>> GetTAClass(int id)
        {
          if (_context.TAClasses == null)
          {
              return NotFound();
          }
            var tAClass = await _context.TAClasses.FindAsync(id);

            if (tAClass == null)
            {
                return NotFound();
            }

            return tAClass;
        }

        // PUT: api/TAClasses/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutTAClass(int id, TAClass tAClass)
        {
            if (id != tAClass.ID)
            {
                return BadRequest();
            }

            _context.Entry(tAClass).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!TAClassExists(id))
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

        // POST: api/TAClasses
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<TAClass>> PostTAClass(TAClass tAClass)
        {
          if (_context.TAClasses == null)
          {
              return Problem("Entity set 'WT_DBContext.TAClasses'  is null.");
          }
            _context.TAClasses.Add(tAClass);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetTAClass", new { id = tAClass.ID }, tAClass);
        }

        // DELETE: api/TAClasses/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTAClass(int id)
        {
            if (_context.TAClasses == null)
            {
                return NotFound();
            }
            var tAClass = await _context.TAClasses.FindAsync(id);
            if (tAClass == null)
            {
                return NotFound();
            }

            _context.TAClasses.Remove(tAClass);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool TAClassExists(int id)
        {
            return (_context.TAClasses?.Any(e => e.ID == id)).GetValueOrDefault();
        }
    }
}
