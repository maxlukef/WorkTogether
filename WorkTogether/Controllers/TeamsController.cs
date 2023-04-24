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
    public class TeamsController : ControllerBase
    {
        private readonly WT_DBContext _context;

        public TeamsController(WT_DBContext context)
        {
            _context = context;
        }

        // GET: api/Teams
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Team>>> GetTeams()
        {
          if (_context.Teams == null)
          {
              return NotFound();
          }
            return await _context.Teams.ToListAsync();
        }

        // GET: api/Teams/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Team>> GetTeam(int id)
        {
          if (_context.Teams == null)
          {
              return NotFound();
          }
            var team = await _context.Teams.FindAsync(id);

            if (team == null)
            {
                return NotFound();
            }

            return team;
        }

        // POST: api/Teams/invite/1/2
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost("invite/{projectId}/{inviterId}/{inviteeId}")]
        public async Task<IActionResult> InviteToTeam(int projectId, int inviterId, int inviteeId)
        {
            if (_context.Teams == null)
            {
                return Problem("Entity set 'WT_DBContext.Teams' is null.");
            }
            if (_context.Users == null)
            {
                return Problem("Entity set 'WT_DBContext.Users' is null.");
            }
            if (_context.Projects == null)
            {
                return Problem("Entity set 'WT_DBContext.Projects' is null.");
            }

            var inviter = await _context.Users.FindAsync(inviterId);
            var invitee = await _context.Users.FindAsync(inviteeId);
            var project = await _context.Projects.Include(p => p.Class).Where(Project => Project.Id == projectId).ToListAsync();
            if (project.Count == 0) {
                return BadRequest("No such project");
            }
            if (inviter == null || invitee == null)
            {
                return BadRequest("No such user");
            }
            Class c = project[0].Class;
            var inviteeStudentClass = await _context.StudentClasses.Include(s => s.Student).Include(s => s.Class).Where(StudentClass => StudentClass.Class == c && StudentClass.Student == invitee).ToListAsync();
            var inviterStudentClass = await _context.StudentClasses.Include(s => s.Student).Include(s => s.Class).Where(StudentClass => StudentClass.Class == c && StudentClass.Student == inviter).ToListAsync();
            if(inviteeStudentClass.Count == 0 || inviterStudentClass.Count == 0)
            {
                return BadRequest("Both users must be students in the class");
            }

            var inviteeTeam = await _context.Teams.Include(T => T.Members).Include(T => T.Project).Where(Team => Team.Project == project[0] && Team.Members.Contains(invitee)).ToListAsync();
            if(inviteeTeam.Count > 0)
            {
                return BadRequest("Invitee already part of a team");
            }

            var inviterTeam = await _context.Teams.Include(T => T.Members).Include(T => T.Project).Where(Team => Team.Project == project[0] && Team.Members.Contains(inviter)).ToListAsync();
            Team t;
            if(inviterTeam.Count > 0)
            {
                t = inviterTeam[0];
                if (t.Members.Count == t.Project.MaxTeamSize)
                {
                    return BadRequest("Team Full");
                }
                _context.Teams.Remove(t);
            } else { 
                t = new Team();
                t.Project = project[0];
                t.Complete = false;
                t.Name = "Untitled";
                t.Members = new List<User>();
                t.Members.Add(inviter);
            }
            t.Members.Add(invitee);
            _context.Teams.Add(t);
            _context.SaveChanges();
            return Ok();




        }

        // PUT: api/Teams/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutTeam(int id, Team team)
        {
            if (id != team.Id)
            {
                return BadRequest();
            }

            _context.Entry(team).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!TeamExists(id))
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

        // POST: api/Teams
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Team>> PostTeam(Team team)
        {
          if (_context.Teams == null)
          {
              return Problem("Entity set 'WT_DBContext.Teams'  is null.");
          }
            _context.Teams.Add(team);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetTeam", new { id = team.Id }, team);
        }

        // DELETE: api/Teams/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTeam(int id)
        {
            if (_context.Teams == null)
            {
                return NotFound();
            }
            var team = await _context.Teams.FindAsync(id);
            if (team == null)
            {
                return NotFound();
            }

            _context.Teams.Remove(team);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool TeamExists(int id)
        {
            return (_context.Teams?.Any(e => e.Id == id)).GetValueOrDefault();
        }
    }
}
