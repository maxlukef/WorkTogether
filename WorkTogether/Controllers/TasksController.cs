using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.EntityFrameworkCore;
using WorkTogether.Models;

namespace WorkTogether.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TasksController : ControllerBase
    {
        private readonly WT_DBContext _context;

        public TasksController(WT_DBContext context)
        {
            _context = context;
        }

        // GET: api/Tasks
        [HttpGet]
        public async Task<ActionResult<IEnumerable<BasicTaskDTO>>> GetTasks()
        {
          if (_context.Tasks == null)
          {
              return NotFound();
          }
            var all_tasks = await _context.Tasks.ToListAsync();

            IEnumerable<BasicTaskDTO> all_tasks_dto = from task in all_tasks select TaskToBasicDTO(task);

            return new ObjectResult(all_tasks_dto);
        }

        // GET: api/Tasks/5
        [HttpGet("{id}")]
        public async Task<ActionResult<BasicTaskDTO>> GetTask(int id)
        {
          if (_context.Tasks == null)
          {
              return NotFound();
          }
            var task = await _context.Tasks.FindAsync(id);

            if (task == null)
            {
                return NotFound();
            }

            BasicTaskDTO taskDTO = TaskToBasicDTO(task);

            return taskDTO;
        }

        // PUT: api/Tasks/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutTask(int id, BasicTaskDTO taskDTO)
        {
            if (id != taskDTO.Id)
            {
                return BadRequest();
            }

            TaskItem task = await _context.Tasks.FindAsync(id);
            if (task == null)
            {
                return NotFound();
            }

            task.DueDate = taskDTO.DueDate;
            task.Description = taskDTO.Description;
            task.Completed = taskDTO.Completed;
            task.Name = taskDTO.Name;

            ICollection<User> taskAsignees = new List<User>();
            foreach(int userID in taskDTO.Assignees)
            {
                var curUser = await _context.Users.FindAsync(userID);
                taskAsignees.Add(curUser);
            }

            task.Assignees = taskAsignees;


            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!TaskExists(id))
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

        // POST: api/Tasks
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<BasicTaskDTO>> PostTask(BasicTaskDTO taskDTO)
        {
            ICollection<User> taskAssignees = new List<User>();
            foreach (int userID in taskDTO.Assignees)
            {
                var curUser = await _context.Users.FindAsync(userID);
                taskAssignees.Add(curUser);
            }

            var task = new TaskItem
            {
                Id = taskDTO.Id,
                DueDate = taskDTO.DueDate,
                Description = taskDTO.Description,
                Completed = taskDTO.Completed,
                Name = taskDTO.Name,
                Team = await _context.Teams.FindAsync(taskDTO.TeamID),
                ParentMilestone = await _context.Milestones.FindAsync(taskDTO.ParentMilestoneID),
                ParentTask = await _context.Tasks.FindAsync(taskDTO.ParentTaskID),
                CreatedAt = DateTime.Now,
                Assignees = taskAssignees,
            };

            if (_context.Tasks == null)
            {
                return Problem("Entity set 'WT_DBContext.Tasks'  is null.");
            }
            _context.Tasks.Add(task);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetTask", new { id = task.Id }, task);
        }

        // DELETE: api/Tasks/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTask(int id)
        {
            if (_context.Tasks == null)
            {
                return NotFound();
            }
            var task = await _context.Tasks.FindAsync(id);
            if (task == null)
            {
                return NotFound();
            }

            _context.Tasks.Remove(task);
            await _context.SaveChangesAsync();

            return NoContent();
        }
        
        private bool TaskExists(int id)
        {
            return (_context.Tasks?.Any(e => e.Id == id)).GetValueOrDefault();
        }

        private static BasicTaskDTO TaskToBasicDTO(TaskItem task) =>
            new BasicTaskDTO
            {
                Id = task.Id,
                Name = task.Name,
                Description = task.Description,
                TeamID = task.Team.Id,
                ParentTaskID = task.ParentTask.Id,
                ParentMilestoneID = task.ParentMilestone.Id,
                Assignees = (ICollection<int>)(from user in task.Assignees select user.Id),
                DueDate = task.DueDate,
                Completed = task.Completed,

            };
    }
}
