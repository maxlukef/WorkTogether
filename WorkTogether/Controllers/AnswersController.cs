using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing.Printing;
using System.Linq;
using System.Threading.Tasks;
using System.Threading.Tasks.Dataflow;
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

        // GET: api/Answers
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Answer>>> GetAnswers()
        {
          if (_context.Answers == null)
          {
              return NotFound();
          }
            return await _context.Answers.ToListAsync();
        }

        // GET: api/Answers/5
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

        // GET: api/Answers/1/5
        [HttpGet("{classID}/{StudentID}")]
        public async Task<ActionResult<List<AnswerDTO>>> GetAnswersForStudentProject(int classID, int StudentID)
        {
            var result = await (from p in _context.Projects
                   join q in _context.Questionnaires on p.Id equals q.Project.Id
                   join que in _context.Questions on q equals que.Questionnaire
                   join a in _context.Answers on que equals a.Question
                   where a.Answerer.UserId == StudentID && p.ClassId == classID
                   select new { question = a.Question, answer = a.AnswerStr }).ToListAsync();

            List<AnswerDTO> answerList = new List<AnswerDTO>();

            foreach(var answer in result)
            {
                answerList.Add(
                    AnswertoAnswerDTO(new Answer { AnswerStr = answer.answer, Question = answer.question }));
            }

            return answerList;
        }

        [HttpPost("{projectID}/{StudentID}")]
        public async Task<IActionResult> PostAnswersForStudentProject(int projectID, int StudentID, List<AnswerDTO> answers)
        {
            var user = _context.Users.Where(x => x.UserId == StudentID).Single();
            var curQuestionnaire = _context.Questionnaires.Where(x => x.ProjectID == projectID).Single();
            var curQuestions = _context.Questions.Where(x => x.Questionnaire == curQuestionnaire);

            for (int i = 0; i < answers.Count; i++)
            {
                var curQuestion = curQuestions.Where(x => x.QNum == answers[i].qNum).Single();

                Answer answer = new Answer
                {
                    AnswerStr = answers[i].answerText,
                    Question = curQuestion,
                    Answerer = user
                };

                var answerCheck = _context.Answers.Where(x => x.Question == answer.Question).Where(x => x.Answerer != user);
                if(answerCheck.ToList().Count == 1)
                {
                    _context.Answers.Add(answer);
                }
            }

            await _context.SaveChangesAsync();

            return NoContent();
        }

        [HttpPut("{ProjectID}/{StudentID}")]
        public async Task<IActionResult> PutAnswersForStudentProject(int ProjectID, int StudentID, List<AnswerDTO> answers)
        {
            var user = _context.Users.Where(x => x.UserId == StudentID).Single();
            var curQuestionnaire = _context.Questionnaires.Where(x => x.ProjectID == ProjectID).Single();
            var curQuestions = _context.Questions.Where(x => x.Questionnaire == curQuestionnaire);

            for (int i = 0; i < answers.Count; i++)
            {
                var curQuestion = curQuestions.Where(x => x.QNum == answers[i].qNum).Where(x => x.Questionnaire == curQuestionnaire).Single();
                var answer = _context.Answers.Where(x => x.Question == curQuestion).Where(x => x.Answerer == user).First();

                answer.AnswerStr = answers[i].answerText;

                _context.Entry(answer).State = EntityState.Modified;
            }

            await _context.SaveChangesAsync();

            return NoContent();
        }

        // PUT: api/Answers/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutAnswer(int id, Answer answer)
        {
            if (id != answer.Id)
            {
                return BadRequest();
            }

            _context.Entry(answer).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!AnswerExists(id))
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

        // POST: api/Answers
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Answer>> PostAnswer(Answer answer)
        {
          if (_context.Answers == null)
          {
              return Problem("Entity set 'WT_DBContext.Answers'  is null.");
          }
            _context.Answers.Add(answer);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetAnswer", new { id = answer.Id }, answer);
        }

        // DELETE: api/Answers/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAnswer(int id)
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

            _context.Answers.Remove(answer);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool AnswerExists(int id)
        {
            return (_context.Answers?.Any(e => e.Id == id)).GetValueOrDefault();
        }

        private static AnswerDTO AnswertoAnswerDTO(Answer answer) =>
        new AnswerDTO
        {
            qNum = answer.Question.Id,
            answerText = answer.AnswerStr
        };
    }
}
