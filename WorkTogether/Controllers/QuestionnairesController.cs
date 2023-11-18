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


        /// <summary>
        /// Gets the current authorized user from the HttpContext
        /// </summary>
        /// <param name="httpContext">The HttpContext</param>
        /// <returns>The user represented by the JWT token</returns>
        private User GetCurrentUser(HttpContext httpContext)
        {
            string userEmail = httpContext.User.Identity.Name;
            Debug.WriteLine("User Email: " + userEmail);
            User u1 = _context.Users.Where(u => u.Email == userEmail).FirstOrDefault();

            return u1;
        }



        /// <summary>
        /// Gets the questionnaire for a project
        /// </summary>
        /// <param name="projectID">The ID of the project</param>
        /// <returns>The QuestionnaireDTO</returns>
        [HttpGet("GetQuestionnaireByProjectId/{projectID}")]
        [Authorize]
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

        /// <summary>
        /// Returns whether or not the current user has completed the questionnaire for a specified project
        /// </summary>
        /// <param name="projectID">The ID of the project in question</param>
        /// <returns>true or false</returns>
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

            foreach (Question q in questions)
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



        /// <summary>
        /// Converts a questionnaire to DTO form
        /// </summary>
        /// <param name="questionnaire">The questionnaire</param>
        /// <returns>a QuestionnaireDTO</returns>
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
