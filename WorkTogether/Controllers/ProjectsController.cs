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
    public class ProjectsController : ControllerBase
    {
        private readonly WT_DBContext _context;

        public ProjectsController(WT_DBContext context)
        {
            _context = context;
        }

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

        // GET: api/Projects/5
        [HttpGet("{id}")]
        public async Task<ActionResult<ProjectDTO>> GetProject(int id)
        {
          if (_context.Projects == null)
          {
              return NotFound();
          }
            var project = await _context.Projects.FindAsync(id);

            if (project == null)
            {
                return NotFound();
            }

            return projectToDTO(project);
        }

        // GET: api/Projects/GetOpenTeamSearchForClass/5
        [HttpGet("GetOpenTeamSearchForClass/{ClassID}")]
        public async Task<ActionResult<IEnumerable<ProjectDTO>>> GetOpenTeamSearch(int ClassID)
        {
            var projects = await _context.Projects.Where(x => x.TeamFormationDeadline < DateTime.Now).ToListAsync();

            return Ok(projects);
        }

        // GET: api/Projects/GetOpenProjectsForClass/5
        [HttpGet("GetOpenProjectsForClass/{ClassID")]
        public async Task<ActionResult<IEnumerable<ProjectDTO>>> GetOpenProjects(int ClassID)
        {
            var projects = await _context.Projects.Where(x => x.TeamFormationDeadline < DateTime.Now).Where(x => x.Deadline > DateTime.Now).ToListAsync();

            return Ok(projects);
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
        }

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

        // DELETE: api/Projects/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteProject(int id)
        {
            if (_context.Projects == null)
            {
                return NotFound();
            }
            var project = await _context.Projects.FindAsync(id);
            if (project == null)
            {
                return NotFound();
            }

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
                ClassId = p.Class.Id,
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
                Class = c,
                MinTeamSize = p.MinTeamSize,
                MaxTeamSize = p.MaxTeamSize,
                Deadline = p.Deadline,
                TeamFormationDeadline = p.TeamFormationDeadline,
                Questionnaire = q,
            };
        }
    }
}
