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
    public class TeamsController : ControllerBase
    {
        private readonly WT_DBContext _context;

        public TeamsController(WT_DBContext context)
        {
            _context = context;
        }

        
        private User GetCurrentUser(HttpContext httpContext)
        {
            string userEmail = httpContext.User.Identity.Name;
            User u1 = _context.Users.Where(u => u.Email == userEmail).FirstOrDefault();
            return u1;
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
                        t.Members.Add(UsertoProfileDTO(i));
                    }

                }
                toReturn.Add(t);
            }
            return toReturn;
        }

        // GET: api/Teams/StudentTeams
        [HttpGet("StudentTeams")]
        [Authorize]
        public async Task<ActionResult<IEnumerable<TeamDTO>>> GetUserTeams()
        {
            User u = GetCurrentUser(HttpContext);
            List<Team> teams = await _context.Teams.Include(t => t.Members).Include(t=> t.Project).Where(t=> t.Members.Contains(u)).ToListAsync();
            //User u2 = await _context.Users.Where(v => v.Email == u.Email).Include(v => v.Teams).FirstOrDefaultAsync();
            List<TeamDTO> toReturn = new List<TeamDTO>();
            foreach(Team t in teams){
                
                    TeamDTO toAdd = new TeamDTO();
                    toAdd.Complete = t.Complete;
                    toAdd.projectId = t.Project.Id;
                    toAdd.Id = t.Id;
                    toAdd.Members = new List<UserProfileDTO>();
                    toAdd.Name = t.Name;

                    foreach (User i in t.Members)
                    {
                        //var userToAdd = await _context.Users.FindAsync(i);
                        if (i != null)
                        {
                            toAdd.Members.Add(UsertoProfileDTO(i));
                        }

                    }
                    toReturn.Add(toAdd);
                
                
            }
            return toReturn;
        }

        // GET: api/Teams/StudentGroupSearches
        [HttpGet("StudentGroupSearches")]
        [Authorize]
        public async Task<ActionResult<IEnumerable<ProjectDTO>>> GetUserGroupSearches()
        {
            User u = GetCurrentUser(HttpContext);
            List<Project> teamprojects = await _context.Teams.Include(t => t.Members).Include(t=>t.Project).Where(t => t.Members.Contains(u)).Select(t=>t.Project).ToListAsync();
            var userclasses = await _context.StudentClasses.Include(s => s.Class).Where(s => s.Student == u).Select(s => s.Class.Id).ToListAsync();
            var userprojects = await _context.Projects.Include(p=> p.ClassId).Where(p => userclasses.Contains(p.ClassId) && !teamprojects.Contains(p)).ToListAsync();
            List<ProjectDTO> toReturn = new List<ProjectDTO>();
            foreach(Project x in userprojects)
            {
                ProjectDTO projectDTO = new ProjectDTO();
                projectDTO.Id = x.Id;
                projectDTO.Name = x.Name;
                projectDTO.Description = x.Description;
                projectDTO.ClassId = x.ClassId;
                projectDTO.Deadline = x.Deadline;
                projectDTO.MaxTeamSize = x.MaxTeamSize;
                projectDTO.MinTeamSize = x.MinTeamSize;
                toReturn.Add(projectDTO);
            }
            return toReturn;
        }

        // GET: api/Teams/5
        [HttpGet("{id}")]
        [Authorize]
        public async Task<ActionResult<TeamDTO>> GetTeam(int id)
        {
            User u = GetCurrentUser(HttpContext);
            Team team = await _context.Teams.Where(t => t.Id == id).Include(t => t.Project).Include(t => t.Members).FirstOrDefaultAsync();
            if (team == null)
            {
                return NotFound();
            }
            if (!team.Members.Contains(u))
            {
                return Unauthorized();
            }
            TeamDTO t = new TeamDTO();
            t.Name = team.Name;
            t.Id = team.Id;
            t.Complete = team.Complete;
            t.projectId = team.Project.Id;
            t.Members = new List<UserProfileDTO>();
            foreach (User cur in team.Members)
            {
                t.Members.Add(UsertoProfileDTO(cur));
            }
            return t;
        }

        // GET: api/Teams/byproject/1
        [HttpGet("byproject/{id}")]
        [Authorize]
        public async Task<ActionResult<TeamDTO>> GetTeamByProjectId(int id)
        {
            User u = GetCurrentUser(HttpContext);
            Team team = await _context.Teams.Include(t => t.Project).Include(t => t.Members).Where(t => t.Project.Id == id && t.Members.Contains(u)).FirstOrDefaultAsync();
            if(team == null)
            {
                return NotFound();
            }
            TeamDTO t = new TeamDTO();
            t.Name = team.Name;
            t.Id = team.Id;
            t.Complete = team.Complete;
            t.projectId = team.Project.Id;
            t.Members = new List<UserProfileDTO>();
            foreach (User cur in team.Members)
            {
                t.Members.Add(UsertoProfileDTO(cur));
            }
            return t;
        }

        /*
        // GET: api/Teams/5
        /// <summary>
        /// Gets a students team based on a project ID and their user ID
        /// </summary>
        /// <param name="projectId">The ID of the project</param>
        /// <param name="studentId">The ID of the student</param>
        /// <returns>The team that the given student is part of for the given project. Otherwise, returns 404 not found.</returns>
        [HttpGet("ByStudentAndProject/{projectId}")]
        [Authorize]
        public async Task<ActionResult<TeamDTO>> GetTeamByStudentAndProjectID(int projectId)
        {
            if (_context.Teams == null || _context.Users == null)
            {
                return NotFound();
            }
            var user = GetCurrentUser(HttpContext);
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
                    UserProfileDTO newUserDTO = UsertoProfileDTO(i);
                    t.Members.Add(newUserDTO);
                }
            }
            

            return t;
        }*/

        [HttpPost("AcceptInvite/{InviteID}")]
        [Authorize]
        public async Task<IActionResult> AcceptInvite(int InviteID)
        {
            User curr = GetCurrentUser(HttpContext);
            Notification invite = _context.Notifications.Find(InviteID);
            if (invite == null) { return NotFound();}
            if (!invite.IsInvite) { return BadRequest(InviteID); }
            User sender = _context.Users.Where(u=> u.UserId == invite.FromID).FirstOrDefault();
            Project project = _context.Projects.Find(invite.AttachedProject);
            Team team = await _context.Teams.Include(t=>t.Members).Include(t=>t.Project).Where(t=>t.Project == project && t.Members.Contains(sender)).Include(t=>t.TeamChat).FirstOrDefaultAsync();

            Team cut = await _context.Teams.Include(t=>t.Members).Include(t=>t.Project).Where(t=>t.Members.Contains(curr) && t.Project == project).FirstOrDefaultAsync();
            if(cut != null)
            {
                return BadRequest("Already on a team for this project!");
            }

            if(team == null)
            {
                team = new Team();
                team.Project = project;
                team.Name = sender.Name + ", " + curr.Name;
                team.Members = new List<User>() { sender, curr };
                team.Complete = false;
                

                Chat newTeamChat = new Chat();
                newTeamChat.Name = team.Name + " Team Chat";
                newTeamChat.Users = team.Members;

                
                team.TeamChat = newTeamChat;
                _context.Chats.Add(newTeamChat);
                _context.Teams.Add(team);
                _context.SaveChanges();
                return Ok();
                
            }
            if(team.Members.Count() >= project.MaxTeamSize)
            {
                return BadRequest("Team full!");
            }
            if(team.Members.Contains(curr)) {
                return BadRequest("Already in this team!");
            }
            Boolean default_name = true;
            foreach(User u in team.Members)
            {
                if(!team.Name.Contains(u.Name)) {default_name = false;}
            }

            if (default_name)
            {
                team.Name += ", " + curr.Name;
            }
            team.Members.Add(curr);
            if (team.TeamChat != null)
            {
                Chat c = _context.Chats.Where(ch=>ch.Id==team.TeamChat.Id).Include(ch=>ch.Users).FirstOrDefault();
                c.Name = team.Name + " Team Chat";
                c.Users.Add(curr);
            }
            _context.SaveChanges();
            return Ok();
        }

        [HttpPost("Rename/{teamId}/{newName}")]
        [Authorize]
        public async Task<IActionResult> Rename(int teamID, string newName)
        {
            User curr = GetCurrentUser(HttpContext);
            Team t = await _context.Teams.Where(t => t.Id == teamID).Include(t=>t.Members).FirstOrDefaultAsync();
            if (!t.Members.Contains(curr)) {
                return Unauthorized();
            }
            t.Name = newName;
            _context.SaveChanges();
            return Ok();
        }

            /*
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

                var inviter = await _context.Users.Where(u => u.UserId == inviterId).FirstOrDefaultAsync();
                var invitee = await _context.Users.Where(u => u.UserId == inviteeId).FirstOrDefaultAsync();
                var project = await _context.Projects.Where(Project => Project.Id == projectId).FirstOrDefaultAsync();

                if (project == null) {
                    return BadRequest("No such project");
                }

                if (inviter == null || invitee == null)
                {
                    return BadRequest("No such user");
                }

                Class c = _context.Classes.Find(project.ClassId);
                var inviteeStudentClass = await _context.StudentClasses.Include(s => s.Student).Include(s => s.Class).Where(StudentClass => StudentClass.Class == c && StudentClass.Student == invitee).ToListAsync();
                var inviterStudentClass = await _context.StudentClasses.Include(s => s.Student).Include(s => s.Class).Where(StudentClass => StudentClass.Class == c && StudentClass.Student == inviter).ToListAsync();
                if(inviteeStudentClass.Count == 0 || inviterStudentClass.Count == 0)
                {
                    return BadRequest("Both users must be students in the class");
                }

                var inviteeTeam = await _context.Teams.Include(T => T.Members).Include(T => T.Project).Where(Team => Team.Project == project && Team.Members.Contains(invitee)).ToListAsync();
                if(inviteeTeam.Count() > 0)
                {
                    return BadRequest("Invitee already part of a team");
                }

                var inviterTeam = await _context.Teams.Include(T => T.Members).Include(T => T.Project).Where(Team => Team.Project == project && Team.Members.Contains(inviter)).ToListAsync();
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
                    t.Project = project;
                    t.Complete = false;
                    t.Name = "Untitled";
                    t.Members = new List<User>();
                    t.Members.Add(inviter);
                }

                t.Members.Add(invitee);
                _context.Teams.Add(t);
                _context.SaveChanges();
                return Ok();




            }*/
            /*

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
            }*/

            // POST: api/Teams
            // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
            /*
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
            }/*

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
            }*/

            private bool TeamExists(int id)
        {
            return (_context.Teams?.Any(e => e.Id == id)).GetValueOrDefault();
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
