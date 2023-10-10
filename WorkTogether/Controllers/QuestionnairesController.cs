using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.CodeAnalysis;
using Microsoft.EntityFrameworkCore;
using WorkTogether.Models;

namespace WorkTogether.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class QuestionnairesController : ControllerBase
    {
        private readonly WT_DBContext _context;

        public QuestionnairesController(WT_DBContext context)
        {
            _context = context;
        }

        private User GetCurrentUser(HttpContext httpContext)
        {
            string userEmail = httpContext.User.Identity.Name;
            Debug.WriteLine("User Email: " + userEmail);
            User u1 = _context.Users.Where(u => u.Email == userEmail).FirstOrDefault();

            return u1;
        }

        // GET: api/Questionnaires
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Questionnaire>>> GetQuestionnaires()
        {
          if (_context.Questionnaires == null)
          {
              return NotFound();
          }
            return await _context.Questionnaires.ToListAsync();
        }

        // GET: api/Questionnaires/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Questionnaire>> GetQuestionnaire(int id)
        {
          if (_context.Questionnaires == null)
          {
              return NotFound();
          }
            var questionnaire = await _context.Questionnaires.FindAsync(id);

            if (questionnaire == null)
            {
                return NotFound();
            }

            return questionnaire;
        }

        // GET: api/Questionnaires/GetQuestionnaireByProjectId/5
        [HttpGet("GetQuestionnaireByProjectId/{projectID}")]
        public async Task<ActionResult<QuestionnaireDTO>> GetQuestionnaireByProjectId(int projectID)
        {
            if (_context.Questionnaires == null)
            {
                return NotFound();
            }

            Questionnaire questionnaireFinal = new Questionnaire();

            var result = await (from questionnaire in _context.Questionnaires
                                join project in _context.Projects on projectID equals project.Id
                                where questionnaire.ProjectID == projectID
                                select new { Id = questionnaire.Id, Questions = questionnaire.Questions, Project = project, ProjectId = project.Id }).ToListAsync();

            if (result == null)
            {
                return NotFound();
            }

            questionnaireFinal.Id = result[0].Id;
            questionnaireFinal.Questions = result[0].Questions;
            questionnaireFinal.Project = result[0].Project;
            questionnaireFinal.ProjectID = result[0].ProjectId;

            return QuestionnaireToDTO(questionnaireFinal);
        }

        //GET: api/QuestionnaireComplete/1
        [HttpGet("QuestionnaireComplete/{projectID}")]
        [Authorize]
        public async Task<ActionResult<Boolean>> GetQuestionnaireCompleteForProject(int projectID)
        {
            User curUser = GetCurrentUser(HttpContext);
            if (curUser != default)
            {
                Debug.WriteLine("####USER#####: " + curUser.UserName);
            }
        
            var questionnaire = await _context.Questionnaires.Where(x => x.ProjectID == projectID).FirstOrDefaultAsync();
            
            if (questionnaire == null)
            {
                return NotFound();
            }

            var questions = await _context.Questions.Where(x => x.Questionnaire.Id == questionnaire.Id).ToListAsync();

            var questionnaireCompleted = false;

            foreach(Question q in questions)
            {
                var answer = await _context.Answers.Where(x => x.Question.Id == q.Id).FirstAsync();

                if (answer != null)
                {
                    questionnaireCompleted = true;
                    break;
                }
            }

            return Ok(questionnaireCompleted);
        }

        // PUT: api/Questionnaires/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutQuestionnaire(int id, Questionnaire questionnaire)
        {
            if (id != questionnaire.Id)
            {
                return BadRequest();
            }

            _context.Entry(questionnaire).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!QuestionnaireExists(id))
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

        // POST: api/Questionnaires
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Questionnaire>> PostQuestionnaire(Questionnaire questionnaire)
        {
          if (_context.Questionnaires == null)
          {
              return Problem("Entity set 'WT_DBContext.Questionnaires'  is null.");
          }
            _context.Questionnaires.Add(questionnaire);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetQuestionnaire", new { id = questionnaire.Id }, questionnaire);
        }

        // DELETE: api/Questionnaires/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteQuestionnaire(int id)
        {
            if (_context.Questionnaires == null)
            {
                return NotFound();
            }
            var questionnaire = await _context.Questionnaires.FindAsync(id);
            if (questionnaire == null)
            {
                return NotFound();
            }

            _context.Questionnaires.Remove(questionnaire);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool QuestionnaireExists(int id)
        {
            return (_context.Questionnaires?.Any(e => e.Id == id)).GetValueOrDefault();
        }

        private QuestionnaireDTO QuestionnaireToDTO(Questionnaire questionnaire)
        {
            return new QuestionnaireDTO
            {
                Id = questionnaire.Id,
                ProjectID = questionnaire.ProjectID
            };
        }
    }
}
