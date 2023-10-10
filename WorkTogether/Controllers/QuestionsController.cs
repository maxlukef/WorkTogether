using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
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

        // GET: api/Questions
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Question>>> GetQuestions()
        {
          if (_context.Questions == null)
          {
              return NotFound();
          }
            List<Question> questions = await _context.Questions.ToListAsync();
            List<QuestionDTO> questionDTOs = new List<QuestionDTO>();
            foreach(Question q in questions)
            {
                questionDTOs.Add(QuestionToDTO(q));   
            }

            return Ok(questionDTOs);
        }

        // GET: api/Questions/5
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

        // GET: api/Questions/GetQuestionsByQuestionnaireId/5
        [HttpGet("GetQuestionsByQuestionnaireId/{questionnaireId}")]
        public async Task<ActionResult<IEnumerable<QuestionDTO>>> GetQuestionsByQuestionnaireId(int questionnaireId)
        {
            if (_context.Questions == null)
            {
                return NotFound();
            }

            List<QuestionDTO> questionDTOs = new List<QuestionDTO>();

            var result = await (from question in _context.Questions
                                join questionnaire in _context.Questionnaires on questionnaireId equals questionnaire.Id
                                where questionnaire.Id == questionnaireId
                                select new { Id = question.Id, qNum = question.QNum, Prompt = question.Prompt, Type = question.Type, Questionnaire = question.Questionnaire }).ToListAsync();

            if (result == null)
            {
                return NotFound();
            }

            foreach (var q in result)
            {
                Question newQuestion = new Question();
                newQuestion.Id = q.Id;
                newQuestion.QNum = q.qNum;
                newQuestion.Prompt = q.Prompt;
                newQuestion.Type = q.Type;
                newQuestion.Questionnaire = q.Questionnaire;
                questionDTOs.Add(QuestionToDTO(newQuestion));
            }

            return questionDTOs;
        }

        // PUT: api/Questions/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutQuestion(int id, Question question)
        {
            if (id != question.Id)
            {
                return BadRequest();
            }

            _context.Entry(question).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!QuestionExists(id))
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

        // POST: api/Questions
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Question>> PostQuestion(QuestionDTO questionDTO)
        {
          if (_context.Questions == null)
          {
              return Problem("Entity set 'WT_DBContext.Questions'  is null.");
          }
            Questionnaire questionnaire = await _context.Questionnaires.FindAsync(questionDTO.QuestionnaireID);
            Question question = new Question
            {
                Id = questionDTO.Id,
                Prompt = questionDTO.Prompt,
                Type = questionDTO.Type,
                Questionnaire = questionnaire,
            };
            _context.Questions.Add(question);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetQuestion", new { id = question.Id }, questionDTO);
        }

        // DELETE: api/Questions/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteQuestion(int id)
        {
            if (_context.Questions == null)
            {
                return NotFound();
            }
            var question = await _context.Questions.FindAsync(id);
            if (question == null)
            {
                return NotFound();
            }

            _context.Questions.Remove(question);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool QuestionExists(int id)
        {
            return (_context.Questions?.Any(e => e.Id == id)).GetValueOrDefault();
        }

        //private async Question DTOToQuestion(QuestionDTO questionDTO)
        //{
        //    Questionnaire questionnaire = await _context.Questionnaires.FindAsync(questionDTO.QuestionnaireID);
        //    Question question = new Question
        //    {
        //        Id = questionDTO.Id,
        //        Prompt = questionDTO.Prompt,
        //        Type = questionDTO.Type,
        //        Questionnaire = questionnaire,
        //    };

        //    return question;
        //}
        
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
