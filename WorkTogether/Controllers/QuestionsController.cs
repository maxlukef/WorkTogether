using System;
using System.Collections.Generic;
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
    public class QuestionsController : ControllerBase
    {
        private readonly WT_DBContext _context;

        public QuestionsController(WT_DBContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Gets a question by its ID
        /// </summary>
        /// <param name="id">The Question's ID</param>
        /// <returns>a QuestionDTO</returns>
        [Authorize]
        [HttpGet("{id}")]
        public async Task<ActionResult<QuestionDTO>> GetQuestion(int id)
        {
            if (_context.Questions == null)
            {
                return NotFound();
            }
            var question = await _context.Questions.FindAsync(id);
            QuestionDTO questionDTO = QuestionToDTO(question);

            if (question == null)
            {
                return NotFound();
            }

            return questionDTO;
        }

        /// <summary>
        /// Gets all questions in a Questionnaire
        /// </summary>
        /// <param name="questionnaireId"></param>
        /// <returns></returns>
        [HttpGet("GetQuestionsByQuestionnaireId/{questionnaireId}")]
        [Authorize]
        public async Task<ActionResult<IEnumerable<QuestionDTO>>> GetQuestionsByQuestionnaireId(int questionnaireId)
        {
            if (_context.Questions == null)
            {
                return NotFound();
            }

            List<QuestionDTO> questionDTOs = new List<QuestionDTO>();

            var result = await _context.Questions.Include(q => q.Questionnaire).Where(q => q.Questionnaire.Id == questionnaireId).ToListAsync();

            if (result == null)
            {
                return NotFound();
            }

            foreach (var q in result)
            {
                Question newQuestion = new Question();
                newQuestion.Id = q.Id;
                newQuestion.QNum = q.QNum;
                newQuestion.Prompt = q.Prompt;
                newQuestion.Type = q.Type;
                newQuestion.Questionnaire = q.Questionnaire;
                questionDTOs.Add(QuestionToDTO(newQuestion));
            }

            return questionDTOs;
        }

        /// <summary>
        /// Turns a Question into a QuestionDTO
        /// </summary>
        /// <param name="question">The Question</param>
        /// <returns>the QuestionDTO</returns>
        private QuestionDTO QuestionToDTO(Question question)
        {
            return new QuestionDTO
            {
                Id = question.Id,
                Prompt = question.Prompt,
                Type = question.Type,
                QuestionnaireID = question.Questionnaire.Id
            };
        }
    }
}
