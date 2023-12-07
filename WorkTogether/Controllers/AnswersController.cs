using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing.Printing;
using System.Linq;
using System.Threading.Tasks;
using System.Threading.Tasks.Dataflow;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using WorkTogether.Models;

namespace WorkTogether.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AnswersController : ControllerBase
    {
        private readonly WT_DBContext _context;

        public AnswersController(WT_DBContext context)
        {
            _context = context;
        }



        /// <summary>
        /// Gets a single Answer by its id
        /// </summary>
        /// <param name="id">The id of the Answer</param>
        /// <returns>The Answer</returns>
        [HttpGet("{id}")]
        public async Task<ActionResult<Answer>> GetAnswer(int id)
        {
            if (_context.Answers == null)
            {
                return NotFound();
            }
            var answer = await _context.Answers.FindAsync(id);

            if (answer == null)
            {
                return NotFound();
            }

            return answer;
        }

        /// <summary>
        /// Gets all the answers to the given Questionnaire for the current user
        /// </summary>
        /// <param name="questionnaireId">The ID of the Questionnaire</param>
        /// <returns>A list of Answers</returns>
        [HttpGet("GetAnswersByQuestionnaireIdForCurrentUser/{questionnaireId}")]
        [Authorize]
        public async Task<ActionResult<List<AnswerDTO>>> GetAnswersByQuestionnaireIdForCurrentUser(int questionnaireId)
        {
            User u = GetCurrentUser(HttpContext);

            var result = await (from projects in _context.Projects
                                join questionnaire in _context.Questionnaires on projects.Id equals questionnaire.Project.Id
                                join question in _context.Questions on questionnaire.Id equals question.Questionnaire.Id
                                join answers in _context.Answers on question.Id equals answers.Question.Id
                                where answers.Answerer.UserId == u.UserId && questionnaire.Id == questionnaireId
                                select new { Id = answers.Id, AnswerStr = answers.AnswerStr, Question = answers.Question, Answerer = answers.Answerer }).ToListAsync();

            List<AnswerDTO> answerList = new List<AnswerDTO>();

            foreach (var answer in result)
            {
                answerList.Add(
                    AnswertoAnswerDTO(new Answer { Id = answer.Id, AnswerStr = answer.AnswerStr, Question = answer.Question, Answerer = answer.Answerer }));
            }

            return answerList;
        }

        /// <summary>
        /// Gets the current user's answers for the given Project
        /// </summary>
        /// <param name="projectId">The ID of the project</param>
        /// <returns>A list of the Answers in DTO form</returns>
        [HttpGet("GetCurrentUserAnswersByProjectId/{projectId}")]
        [Authorize]
        public async Task<ActionResult<List<AnswerDTO>>> GetCurrentUserAnswersByProjectId(int projectId)
        {
            User u = GetCurrentUser(HttpContext);

            var result = await (from p in _context.Projects
                                join q in _context.Questionnaires on p.Id equals q.Project.Id
                                join que in _context.Questions on q equals que.Questionnaire
                                join a in _context.Answers on que equals a.Question
                                where a.Answerer.UserId == u.UserId && p.Id == projectId
                                select new { Id = a.Id, AnswerStr = a.AnswerStr, Question = a.Question, Answerer = a.Answerer }).ToListAsync();

            List<AnswerDTO> answerList = new List<AnswerDTO>();

            foreach (var answer in result)
            {
                answerList.Add(
                    AnswertoAnswerDTO(new Answer { Id = answer.Id, AnswerStr = answer.AnswerStr, Question = answer.Question, Answerer = answer.Answerer }));
            }

            return answerList;
        }

        /// <summary>
        /// Gets the answers for a user for a project
        /// </summary>
        /// <param name="projectId">The ID of the project</param>
        /// <param name="userId">The ID of the user</param>
        /// <returns>A list of AnswerDTOs</returns>
        [HttpGet("GetAnswersByProjectIdAndUserId/{projectId}/{userId}")]
        [Authorize]
        public async Task<ActionResult<List<AnswerDTO>>> GetAnswersByProjectIdAndUserId(int projectId, int userId)
        {
            var result = await (from p in _context.Projects
                                join q in _context.Questionnaires on p.Id equals q.Project.Id
                                join que in _context.Questions on q equals que.Questionnaire
                                join a in _context.Answers on que equals a.Question
                                where a.Answerer.UserId == userId && p.Id == projectId
                                select new { Id = a.Id, AnswerStr = a.AnswerStr, Question = a.Question, Answerer = a.Answerer }).ToListAsync();

            List<AnswerDTO> answerList = new List<AnswerDTO>();

            foreach (var answer in result)
            {
                answerList.Add(
                    AnswertoAnswerDTO(new Answer { Id = answer.Id, AnswerStr = answer.AnswerStr, Question = answer.Question, Answerer = answer.Answerer }));
            }

            return answerList;
        }

        /// <summary>
        /// Lets a user update their questionnaire answers
        /// </summary>
        /// <param name="questionnaireId">The ID of the Questionnaire</param>
        /// <param name="answers">A list of AnswerDTOs containing the user's responses.</param>
        /// <returns>200 OK if successful.</returns>
        [HttpPost("PostAnswersFromQuestionnaireForCurrentUser/{questionnaireId}")]
        [Authorize]
        public async Task<IActionResult> PostAnswersFromQuestionnaireForCurrentUser(int questionnaireId, List<AnswerDTO> answers)
        {
            User user = GetCurrentUser(HttpContext);
            var curQuestionnaire = _context.Questionnaires.Where(x => x.Id == questionnaireId).Single();
            var curQuestions = _context.Questions.Where(x => x.Questionnaire == curQuestionnaire);

            for (int i = 0; i < answers.Count; i++)
            {
                var curQuestion = curQuestions.Where(x => x.Id == answers[i].QuestionId).Single();

                Answer answer = new Answer
                {
                    AnswerStr = answers[i].AnswerText,
                    Question = curQuestion,
                    Answerer = user
                };

                _context.Answers.Add(answer);
            }

            await _context.SaveChangesAsync();

            return NoContent();
        }

        /// <summary>
        /// Lets a user upload their answers to a questionnaire.
        /// </summary>
        /// <param name="questionnaireId">The ID of the Questionnaire</param>
        /// <param name="answers">A list of AnswerDTOs containing the user's responses.</param>
        /// <returns>200 OK if successful.</returns>
        [HttpPut("PutAnswersFromQuestionnaireForCurrentUser/{questionnaireId}")]
        [Authorize]
        public async Task<IActionResult> PutAnswersFromQuestionnaireForCurrentUser(int questionnaireId, List<AnswerDTO> answers)
        {
            User user = GetCurrentUser(HttpContext);
            var curQuestionnaire = _context.Questionnaires.Where(x => x.Id == questionnaireId).Single();
            var curQuestions = _context.Questions.Where(x => x.Questionnaire == curQuestionnaire);

            for (int i = 0; i < answers.Count; i++)
            {
                var curQuestion = curQuestions.Where(x => x.Id == answers[i].QuestionId).Where(x => x.Questionnaire == curQuestionnaire).Single();
                var answer = _context.Answers.Where(x => x.Question == curQuestion).Where(x => x.Answerer == user).First();

                answer.AnswerStr = answers[i].AnswerText;

                _context.Entry(answer).State = EntityState.Modified;
            }

            await _context.SaveChangesAsync();

            return NoContent();
        }



        /// <summary>
        /// Gets the current authorized user
        /// </summary>
        /// <param name="httpContext">The HTTPContext for the calling endpoint</param>
        /// <returns>the User represented in the bearer token</returns>
        private User GetCurrentUser(HttpContext httpContext)
        {
            string userEmail = httpContext.User.Identity.Name;
            User u1 = _context.Users.Where(u => u.Email == userEmail).FirstOrDefault();
            return u1;
        }

        /// <summary>
        /// Converts an Answer into DTO form to send to the frontend
        /// </summary>
        /// <param name="answer">The Answer</param>
        /// <returns>the DTO</returns>
        private static AnswerDTO AnswertoAnswerDTO(Answer answer) =>
        new AnswerDTO
        {
            Id = answer.Id,
            AnswerText = answer.AnswerStr,
            QuestionId = answer.Question.Id,
            AnswererId = answer.Answerer.UserId,
            AnswererName = answer.Answerer.Name,
        };
    }
}
