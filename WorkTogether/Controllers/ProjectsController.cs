using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json.Linq;
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

        /// <summary>
        /// Gets the current user calling the endpoint that is calling this function
        /// </summary>
        /// <param name="httpContext">The HttpContext of the endpoint</param>
        /// <returns>the User</returns>
        private User GetCurrentUser(HttpContext httpContext)
        {
            string userEmail = httpContext.User.Identity.Name;
            User u1 = _context.Users.Where(u => u.Email == userEmail).FirstOrDefault();
            return u1;
        }


        /// <summary>
        /// Creates a project, if the current user is a professor for the class
        /// </summary>
        /// <param name="p">The CreateProjectDTO</param>
        /// <returns>The ProjectDTO for the new project, if successful</returns>
        [HttpPost("create")]
        [Authorize]
        public async Task<ActionResult<ProjectDTO>> CreateProject(CreateProjectDTO p)
        {
            User curr = GetCurrentUser(HttpContext);
            Class c = await _context.Classes.Where(c => c.Id == p.ClassId).Include(c => c.Professor).FirstOrDefaultAsync();
            if (c == null)
            {
                return NotFound("class id not found");
            }
            if (c.Professor != curr)
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

        /// <summary>
        /// Edit a project's info, only for professors
        /// </summary>
        /// <param name="p">The EditProjectDTO</param>
        /// <returns>The ProjectDTO for the project</returns>
        [HttpPost("edit")]
        [Authorize]
        public async Task<ActionResult<ProjectDTO>> EditProject(EditProjectDTO p)
        {
            User curr = GetCurrentUser(HttpContext);
            Project pr = await _context.Projects.Where(pr => pr.Id == p.Id).Include(pr => pr.Questionnaire).FirstOrDefaultAsync();
            if (pr == null)
            {
                return NotFound("Project does not exist");
            }
            Class c = await _context.Classes.Include(c => c.Professor).Where(c => c.Id == pr.ClassId).FirstOrDefaultAsync();

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
            pr.MinTeamSize = p.MinTeamSize;
            _context.SaveChanges();
            return projectToDTO(pr);

        }

        /// <summary>
        /// Gets a project by its id
        /// </summary>
        /// <param name="id">The id</param>
        /// <returns>A ProjectDTO</returns>
        [HttpGet("{id}")]
        public async Task<ActionResult<ProjectDTO>> GetProject(int id)
        {
            if (_context.Projects == null)
            {
                return NotFound();
            }
            var project = await _context.Projects.Where(p => p.Id == id).Include(p => p.Questionnaire).FirstOrDefaultAsync();

            if (project == null)
            {
                return NotFound();
            }

            return projectToDTO(project);
        }

        [HttpGet("alertsForProject/{id}")]
        [Authorize]
        public async Task<ActionResult<List<String>>> GetAlerts(int id)
        {
            List<dynamic> alerts = new List<dynamic>();

            var users = (from u in _context.Users
                         join c in _context.StudentClasses on u.Id equals c.Student.Id
                         join p in _context.Projects on c.ID equals p.ClassId
                         join m in _context.Milestones on p.Id equals m.Project.Id
                         join t in _context.Tasks on m.Id equals t.ParentMilestone.Id
                         where p.Id == id && c.Class.Id == p.ClassId && t.Assignees.Contains(u)
                         select new
                         {
                             userId = u.Name
                         }).ToList();

            

            if (users == null)
            {
                return NotFound();
            }

            alerts.Add(users);

            var teams = (from t in _context.Teams
                         join p in _context.Projects on t.Project.Id equals p.Id
                         join m in _context.Milestones on p.Id equals m.Project.Id
                         where !t.CompleteMilestones.Contains(m) && p.Id == id && m.Deadline < DateTime.Now
                         select new
                         {
                             teamName = t.Name
                         }).ToList();

            if (teams == null) { return NotFound(); }

            alerts.Add(teams);

            return Ok(alerts);
        }

        [HttpGet("projectInfo/{id}")]
        [Authorize]
        public async Task<ActionResult<List<String>>> ProjectInfo(int id)
        {
            //NumGroups
            var teams = (from t in _context.Teams
                         where t.Project.Id == id
                         select new
                         {
                             teamName = t.Name,
                             teamSize = t.Members.Count
                         });

            //Avg Group Size
            
                
                
            //Final Project Deadline
            List<String> strings = new List<String>();
            strings.Add("hello");
            return strings;
        }

        [HttpGet("projectStats/{id}")]
        [Authorize]
        public async Task<ActionResult<List<String>>> GetProjectStats(int id)
        {
            //Average Tasks Completed Per Student

            //Tasks Completed This Week
            List<String> strings = new List<String>();
            strings.Add("hello");
            return strings;
        }



        /// <summary>
        /// Get All projects in a class
        /// </summary>
        /// <param name="ClassID">The ID of the class</param>
        /// <returns>A collection of ProjectDTOs</returns>
        [HttpGet("GetProjectsByClassId/{ClassID}")]
        [Authorize]
        public async Task<ActionResult<IEnumerable<ProjectDTO>>> GetProjectsByClassId(int ClassID)
        {
            var projects = await _context.Projects.Where(x => x.ClassId == ClassID).ToListAsync();

            return Ok(projects);
        }

        /// <summary>
        /// Get the projects which are currently in the group search phase for a class
        /// </summary>
        /// <param name="ClassID">The ID of the class</param>
        /// <returns>List of ProjectDTOs</returns>
        [HttpGet("GetProjectsInGroupSearchPhase/{ClassID}")]
        public async Task<ActionResult<IEnumerable<ProjectDTO>>> GetProjectsInGroupSearchPhase(int ClassID)
        {
            var projects = await _context.Projects.Where(x => x.TeamFormationDeadline > DateTime.Now).Where(x => x.ClassId == ClassID).ToListAsync();

            return Ok(projects);
        }

        /// <summary>
        /// Get the active projects(Group search complete) for a class
        /// </summary>
        /// <param name="ClassID">The ID of the class</param>
        /// <returns>List of ProjectDTOs</returns>
        [HttpGet("GetProjectsNotInGroupSearchPhase/{ClassID}")]
        public async Task<ActionResult<IEnumerable<ProjectDTO>>> GetProjectsNotInGroupSearchPhase(int ClassID)
        {
            var projects = await _context.Projects.Where(x => x.TeamFormationDeadline < DateTime.Now).Where(x => x.ClassId == ClassID).ToListAsync();

            return Ok(projects);
        }

        /// <summary>
        /// Creates a default questionnaire for a project
        /// </summary>
        /// <param name="p">The project</param>
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



        /// <summary>
        /// Professors Only: Delete a project
        /// </summary>
        /// <param name="id">The project ID</param>
        /// <returns>200 OK if successful</returns>
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
            Class c = await _context.Classes.Where(c => c.Id == project.ClassId).Include(c => c.Professor).FirstOrDefaultAsync();


            _context.Projects.Remove(project);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        /// <summary>
        /// Converts a Project to DTO form
        /// </summary>
        /// <param name="p">The project</param>
        /// <returns>the new ProjectDTO</returns>
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



    }
}

