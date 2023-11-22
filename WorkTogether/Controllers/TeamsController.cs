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

        /// <summary>
        /// Gets the current user from the HttpContext for the calling function
        /// </summary>
        /// <param name="httpContext">The HttpContext</param>
        /// <returns>The user calling the controller</returns>
        private User GetCurrentUser(HttpContext httpContext)
        {
            string userEmail = httpContext.User.Identity.Name;
            User u1 = _context.Users.Where(u => u.Email == userEmail).FirstOrDefault();
            return u1;
        }



        /// <summary>
        /// Gets all teams that the user is a part of
        /// </summary>
        /// <returns>A list of TeamDTOs</returns>
        [HttpGet("StudentTeams")]
        [Authorize]
        public async Task<ActionResult<IEnumerable<TeamDTO>>> GetUserTeams()
        {
            User u = GetCurrentUser(HttpContext);
            List<Team> teams = await _context.Teams.Include(t => t.Members).Include(t => t.Project).Where(t => t.Members.Contains(u)).ToListAsync();
            //User u2 = await _context.Users.Where(v => v.Email == u.Email).Include(v => v.Teams).FirstOrDefaultAsync();
            List<TeamDTO> toReturn = new List<TeamDTO>();
            foreach (Team t in teams)
            {

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

        /// <summary>
        /// Gets all projects that the current user is looking for a team for
        /// </summary>
        /// <returns>A list of ProjectDTOs</returns>
        [HttpGet("StudentGroupSearches")]
        [Authorize]
        public async Task<ActionResult<IEnumerable<ProjectDTO>>> GetUserGroupSearches()
        {
            User u = GetCurrentUser(HttpContext);
            List<Project> teamprojects = await _context.Teams.Include(t => t.Members).Include(t => t.Project).Where(t => t.Members.Contains(u)).Select(t => t.Project).ToListAsync();
            var userclasses = await _context.StudentClasses.Include(s => s.Class).Where(s => s.Student == u).Select(s => s.Class.Id).ToListAsync();
            var userprojects = await _context.Projects.Include(p => p.ClassId).Where(p => userclasses.Contains(p.ClassId) && !teamprojects.Contains(p)).ToListAsync();
            List<ProjectDTO> toReturn = new List<ProjectDTO>();
            foreach (Project x in userprojects)
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

        /// <summary>
        /// Gets a team by its ID
        /// </summary>
        /// <param name="id">the team ID</param>
        /// <returns>The team in DTO form</returns>
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

        /// <summary>
        /// Get the current user's team for a project
        /// </summary>
        /// <param name="id">The project ID</param>
        /// <returns>The team in DTO form</returns>
        [HttpGet("byproject/{id}")]
        [Authorize]
        public async Task<ActionResult<TeamDTO>> byproject(int id)
        {
            User u = GetCurrentUser(HttpContext);
            Team team = await _context.Teams.Include(t => t.Project).Include(t => t.Members).Where(t => t.Project.Id == id && t.Members.Contains(u)).FirstOrDefaultAsync();
            if (team == null)
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


        // GET: api/Teams/allteamsinproject/1
        [HttpGet("allteamsinproject/{id}")]
        [Authorize]
        public async Task<ActionResult<List<TeamDTO>>> allteamsinproject(int id)
        {
            List<Team> teams = await _context.Teams.Include(t => t.Project).Include(t => t.Members).Where(t => t.Project.Id == id).ToListAsync();
            if (teams == null)
            {
                return NotFound();
            }
            List<TeamDTO> allTeams = new List<TeamDTO>();

            foreach(Team team in teams)
            {
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

                allTeams.Add(t);
            }

            return allTeams;
        }


        // GET: api/Teams/5
        /// <summary>
        /// Lets the current user accept a team invite
        /// </summary>
        /// <param name="InviteID">The ID of the invite notification</param>
        /// <returns>200 OK if successful</returns>
        [HttpPost("AcceptInvite/{InviteID}")]
        [Authorize]
        public async Task<IActionResult> AcceptInvite(int InviteID)
        {
            User curr = GetCurrentUser(HttpContext);
            Notification invite = _context.Notifications.Find(InviteID);
            if (invite == null) { return NotFound(); }
            if (!invite.IsInvite) { return BadRequest(InviteID); }
            User sender = _context.Users.Where(u => u.UserId == invite.FromID).FirstOrDefault();
            Project project = _context.Projects.Find(invite.AttachedProject);
            Team team = await _context.Teams.Include(t => t.Members).Include(t => t.Project).Where(t => t.Project == project && t.Members.Contains(sender)).Include(t => t.TeamChat).FirstOrDefaultAsync();

            Team cut = await _context.Teams.Include(t => t.Members).Include(t => t.Project).Where(t => t.Members.Contains(curr) && t.Project == project).FirstOrDefaultAsync();
            if (cut != null)
            {
                return BadRequest("Already on a team for this project!");
            }

            if (team == null)
            {
                team = new Team();
                team.Project = project;
                team.Name = sender.Name + ", " + curr.Name;
                team.Members = new List<User>() { sender, curr };
                team.Complete = false;
                team.CompleteMilestones = new List<Milestone>();


                Chat newTeamChat = new Chat();
                newTeamChat.Name = team.Name + " Team Chat";
                newTeamChat.Users = team.Members;


                team.TeamChat = newTeamChat;
                _context.Chats.Add(newTeamChat);
                _context.Teams.Add(team);
                _context.SaveChanges();
                return Ok();

            }
            if (team.Members.Count() >= project.MaxTeamSize)
            {
                return BadRequest("Team full!");
            }
            if (team.Members.Contains(curr))
            {
                return BadRequest("Already in this team!");
            }
            Boolean default_name = true;
            foreach (User u in team.Members)
            {
                if (!team.Name.Contains(u.Name)) { default_name = false; }
            }

            if (default_name)
            {
                team.Name += ", " + curr.Name;
            }
            team.Members.Add(curr);
            if (team.TeamChat != null)
            {
                Chat c = _context.Chats.Where(ch => ch.Id == team.TeamChat.Id).Include(ch => ch.Users).FirstOrDefault();
                c.Name = team.Name + " Team Chat";
                c.Users.Add(curr);
            }
            _context.SaveChanges();
            return Ok();
        }

        /// <summary>
        /// Rename a team (for team members)
        /// </summary>
        /// <param name="teamID">The ID of the team</param>
        /// <param name="newName">The new name for the team</param>
        /// <returns>200 OK if successful</returns>
        [HttpPost("Rename/{teamId}/{newName}")]
        [Authorize]
        public async Task<IActionResult> Rename(int teamID, string newName)
        {
            User curr = GetCurrentUser(HttpContext);
            Team t = await _context.Teams.Where(t => t.Id == teamID).Include(t => t.Members).FirstOrDefaultAsync();
            if (!t.Members.Contains(curr))
            {
                return Unauthorized();
            }
            t.Name = newName;
            _context.SaveChanges();
            return Ok();
        }


        /// <summary>
        /// Converts a User to a UserProfileDTO
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
