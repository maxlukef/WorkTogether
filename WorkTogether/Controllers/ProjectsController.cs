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
    public class ProjectsController : ControllerBase
    {
        private readonly WT_DBContext _context;

        public ProjectsController(WT_DBContext context)
        {
            _context = context;
        }

        private User GetCurrentUser(HttpContext httpContext)
        {
            string userEmail = httpContext.User.Identity.Name;
            User u1 = _context.Users.Where(u => u.Email == userEmail).FirstOrDefault();
            return u1;
        }


        // GET: api/Projects/5
        [HttpPost("create")]
        [Authorize]
        public async Task<ActionResult<ProjectDTO>> CreateProject(CreateProjectDTO p)
        {
            User curr = GetCurrentUser(HttpContext);
            Class c = await _context.Classes.Where(c=>c.Id == p.ClassId).Include(c=>c.Professor).FirstOrDefaultAsync();
            if (c == null)
            {
                return NotFound("class id not found");
            }
            if(c.Professor != curr)
            {
                return Unauthorized("Must be the classes professor to create a project");
            }
            Project pr = new Project();
            pr.ClassId = c.Id;
            pr.Deadline = p.Deadline;
            pr.Name = p.Name;
            pr.Description = p.Description;
            pr.MaxTeamSize = p.MaxTeamSize;
            pr.MinTeamSize = p.MinTeamSize;
            pr.TeamFormationDeadline = p.TeamFormationDeadline;
            CreateQuestionnaire(pr);
            _context.SaveChanges();
            return projectToDTO(pr);
        }

        // GET: api/Projects/5
        [HttpPost("edit")]
        [Authorize]
        public async Task<ActionResult<ProjectDTO>> EditProject(EditProjectDTO p)
        {
            User curr = GetCurrentUser(HttpContext);
            Project pr = await _context.Projects.Where(pr => pr.Id == p.Id).Include(pr=>pr.Questionnaire).FirstOrDefaultAsync();
            if(pr == null)
            {
                return NotFound("Project does not exist");
            }
            Class c = await _context.Classes.Include(c=>c.Professor).Where(c=>c.Id == pr.ClassId).FirstOrDefaultAsync();
           
            if (c == null)
            {
                return NotFound("class id not found");
            }
            if (c.Professor != curr)
            {
                return Unauthorized("Must be the classes professor to create a project");
            }
            pr.Deadline = p.Deadline;
            pr.Name = p.Name;
            pr.Description = p.Description;
            pr.MaxTeamSize = p.MaxTeamSize;
            pr.TeamFormationDeadline = p.TeamFormationDeadline;
            pr.MinTeamSize= p.MinTeamSize;
            _context.SaveChanges();
            return projectToDTO(pr);
         
        }

        // GET: api/Projects/5
        [HttpGet("{id}")]
        public async Task<ActionResult<ProjectDTO>> GetProject(int id)
        {
          if (_context.Projects == null)
          {
              return NotFound();
          }
            var project = await _context.Projects.Where(p=>p.Id==id).Include(p=>p.Questionnaire).FirstOrDefaultAsync();

            if (project == null)
            {
                return NotFound();
            }

            return projectToDTO(project);
        }

        // GET: api/Projects/GetProjectsByClassId/5
        // Get All projects in a class
        [HttpGet("GetProjectsByClassId/{ClassID}")]
        [Authorize]
        public async Task<ActionResult<IEnumerable<ProjectDTO>>> GetProjectsByClassId(int ClassID)
        {
            var projects = await _context.Projects.Where(x => x.ClassId == ClassID).ToListAsync();

            return Ok(projects);
        }

        // GET: api/Projects/GetProjectsInGroupSearchPhase/5
        // Team search deadline has NOT passed
        [HttpGet("GetProjectsInGroupSearchPhase/{ClassID}")]
        public async Task<ActionResult<IEnumerable<ProjectDTO>>> GetProjectsInGroupSearchPhase(int ClassID)
        {
            var projects = await _context.Projects.Where(x => x.TeamFormationDeadline > DateTime.Now).Where(x => x.ClassId == ClassID).ToListAsync();

            return Ok(projects);
        }

        // GET: api/Projects/GetProjectsNotInGroupSearchPhase/5
        // Team search deadline has passed && Project deadline is not current time
        [HttpGet("GetProjectsNotInGroupSearchPhase/{ClassID}")]
        public async Task<ActionResult<IEnumerable<ProjectDTO>>> GetProjectsNotInGroupSearchPhase(int ClassID)
        {
            var projects = await _context.Projects.Where(x => x.TeamFormationDeadline < DateTime.Now).Where(x => x.ClassId == ClassID).ToListAsync();

            return Ok(projects);
        }

        private void CreateQuestionnaire(Project p)
        {
            Questionnaire default_questionnaire = new Questionnaire();
            default_questionnaire.Project = p;
            default_questionnaire.ProjectID = p.Id;
            p.Questionnaire = default_questionnaire;
            _context.Questionnaires.Add(default_questionnaire);


            Question q1 = new Question();
            q1.Questionnaire = default_questionnaire;
            q1.Prompt = "Add Available Times";
            q1.Type = "Time";
            _context.Questions.Add(q1);


            Question q2 = new Question();
            q2.Questionnaire = default_questionnaire;
            q2.Prompt = "Expected Project Quality";
            q2.Type = "Select";
            _context.Questions.Add(q2);

           

            Question q3 = new Question();
            q3.Questionnaire = default_questionnaire;
            q3.Prompt = "Relevant Skills";
            q3.Type = "Tag";
            _context.Questions.Add(q3);

           

            Question q4 = new Question();
            q4.Questionnaire = default_questionnaire;
            q4.Prompt = "Expected Hours Weekly";
            q4.Type = "Number";
            _context.Questions.Add(q4);

           

            Question q5 = new Question();
            q5.Questionnaire = default_questionnaire;
            q5.Prompt = "Additional Notes";
            q5.Type = "Text";
            _context.Questions.Add(q5);

            _context.SaveChanges();
        }



        // DELETE: api/Projects/5
        [HttpDelete("{id}")]
        [Authorize]
        public async Task<IActionResult> DeleteProject(int id)
        {
            User curr = GetCurrentUser(HttpContext);
            if (_context.Projects == null)
            {
                return NotFound();
            }
            var project = await _context.Projects.FindAsync(id);
            if (project == null)
            {
                return NotFound();
            }
            Class c= await _context.Classes.Where(c=>c.Id == project.ClassId).Include(c=>c.Professor).FirstOrDefaultAsync();


            _context.Projects.Remove(project);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ProjectExists(int id)
        {
            return (_context.Projects?.Any(e => e.Id == id)).GetValueOrDefault();
        }

        private ProjectDTO projectToDTO(Project p)
        {
            return new ProjectDTO
            {
                Id = p.Id,
                Name = p.Name,
                Description = p.Description,
                ClassId = p.ClassId,
                MinTeamSize = p.MinTeamSize,
                MaxTeamSize = p.MaxTeamSize,
                Deadline = p.Deadline,
                TeamFormationDeadline = p.TeamFormationDeadline,
                QuestionnaireId = p.Questionnaire.Id,
            };
        }

        private Project DTOtoProject(ProjectDTO p)
        {
            Class c = _context.Classes.Find(p.ClassId);
            Questionnaire q = _context.Questionnaires.Find(p.QuestionnaireId);

            if(c == null || q == null)
            {
                return null;
            }

            return new Project
            {
                Id = p.Id,
                Name = p.Name,
                Description = p.Description,
                ClassId = p.ClassId,
                MinTeamSize = p.MinTeamSize,
                MaxTeamSize = p.MaxTeamSize,
                Deadline = p.Deadline,
                TeamFormationDeadline = p.TeamFormationDeadline,
                Questionnaire = q,
            };

            /*
            // POST: api/Projects
            // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
            [HttpPost]
            public async Task<ActionResult<Project>> PostProject(ProjectDTO projectDTO)
            {
                Project project = DTOtoProject(projectDTO);

                if (project == null)
                {
                    return BadRequest();
                }

                if (_context.Projects == null)
                {
                    return Problem("Entity set 'WT_DBContext.Projects'  is null.");
                }

                _context.Projects.Add(project);
                await _context.SaveChangesAsync();

                return CreatedAtAction("GetProject", new { id = project.Id }, project);
            }
            
             
                     // PUT: api/Projects/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutProject(int id, ProjectDTO projectDTO)
        {
            Project project = DTOtoProject(projectDTO);
            if(project == null)
            {
                return BadRequest();
            }

            if (id != project.Id)
            {
                return BadRequest();
            }

            _context.Entry(project).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ProjectExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();

                    // GET: api/Projects
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Project>>> GetProjects()
        {
            if (_context.Projects == null)
            {
                return NotFound();
            }

            var projects = await _context.Projects.ToListAsync();
            var projectDTOs = new List<ProjectDTO>();
            foreach(Project p in projects)
            {
                projectDTOs.Append(projectToDTO(p));
            }

            return Ok(projectDTOs);
        }
        }*/

        }
    }
}
