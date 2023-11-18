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
    public class MilestonesController : ControllerBase
    {
        private readonly WT_DBContext _context;

        public MilestonesController(WT_DBContext context)
        {
            _context = context;
        }

        private User GetCurrentUser(HttpContext httpContext)
        {
            string userEmail = httpContext.User.Identity.Name;
            User u1 = _context.Users.Where(u => u.Email == userEmail).FirstOrDefault();
            return u1;
        }

        private MilestoneDTO MilestoneToDTO(Milestone ms)
        {
            MilestoneDTO md = new MilestoneDTO();
            md.Id = ms.Id;
            md.ProjectID = ms.Project.Id;
            md.Title = ms.Title;
            md.Description = ms.Description;
            md.Deadline = ms.Deadline;
            md.Id = ms.Id;
            return md;
        }

        private MilestoneDTOWithComplete MilestoneToDTOComp(Milestone ms, bool complete)
        {
            MilestoneDTOWithComplete md = new MilestoneDTOWithComplete();
            md.ProjectID = ms.Project.Id;
            md.Title = ms.Title;
            md.Description = ms.Description;
            md.Deadline = ms.Deadline;
            md.Complete = complete;
            return md;
        }


        [HttpGet("NextMilestoneDue/{pid}")]
        [Authorize]
        public async Task<ActionResult<MilestoneDTO>> NextMilestoneDue(int pid)
        {
            Milestone m = await _context.Milestones.Where(p => p.Id == pid && p.Deadline > DateTime.Now).OrderBy(d => d.Deadline).FirstOrDefaultAsync();

            if (m == null)
            {
                return NotFound();
            }

            MilestoneDTO mDTO = MilestoneToDTO(m);

            return mDTO;
        }

        [HttpGet("MilestoneCompletions/{pid}")]
        [Authorize]
        public async Task<ActionResult<Dictionary<String, String>>> MilestoneCompletions(int pid)
        {
            List<Team> teams = await _context.Teams.Include(t => t.CompleteMilestones).Where(t => t.Project.Id == pid).ToListAsync();

            if (teams == null) { return NotFound(); }

            Dictionary<String, int> completions = new Dictionary<String, int>();

            foreach (Milestone m in teams[0].CompleteMilestones)
            {
                completions[m.Title] = 0;
            }

            foreach(Team t in teams)
            {
                foreach (Milestone m in t.CompleteMilestones)
                {
                    completions[m.Title] += 1;
                }
            }

            foreach(String m in completions.Keys)
            {
                completions[m] = completions[m] / teams.Count;
            }
            return null;
        }



        //Get all milestones for a project. This doesn't include the complete tag.
        [HttpGet("ProjectMilestones/{pid}")]
        [Authorize]
        public async Task<ActionResult<List<MilestoneDTO>>> GetMilestonesForProject(int pid)
        {
            User curr = GetCurrentUser(HttpContext);
            Project p = await _context.Projects.Where(p => p.Id == pid).FirstOrDefaultAsync();
            if(p == null)
            {
                return BadRequest();
            }
            Class c = await _context.Classes.Where(c=>c.Id == p.ClassId).Include(c=>c.Professor).FirstOrDefaultAsync();
            if(c == null)
            {
                return Problem();
            }
            Team t = await _context.Teams.Include(t => t.Members).Include(t => t.Project).Where(t => t.Members.Contains(curr) && t.Project == p).FirstOrDefaultAsync();
            if(t == null && c.Professor.UserId != curr.UserId)
            {
                return Unauthorized();
            }
            List<Milestone> ms = await _context.Milestones.Include(m => m.Project).Where(m => m.Project.Id == pid).ToListAsync();
            
            List<MilestoneDTO> md = new List<MilestoneDTO>();
            foreach (var msItem in ms)
            {
                md.Add(MilestoneToDTO(msItem));
            }
            return md;

        }

        //Get all milestones for a project, including the complete tag (for the current users team for that project). This is to be used by students who are on a team.
        //GET: /api/Milestones/ProjectMilestonesWithComplete/5
        [HttpGet("ProjectMilestonesWithComplete/{pid}")]
        [Authorize]
        public async Task<ActionResult<List<MilestoneDTOWithComplete>>> GetMilestonesForProjectWithComplete(int pid)
        {
            User curr = GetCurrentUser(HttpContext);
            Team t = await _context.Teams.Include(t => t.Members).Include(t => t.Project).Where(t => t.Project.Id == pid && t.Members.Contains(curr)).Include(t=>t.CompleteMilestones).FirstOrDefaultAsync();
            if(t==null)
            {
                return BadRequest();
            }
            List<Milestone> ms = await _context.Milestones.Include(m => m.Project).Where(m => m.Project.Id == pid).ToListAsync();
            List<MilestoneDTOWithComplete> md = new List<MilestoneDTOWithComplete>();
            foreach (var msItem in ms)
            {
                bool comp = t.CompleteMilestones.Contains(msItem);
                md.Add(MilestoneToDTOComp(msItem, comp));
            }
            return md;

        }

        //Allows professors to create milestones
        //POST: /api/Milestones/Create
        [HttpPost("Create")]
        [Authorize]
        public async Task<ActionResult> CreateMilestone(CreateMilestoneDTO milestoneDTO)
        {
            User curr = GetCurrentUser(HttpContext);
            Project p = await _context.Projects.Where(p => p.Id == milestoneDTO.ProjectID).FirstOrDefaultAsync();
            if (p == null)
            {
                return NotFound(milestoneDTO);
            }
            Class c = await _context.Classes.Where(c => c.Id == p.ClassId).Include(c => c.Professor).FirstOrDefaultAsync();
            if (c == null)
            {
                return BadRequest();
            }
            if (c.Professor != curr)
            {
                return Unauthorized();
            }
            Milestone newms = new Milestone();
            newms.Project = p;
            newms.Deadline = milestoneDTO.Deadline;
            newms.Description = milestoneDTO.Description;
            newms.Title = milestoneDTO.Title;
            _context.Milestones.Add(newms);
            _context.SaveChanges();
            return Ok();
        }

        //Mark a milestone complete for your team
        //POST: /api/Milestones/MarkComplete/5
        [HttpPost("MarkComplete/{id}")]
        [Authorize]
        public async Task<ActionResult> MarkComplete(int id)
        {
            User curr = GetCurrentUser(HttpContext);
            Milestone m = await _context.Milestones.Where(m=>m.Id == id).Include(m=> m.Project).FirstOrDefaultAsync();
            if (m == null)
            {
                return NotFound(m);
            }
            Team t =await _context.Teams.Include(t => t.Project).Include(t => t.Members).Where(t => t.Project == m.Project && t.Members.Contains(curr)).Include(t=>t.CompleteMilestones).FirstOrDefaultAsync();
            if(t==null)
            {
                return Unauthorized();
            }
            if (t.CompleteMilestones.Contains(m))
            {
                return BadRequest();
            }
            t.CompleteMilestones.Add(m);
            _context.SaveChanges();
            return Ok();
        }

        //Mark a milestone incomplete for your team
        //POST: /api/Milestones/MarkIncomplete/5
        [HttpPost("MarkIncomplete/{id}")]
        [Authorize]
        public async Task<ActionResult> MarkIncomplete(int id)
        {
            User curr = GetCurrentUser(HttpContext);
            Milestone m = await _context.Milestones.Where(m => m.Id == id).Include(m => m.Project).FirstOrDefaultAsync();
            if (m == null)
            {
                return NotFound(m);
            }
            Team t = await _context.Teams.Include(t => t.Project).Include(t => t.Members).Where(t => t.Project == m.Project && t.Members.Contains(curr)).Include(t => t.CompleteMilestones).FirstOrDefaultAsync();
            if (t == null)
            {
                return Unauthorized();
            }
            if (!t.CompleteMilestones.Contains(m))
            {
                return BadRequest();
            }
            t.CompleteMilestones.Remove(m);
            _context.SaveChanges();
            return Ok();
        }

        //Edit a milestone(for professor)
        //POST: api/Milestones/Edit
        [HttpPost("Edit")]
        [Authorize]
        public async Task<ActionResult> EditMilestone(MilestoneDTO milestoneDTO)
        {
            User curr = GetCurrentUser(HttpContext);
            Milestone m = await _context.Milestones.Where(m => m.Id == milestoneDTO.Id).FirstOrDefaultAsync();
            if (m == null)
            {
                return NotFound();
            }
            Project p = await _context.Projects.Where(p => p.Id == milestoneDTO.ProjectID).FirstOrDefaultAsync();
            if (p == null)
            {
                return NotFound(milestoneDTO);
            }
            Class c = await _context.Classes.Where(c => c.Id == p.ClassId).Include(c => c.Professor).FirstOrDefaultAsync();
            if (c == null)
            {
                return BadRequest();
            }
            if (c.Professor != curr)
            {
                return Unauthorized();
            }
            m.Deadline = milestoneDTO.Deadline;
            m.Description = milestoneDTO.Description;
            m.Title = milestoneDTO.Title;
            _context.SaveChanges();
            return Ok();
        }

        //Get a milestone by its id
        // GET: api/Milestones/ById/5
        [HttpGet("ById/{id}")]
        [Authorize]
        public async Task<ActionResult<MilestoneDTO>> GetMilestone(int id)
        {
            User curr = GetCurrentUser(HttpContext);
            if (_context.Milestones == null)
            {
                return NotFound();
            }
            Milestone m = await _context.Milestones.Include(m=>m.Project).Where(m=>m.Id == id).FirstOrDefaultAsync();
            if (m == null)
            {
                return NotFound();
            }
            Class c = await _context.Classes.Where(c => c.Id == m.Project.ClassId).Include(c => c.Professor).FirstOrDefaultAsync();
            Team t =  await _context.Teams.Include(t => t.Project).Include(t => t.Members).Where(t => t.Members.Contains(curr) && t.Project == m.Project).FirstOrDefaultAsync();

            if(t == null && c.Professor.UserId != curr.UserId)
            {
                return Unauthorized();
            }
            

            return MilestoneToDTO(m);
        }

        //Get a milestone by its id with its complete tag(have to be on a team for the project)
        // GET: api/Milestones/ByIdWithComplete/5
        [HttpGet("ByIdWithComplete/{id}")]
        [Authorize]
        public async Task<ActionResult<MilestoneDTOWithComplete>> GetMilestoneWithComplete(int id)
        {
            User curr = GetCurrentUser(HttpContext);
            if (_context.Milestones == null)
            {
                return NotFound();
            }
            Milestone m = await _context.Milestones.Include(m => m.Project).Where(m => m.Id == id).FirstOrDefaultAsync();
            if (m == null)
            {
                return NotFound();
            }
            Class c = await _context.Classes.Where(c => c.Id == m.Project.ClassId).Include(c => c.Professor).FirstOrDefaultAsync();
            Team t = await _context.Teams.Include(t => t.Project).Include(t => t.Members).Include(t=>t.CompleteMilestones).Where(t => t.Members.Contains(curr) && t.Project == m.Project).FirstOrDefaultAsync();

            if (t == null)
            {
                return Unauthorized();
            }


            return MilestoneToDTOComp(m, t.CompleteMilestones.Contains(m));
        }

        // Gets the number of teams that have marked a milestone complete, and all teams in the project. For the prof dashboard
        // GET: api/NumComplete/5
        [HttpGet("NumComplete/{id}")]
        [Authorize]
        public async Task<ActionResult<CompleteRatioDTO>> GetNumComplete(int id)
        {
            User curr = GetCurrentUser(HttpContext);
            Milestone m = await _context.Milestones.Where(m => m.Id == id).Include(m => m.Project).FirstOrDefaultAsync();
            if (m == null)
            {
                return NotFound();
            }
            Project p = await _context.Projects.Where(p => p.Id == m.Project.Id).FirstOrDefaultAsync();
            if (p == null)
            {
                return NotFound();
            }
            Class c = _context.Classes.Find(p.ClassId);
            if (curr.UserId != c.Professor.UserId)
            {
                return Unauthorized();
            }

            int complete = await _context.Teams.Include(t => t.CompleteMilestones).Where(t => t.CompleteMilestones.Contains(m)).CountAsync();
            int countteams = await _context.Teams.Include(t => t.Project).Where(t => t.Project == p).CountAsync();

            CompleteRatioDTO toret = new CompleteRatioDTO();
            toret.md = MilestoneToDTO(m);
            toret.complete = complete;
            toret.numteams = countteams;
            return toret;
        }

        // Gets the number of teams that have marked a milestone complete, for all teams in the project, and all teams in the project. For the prof dashboard
        // GET: api/NumCompleteForProj/5
        [HttpGet("NumCompleteForProj/{id}")]
        [Authorize]
        public async Task<ActionResult<List<CompleteRatioDTO>>> GetNumCompleteForProject(int id)
        {
            User curr = GetCurrentUser(HttpContext);

            Project p = await _context.Projects.Where(p => p.Id == id).FirstOrDefaultAsync();
            if (p == null)
            {
                return NotFound();
            }
            Class c = _context.Classes.Find(p.ClassId);
            if (curr.UserId != c.Professor.UserId)
            {
                return Unauthorized();
            }
            List<CompleteRatioDTO> clist = new List<CompleteRatioDTO>();
            List<Milestone> mss = await _context.Milestones.Include(m => m.Project).Where(m => m.Project == p).ToListAsync();
            foreach (Milestone m in mss)
            {
                int complete = await _context.Teams.Include(t => t.CompleteMilestones).Where(t => t.CompleteMilestones.Contains(m)).CountAsync();
                int countteams = await _context.Teams.Include(t => t.Project).Where(t => t.Project == p).CountAsync();

                CompleteRatioDTO toret = new CompleteRatioDTO();
                toret.md = MilestoneToDTO(m);
                toret.complete = complete;
                toret.numteams = countteams;
                clist.Add(toret);
            }
            return clist;
        }

        // Gets the number of teams that have marked a milestone complete, and all teams in the project. For the prof dashboard
        // GET: api/NumComplete/5
        [HttpGet("TeamsMilestoneComplete/{id}")]
        [Authorize]
        public async Task<ActionResult<CompleteIncompleteTeamsDTO>> GetCompleteIncompleteTeams(int id)
        {
            User curr = GetCurrentUser(HttpContext);
            Milestone m = await _context.Milestones.Where(m => m.Id == id).Include(m => m.Project).FirstOrDefaultAsync();
            if (m == null)
            {
                return NotFound();
            }
            Project p = await _context.Projects.Where(p => p.Id == m.Project.Id).FirstOrDefaultAsync();
            if (p == null)
            {
                return NotFound();
            }
            Class c = _context.Classes.Find(p.ClassId);
            if (curr.UserId != c.Professor.UserId)
            {
                return Unauthorized();
            }

            List<Team> complete = await _context.Teams.Include(t => t.CompleteMilestones).Where(t => t.CompleteMilestones.Contains(m)).Include(t=>t.Members).Include(t=>t.Project).ToListAsync();
            List<Team> incomplete = await _context.Teams.Include(t => t.Project).Include(t => t.CompleteMilestones).Where(t => t.Project == p && !t.CompleteMilestones.Contains(m)).Include(t=>t.Members).ToListAsync();

            CompleteIncompleteTeamsDTO toret = new CompleteIncompleteTeamsDTO();
            List<TeamDTO> comp = new List<TeamDTO>();
            List<TeamDTO> inc = new List<TeamDTO>();
            foreach(Team t in complete) { 
                comp.Add(TeamToDTO(t));
            }
            foreach (Team t in incomplete)
            {
                inc.Add(TeamToDTO(t));
            }
            toret.incomplete = inc;
            toret.complete = comp;
            return toret;
        }



        //Deletes a milestone, authed for professors only
        // DELETE: api/Milestones/5
        [HttpDelete("{id}")]
        [Authorize]
        public async Task<IActionResult> DeleteMilestone(int id)
        {
            User curr = GetCurrentUser(HttpContext);
            Milestone m = await _context.Milestones.Include(m => m.Project).Where(m => m.Id == id).FirstOrDefaultAsync();
            if (m != null)
            {
                return NotFound();
            }
            Class c = await _context.Classes.Where(c=>c.Id == m.Project.ClassId).FirstOrDefaultAsync();
            if (c == null)
            {
                return Problem();
            }
            if(c.Professor.UserId != curr.UserId)
            {
                return Unauthorized();
            }


            _context.Milestones.Remove(m);
            await _context.SaveChangesAsync();

            return Ok();
        }

        private bool MilestoneExists(int id)
        {
            return (_context.Milestones?.Any(e => e.Id == id)).GetValueOrDefault();
        }


        private static TeamDTO TeamToDTO(Team t)
        {
            TeamDTO td = new TeamDTO();
            td.Name = t.Name;
            td.projectId = t.Project.Id;
            td.Members = new List<UserProfileDTO>();
            foreach (var member in t.Members)
            {
                td.Members.Add(UsertoProfileDTO(member));
            }
            td.Complete = t.Complete;
            return td;
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

        /*
         * 
         * 
        // PUT: api/Milestones/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutMilestone(int id, Milestone milestone)
        {
            if (id != milestone.Id)
            {
                return BadRequest();
            }

            _context.Entry(milestone).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!MilestoneExists(id))
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

        
        // GET: api/Milestones
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Milestone>>> GetMilestones()
        {
            if (_context.Milestones == null)
            {
                return NotFound();
            }
            return await _context.Milestones.ToListAsync();
        }

                // POST: api/Milestones
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<MilestoneDTO>> PostMilestone(MilestoneDTO milestoneDTO)
        {
            if (_context.Milestones == null)
            {
                return Problem("Entity set 'WT_DBContext.Milestones'  is null.");
            }

            var milestone = new Milestone
            {
                Id = milestoneDTO.Id,
                Project = await _context.Projects.FindAsync(milestoneDTO.ProjectID),
                Title = milestoneDTO.Title,
                Description = milestoneDTO.Description,
                Deadline = milestoneDTO.Deadline,
            };

            _context.Milestones.Add(milestone);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetMilestone", new { id = milestoneDTO.Id }, milestoneDTO);
        }
         */
    }
}
