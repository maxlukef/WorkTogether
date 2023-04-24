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
        public async Task<ActionResult<IEnumerable<TeamDTO>>> GetTeams()
        {
          if (_context.Teams == null)
          {
              return NotFound();
          }
            var teams = await _context.Teams.Include(T => T.Project).ToListAsync();

            List<TeamDTO> toReturn = new List<TeamDTO>();
            foreach(var team in teams)
            {
                var teamMembers = await _context.Teams.Include(T => T.Members).Where(Team => Team.Id == team.Id).Select(Team => Team.Members).FirstOrDefaultAsync();

                if (teamMembers == null)
                {
                    return NotFound();
                }

                TeamDTO t = new TeamDTO();
                t.Complete = team.Complete;
                t.projectId = team.Project.Id;
                t.Id = team.Id;
                t.Members = new List<UserProfileDTO>();

                foreach (User i in teamMembers)
                {
                    //var userToAdd = await _context.Users.FindAsync(i);
                    if (i != null)
                    {
                        UserProfileDTO newUserDTO = new UserProfileDTO();
                        newUserDTO.StudentStatus = i.StudentStatus;
                        newUserDTO.Interests = i.Interests;
                        newUserDTO.Email = i.Email;
                        newUserDTO.Name = i.Name;
                        newUserDTO.EmploymentStatus = i.EmploymentStatus;
                        newUserDTO.Bio = i.Bio;
                        newUserDTO.Id = i.Id;
                        t.Members.Add(newUserDTO);
                    }

                }
                toReturn.Add(t);
            }
            return toReturn;
        }

        // GET: api/Teams/5
        [HttpGet("{id}")]
        public async Task<ActionResult<TeamDTO>> GetTeam(int id)
        {
          if (_context.Teams == null)
          {
              return NotFound();
          }
          var team = await _context.Teams.Include(T => T.Project).Where(Team => Team.Id == id).FirstOrDefaultAsync();

          if (team == null)
          {
            return NotFound();
          }
          var teamMembers = await _context.Teams.Include(T => T.Members).Where(Team => Team.Id == id).Select(Team => Team.Members).FirstOrDefaultAsync();

            if (teamMembers == null)
            {
                return NotFound();
            }

            TeamDTO t = new TeamDTO();
            t.Complete = team.Complete;
            t.projectId = team.Project.Id;
            t.Id = team.Id;
            t.Members = new List<UserProfileDTO>();

            foreach (User i in teamMembers)
            {
                //var userToAdd = await _context.Users.FindAsync(i);
                if (i != null)
                {
                    UserProfileDTO newUserDTO = new UserProfileDTO();
                    newUserDTO.StudentStatus = i.StudentStatus;
                    newUserDTO.Interests = i.Interests;
                    newUserDTO.Email = i.Email;
                    newUserDTO.Name = i.Name;
                    newUserDTO.EmploymentStatus = i.EmploymentStatus;
                    newUserDTO.Bio = i.Bio;
                    newUserDTO.Id = i.Id;
                    t.Members.Add(newUserDTO);
                }

            }

            return t;
        }

        // GET: api/Teams/5
        /// <summary>
        /// Gets a students team based on a project ID and their user ID
        /// </summary>
        /// <param name="projectId">The ID of the project</param>
        /// <param name="studentId">The ID of the student</param>
        /// <returns>The team that the given student is part of for the given project. Otherwise, returns 404 not found.</returns>
        [HttpGet("ByStudentAndProject/{projectId}/{studentId}")]
        public async Task<ActionResult<TeamDTO>> GetTeamByStudentAndProjectID(int projectId, int studentId)
        {
            if (_context.Teams == null || _context.Users == null)
            {
                return NotFound();
            }
            var user = await _context.Users.FindAsync(studentId);
            if (user == null)
            {
                return NotFound();
            }
            var teamId = await _context.Teams.Include(T => T.Project).Include(T => T.Members).Where(Team => Team.Project.Id == projectId && Team.Members.Contains(user)).Select(Team => Team.Id).FirstOrDefaultAsync();

            var team = await _context.Teams.FindAsync(teamId);

            if (team == null)
            {
                return NotFound();
            }

            var teamMembers = await _context.Teams.Include(T => T.Members).Where(Team => Team.Id == teamId).Select(Team => Team.Members).FirstOrDefaultAsync();

            TeamDTO t = new TeamDTO();
            t.Name = team.Name;
            t.Id = team.Id;
            t.Complete = team.Complete;
            t.projectId = projectId;
            t.Members = new List<UserProfileDTO>();
            
            foreach(User i in teamMembers)
            {
                if (i != null)
                {
                    UserProfileDTO newUserDTO = new UserProfileDTO();
                    newUserDTO.StudentStatus = i.StudentStatus;
                    newUserDTO.Interests = i.Interests;
                    newUserDTO.Email = i.Email;
                    newUserDTO.Name = i.Name;
                    newUserDTO.EmploymentStatus = i.EmploymentStatus;
                    newUserDTO.Bio = i.Bio;
                    newUserDTO.Id = i.Id;
                    t.Members.Add(newUserDTO);
                }
            }
            

            return t;
        }

        // POST: api/Teams/invite/1/2
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        /// <summary>
        /// Currently,this adds a student to a team. In the future, it will send an invitation
        /// </summary>
        /// <param name="projectId">The ID of the project that this team is working on.</param>
        /// <param name="inviterId">The ID of the student that sent the invitation</param>
        /// <param name="inviteeId">The ID of the student who is being invited</param>
        /// <returns>If both students can be added to the team, returns HTTP 200 OK. Otherwise, will return 400. 
        /// Both students must be in the same class, and if the inviter is already on a team then it cannot be full.
        /// The Invitee must not already be part of a team.</returns>
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
                _context.SaveChanges();
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
