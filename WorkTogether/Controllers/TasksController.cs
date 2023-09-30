using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
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
        private readonly UserManager<User> _um;

        private User GetCurrentUser(HttpContext httpContext)
        {
            string userEmail = httpContext.User.Identity.Name;
            User u1 = _context.Users.Where(u => u.Email == userEmail).FirstOrDefault();
            return u1;
        }

        public TasksController(WT_DBContext context, UserManager<User> um)
        {
            _context = context;
            _um = um;
            
        }

        // GET: api/Tasks/5
        [HttpGet("{id}")]
        [Authorize]
        public async Task<ActionResult<BasicTaskDTO>> GetTask(int id)
        {
            User curr_user = await _um.GetUserAsync(User);
            if (_context.Tasks == null)
            {
              return NotFound();
            }
            var task = await _context.Tasks.Where(t=>t.Id ==id).Include(t=>t.Team).FirstOrDefaultAsync();
            Team team = await _context.Teams.Where(te=>te.Id == task.Team.Id).Include(te=>te.Members).FirstOrDefaultAsync();
            if (task == null || team == null)
            {
                return NotFound();
            }

            if(!team.Members.Contains(curr_user))
            {
                return Unauthorized();
            }

            BasicTaskDTO taskDTO = TaskToBasicDTO(task);

            return taskDTO;
        }

        // GET: api/UserTasks
        /// <summary>
        /// Gets all tasks for the user signed in.
        /// </summary>
        /// <returns>List of tasks for the current user</returns>
        [Authorize]
        [HttpGet("UserTasks")]
        public async Task<ActionResult<BasicTaskDTO>> GetUserTasks()
        {
            User curr_user = await _um.GetUserAsync(User);
            if (_context.Tasks == null)
            {
                return NotFound();
            }
            var tasks = await _context.Tasks.Include(t=>t.Assignees).Where(t => t.Assignees.Contains(curr_user) && !t.Completed).ToListAsync();

            List<BasicTaskDTO> tasks_dto = new List<BasicTaskDTO>();
            foreach (TaskItem task in tasks) {
                tasks_dto.Add(TaskToBasicDTO(task));
            }

            return new ObjectResult(tasks_dto);
        }






        //USE THIS ONE
        [HttpPost("create")]
        [Authorize]
        public async Task<ActionResult<BasicTaskDTO>> CreateTask(BasicTaskDTO taskDTO)
        {
            User curr = GetCurrentUser(HttpContext);

            ICollection<User> taskAssignees = new List<User>();
            foreach (int userID in taskDTO.Assignees)
            {
                var curUser = await _context.Users.FindAsync(userID);
                taskAssignees.Add(curUser);
            }

            Team t = await _context.Teams.Where(t=>t.Id == taskDTO.TeamID).Include(t=> t.Members).FirstOrDefaultAsync();

            if(t != null)
            {
                return NotFound(t.Id);
            }

            if(!t.Members.Contains(curr))
            {
                return Unauthorized(curr.Id);
            }

            var task = new TaskItem
            {
                Id = taskDTO.Id,
                DueDate = StrToDate(taskDTO.DueDate),
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

            return Ok();
        }

        //USE THIS ONE
        [HttpPost("edit")]
        [Authorize]
        public async Task<ActionResult<BasicTaskDTO>> EditTask(BasicTaskDTO taskDTO)
        {
            if (_context.Tasks == null)
            {
                return Problem("Entity set 'WT_DBContext.Tasks'  is null.");
            }

            User curr = GetCurrentUser(HttpContext);

            ICollection<User> taskAssignees = new List<User>();
            foreach (int userID in taskDTO.Assignees)
            {
                var curUser = await _context.Users.FindAsync(userID);
                taskAssignees.Add(curUser);
            }
            TaskItem task = await _context.Tasks.Where(t=> t.Id == taskDTO.Id).Include(t => t.Team).FirstOrDefaultAsync();

            Team t = await _context.Teams.Where(t => t.Id == task.Team.Id).Include(t => t.Members).FirstOrDefaultAsync();

            if (t != null)
            {
                return NotFound(t.Id);
            }

            if (!t.Members.Contains(curr))
            {
                return Unauthorized(curr.Id);
            }


            task.DueDate = StrToDate(taskDTO.DueDate);
            task.Description = taskDTO.Description;
            task.Completed = taskDTO.Completed;
            task.Name = taskDTO.Name;

            task.ParentMilestone = await _context.Milestones.FindAsync(taskDTO.ParentMilestoneID);
            task.ParentTask = await _context.Tasks.FindAsync(taskDTO.ParentTaskID);
                
            task.Assignees = taskAssignees;
           
            
            await _context.SaveChangesAsync();

            return Ok();
        }


        //USE THIS ONE
        [HttpPost("assign/{taskid}/{userid}")]
        [Authorize]
        public async Task<ActionResult<BasicTaskDTO>> Assign(int taskid, int userid)
        {
            User curr = GetCurrentUser(HttpContext);
            TaskItem task = await _context.Tasks.Where(t=>t.Id == taskid).Include(t=>t.Assignees).Include(t=>t.Team).FirstOrDefaultAsync();
            if(task == null)
            {
                return NotFound();
            }
            Team team = await _context.Teams.Where(te => te.Id == task.Team.Id).Include(te=>te.Members).FirstOrDefaultAsync();
            if(team == null)
            {
                return NotFound();
            }
            User toassign = await _context.Users.Where(u=>u.UserId == userid).FirstOrDefaultAsync();
            if(toassign == null)
            {
                return NotFound();
            }
            if(!team.Members.Contains(toassign) || !team.Members.Contains(curr)) 
            {
                return Unauthorized();
            }
            task.Assignees.Add(toassign);
            _context.SaveChanges();
            return Ok();
        }

        //USE THIS ONE
        [HttpPost("unassign/{taskid}/{userid}")]
        [Authorize]
        public async Task<ActionResult<BasicTaskDTO>> Unassign(int taskid, int userid)
        {
            User curr = GetCurrentUser(HttpContext);
            TaskItem task = await _context.Tasks.Where(t => t.Id == taskid).Include(t => t.Assignees).Include(t => t.Team).FirstOrDefaultAsync();
            if (task == null)
            {
                return NotFound();
            }
            Team team = await _context.Teams.Where(te => te.Id == task.Team.Id).Include(te => te.Members).FirstOrDefaultAsync();
            if (team == null)
            {
                return NotFound();
            }
            User toassign = await _context.Users.Where(u => u.UserId == userid).FirstOrDefaultAsync();
            if (toassign == null)
            {
                return NotFound();
            }
            if (!team.Members.Contains(toassign) || !team.Members.Contains(curr) || !task.Assignees.Contains(curr))
            {
                return Unauthorized();
            }
            task.Assignees.Remove(toassign);
            _context.SaveChanges();
            return Ok();
        }

        
        [HttpPost("markcomplete/{id}")]
        [Authorize]
        public async Task<ActionResult<BasicTaskDTO>> MarkComplete(int id)
        {
            User curr = GetCurrentUser(HttpContext);
            if (_context.Tasks == null)
            {
                return NotFound();
            }
            var task = await _context.Tasks.Where(t => t.Id == id).Include(t => t.Team).FirstOrDefaultAsync();


            if (task == null)
            {
                return NotFound();
            }
            var team = await _context.Teams.Where(te => te.Id == task.Team.Id).Include(te => te.Members).FirstOrDefaultAsync();
            if (!team.Members.Contains(curr))
            {
                return Unauthorized("Not a member of the team for this task");
            }
            task.Completed = true;
            _context.SaveChanges();
            return Ok();

           
        }

            // DELETE: api/Tasks/5
            [HttpDelete("{id}")]
        [Authorize]
        public async Task<IActionResult> DeleteTask(int id)
        {

            User curr = GetCurrentUser(HttpContext);
            if (_context.Tasks == null)
            {
                return NotFound();
            }
            var task = await _context.Tasks.Where(t=> t.Id == id).Include(t => t.Team).FirstOrDefaultAsync();


            if (task == null)
            {
                return NotFound();
            }
            var team = await _context.Teams.Where(te => te.Id == task.Team.Id).Include(te => te.Members).FirstOrDefaultAsync();
            if (!team.Members.Contains(curr))
            {
                return Unauthorized("Not a member of the team for this task");
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
                DueDate = DateToStr(task.DueDate),
                Completed = task.Completed,

            };

        private static DateTime StrToDate(string date)
        {
            var splitdate = date.Split('-');
            DateTime d = new DateTime(int.Parse(splitdate[0]), int.Parse(splitdate[1]), int.Parse(splitdate[2]));
            return d;
        }

        private static string DateToStr(DateTime d)
        {
            return "" + d.Year + "-" + d.Month + "-" + d.Day;
        }

        /*

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

    task.DueDate = StrToDate(taskDTO.DueDate);
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
}*/

        /*
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
                DueDate = StrToDate(taskDTO.DueDate),
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
        }*/
                /*

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
        */
    }
}
