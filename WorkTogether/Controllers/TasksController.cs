﻿using System;
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
        /// <summary>
        /// Gets a task by its id. The student getting the task must be a member of the team.
        /// </summary>
        /// <param name="id">The id of the task</param>
        /// <returns>a TaskDTO</returns>
        [HttpGet("{id}")]
        [Authorize]
        public async Task<ActionResult<ReturnTaskDTO>> GetTask(int id)
        {
            User curr_user = await _um.GetUserAsync(User);
            if (_context.Tasks == null)
            {
                return NotFound();
            }
            var task = await _context.Tasks.Where(t => t.Id == id).Include(t => t.Team).Include(t => t.ParentMilestone).FirstOrDefaultAsync();
            Team team = await _context.Teams.Where(te => te.Id == task.Team.Id).Include(te => te.Members).FirstOrDefaultAsync();
            if (task == null || team == null)
            {
                return NotFound();
            }

            if (!team.Members.Contains(curr_user))
            {
                return Unauthorized();
            }

            ReturnTaskDTO taskDTO = TaskToReturnDTO(task);

            return taskDTO;
        }

        // GET: api/Tasks/UserTasks
        /// <summary>
        /// Gets all incomplete tasks for the user signed in.
        /// </summary>
        /// <returns>List of tasks for the current user</returns>
        [Authorize]
        [HttpGet("UserTasks")]
        public async Task<ActionResult<ReturnTaskDTO>> GetUserTasks()
        {
            User curr_user = GetCurrentUser(HttpContext);
            if (_context.Tasks == null)
            {
                return NotFound();
            }
            var tasks = await _context.Tasks.Include(t => t.Assignees).Include(t => t.Team).Include(t => t.ParentMilestone).Where(t => t.Assignees.Contains(curr_user) && !t.Completed).ToListAsync();

            List<ReturnTaskDTO> tasks_dto = new List<ReturnTaskDTO>();
            foreach (TaskItem task in tasks)
            {
                tasks_dto.Add(TaskToReturnDTO(task));
            }

            return new ObjectResult(tasks_dto);
        }

        // GET: api/Tasks/AllUserTasks
        /// <summary>
        /// Gets all tasks(complete or not) for the user signed in.
        /// </summary>
        /// <returns>List of task dtos for the current user</returns>
        [Authorize]
        [HttpGet("AllUserTasks")]
        public async Task<ActionResult<ReturnTaskDTO>> GetAllUserTasks()
        {
            User curr_user = GetCurrentUser(HttpContext);
            if (_context.Tasks == null)
            {
                return NotFound();
            }
            var tasks = await _context.Tasks.Include(t => t.Assignees).Include(t => t.ParentMilestone).Include(t => t.Team).Where(t => t.Assignees.Contains(curr_user)).ToListAsync();

            List<ReturnTaskDTO> tasks_dto = new List<ReturnTaskDTO>();
            foreach (TaskItem task in tasks)
            {
                tasks_dto.Add(TaskToReturnDTO(task));
            }

            return new ObjectResult(tasks_dto);
        }


        // GET: api/GroupTasks/2
        /// <summary>
        /// Gets all incomplete tasks for the group
        /// </summary>
        /// <param name="teamid">The id of the team</param>
        /// <returns>List of task dtos</returns>
        [Authorize]
        [HttpGet("GroupTasks/{teamid}")]
        public async Task<ActionResult<ReturnTaskDTO>> GetGroupTasks(int teamid)
        {
            User curr_user = GetCurrentUser(HttpContext);
            if (_context.Tasks == null)
            {
                return NotFound();
            }

            var team = await _context.Teams.Where(te => te.Id == teamid).Include(te => te.Members).FirstOrDefaultAsync();

            if (team == null)
            {
                return NotFound();
            }

            if (!team.Members.Contains(curr_user))
            {
                return Unauthorized();
            }
            var tasks = await _context.Tasks.Include(t => t.Team).Include(t => t.Assignees).Include(t => t.ParentMilestone).Where(t => t.Team.Id == teamid && !t.Completed && !t.Assignees.Contains(curr_user)).ToListAsync();


            List<ReturnTaskDTO> tasks_dto = new List<ReturnTaskDTO>();
            foreach (TaskItem task in tasks)
            {
                tasks_dto.Add(TaskToReturnDTO(task));
            }

            return new ObjectResult(tasks_dto);
        }


        // GET: api/Tasks/AllGroupTasks/2
        /// <summary>
        /// Gets all tasks for the group(complete or not)
        /// </summary>
        /// <param name="teamid">The id of the team to get tasks for</param>
        /// <returns>List of task dtos</returns>
        [Authorize]
        [HttpGet("AllGroupTasks/{teamid}")]
        public async Task<ActionResult<ReturnTaskDTO>> GetAllGroupTasks(int teamid)
        {
            User curr_user = GetCurrentUser(HttpContext);
            if (_context.Tasks == null)
            {
                return NotFound();
            }

            var team = await _context.Teams.Where(te => te.Id == teamid).Include(te => te.Members).FirstOrDefaultAsync();

            if (team == null)
            {
                return NotFound();
            }

            if (!team.Members.Contains(curr_user))
            {
                return Unauthorized();
            }
            var tasks = await _context.Tasks.Include(t => t.Team).Include(t => t.Assignees).Include(t => t.ParentMilestone).Where(t => t.Team.Id == teamid && !t.Assignees.Contains(curr_user)).ToListAsync();


            List<ReturnTaskDTO> tasks_dto = new List<ReturnTaskDTO>();
            foreach (TaskItem task in tasks)
            {
                tasks_dto.Add(TaskToReturnDTO(task));
            }

            return new ObjectResult(tasks_dto);
        }


        // GET: api/Tasks/UserGroupTasks/2
        /// <summary>
        /// Gets all of the current users incomplete tasks for a specified group
        /// </summary>
        /// <param name="teamid">The id of the group to find tasks for</param>
        /// <returns>List of task DTOs</returns>
        [Authorize]
        [HttpGet("UserGroupTasks/{teamid}")]
        public async Task<ActionResult<ReturnTaskDTO>> GetUserGroupTasks(int teamid)
        {
            User curr_user = GetCurrentUser(HttpContext);
            if (_context.Tasks == null)
            {
                return NotFound();
            }

            var team = await _context.Teams.Where(te => te.Id == teamid).Include(te => te.Members).FirstOrDefaultAsync();

            if (team == null)
            {
                return NotFound();
            }

            if (!team.Members.Contains(curr_user))
            {
                return Unauthorized();
            }
            var tasks = await _context.Tasks.Include(t => t.Team).Include(t => t.Assignees).Include(t => t.ParentMilestone).Where(t => t.Team.Id == teamid && !t.Completed && t.Assignees.Contains(curr_user)).ToListAsync();


            List<ReturnTaskDTO> tasks_dto = new List<ReturnTaskDTO>();
            foreach (TaskItem task in tasks)
            {
                tasks_dto.Add(TaskToReturnDTO(task));
            }

            return new ObjectResult(tasks_dto);
        }

        //GET: api/Tasks/AllUserGroupTasks/2
        /// <summary>
        /// Gets all of the current users incomplete and complete tasks for a specified group
        /// </summary>
        /// <param name="teamid">The id of the group to find tasks for</param>
        /// <returns>List of task DTOs</returns>
        [Authorize]
        [HttpGet("AllUserGroupTasks/{teamid}")]
        public async Task<ActionResult<ReturnTaskDTO>> GetAllUserGroupTasks(int teamid)
        {
            User curr_user = GetCurrentUser(HttpContext);
            if (_context.Tasks == null)
            {
                return NotFound();
            }

            var team = await _context.Teams.Where(te => te.Id == teamid).Include(te => te.Members).FirstOrDefaultAsync();

            if (team == null)
            {
                return NotFound();
            }

            if (!team.Members.Contains(curr_user))
            {
                return Unauthorized();
            }
            var tasks = await _context.Tasks.Include(t => t.Team).Include(t => t.Assignees).Include(t => t.ParentMilestone).Where(t => t.Team.Id == teamid && t.Assignees.Contains(curr_user)).ToListAsync();

            List<ReturnTaskDTO> tasks_dto = new List<ReturnTaskDTO>();
            foreach (TaskItem task in tasks)
            {
                tasks_dto.Add(TaskToReturnDTO(task));
            }

            return new ObjectResult(tasks_dto);
        }


        // GET: api/Tasks/MilestoneTasks/3
        /// <summary>
        /// Gets all incomplete tasks for the specified milestone
        /// </summary>
        /// <param name="msid">The id of the milestone</param>
        /// <returns>List of tasks for the milestone</returns>
        [Authorize]
        [HttpGet("MilestoneTasks/{msid}")]
        public async Task<ActionResult<ReturnTaskDTO>> GetMilestoneTasks(int msid)
        {
            User curr_user = GetCurrentUser(HttpContext);
            if (_context.Tasks == null)
            {
                return NotFound();
            }

            var ms = await _context.Milestones.Include(m => m.Project).Where(m => m.Id == msid).FirstOrDefaultAsync();

            if (ms == null) { return NotFound(); }
            var team = await _context.Teams.Where(te => te.Project == ms.Project).Include(te => te.Members).FirstOrDefaultAsync();


            if (team == null)
            {
                return NotFound();
            }

            if (!team.Members.Contains(curr_user))
            {
                return Unauthorized();
            }
            var tasks = await _context.Tasks.Include(t => t.ParentMilestone).Include(t => t.Team).Include(t => t.Assignees).Where(t => t.ParentMilestone == ms && !t.Completed).ToListAsync();


            List<ReturnTaskDTO> tasks_dto = new List<ReturnTaskDTO>();
            foreach (TaskItem task in tasks)
            {
                tasks_dto.Add(TaskToReturnDTO(task));
            }

            return new ObjectResult(tasks_dto);
        }

        // GET: api/Tasks/AllMilestoneTasks/3
        /// <summary>
        /// Gets all incomplete and complete tasks for the specified milestone
        /// </summary>
        /// <param name="msid">The id of the milestone</param>
        /// <returns>List of tasks for the milestone</returns>
        [Authorize]
        [HttpGet("AllMilestoneTasks/{msid}")]
        public async Task<ActionResult<ReturnTaskDTO>> GetAllMilestoneTasks(int msid)
        {
            User curr_user = GetCurrentUser(HttpContext);
            if (_context.Tasks == null)
            {
                return NotFound();
            }
            var ms = await _context.Milestones.Include(m => m.Project).Where(m => m.Id == msid).FirstOrDefaultAsync();

            if (ms == null) { return NotFound(); }
            var team = await _context.Teams.Where(te => te.Project == ms.Project).Include(te => te.Members).Where(te=>te.Members.Contains(curr_user)).FirstOrDefaultAsync();


            if (team == null)
            {
                return NotFound();
            }

            var tasks = await _context.Tasks.Include(t => t.ParentMilestone).Include(t => t.Team).Include(t => t.Assignees).Where(t => t.ParentMilestone == ms && !t.Assignees.Contains(curr_user)).ToListAsync();

            List<ReturnTaskDTO> tasks_dto = new List<ReturnTaskDTO>();
            foreach (TaskItem task in tasks)
            {
                tasks_dto.Add(TaskToReturnDTO(task));
            }

            return new ObjectResult(tasks_dto);
        }

        // GET: api/Tasks/UserMilestoneTasks/3
        /// <summary>
        /// Gets all incomplete tasks for the specified milestone and current user
        /// </summary>
        /// <param name="msid">The id of the milestone</param>
        /// <returns>List of tasks for the milestone</returns>
        [Authorize]
        [HttpGet("UserMilestoneTasks/{msid}")]
        public async Task<ActionResult<ReturnTaskDTO>> GetUserMilestoneTasks(int msid)
        {
            User curr_user = GetCurrentUser(HttpContext);
            if (_context.Tasks == null)
            {
                return NotFound();
            }
            var ms = await _context.Milestones.Include(m => m.Project).Where(m => m.Id == msid).FirstOrDefaultAsync();
            if (ms == null)
            {

                return NotFound();

            }
            var team = await _context.Teams.Include(te => te.Project).Include(te => te.Members).Where(te => te.Project.Id == ms.Project.Id && te.Members.Contains(curr_user)).FirstOrDefaultAsync();


            if (team == null)
            {
                return NotFound();
            }

            if (!team.Members.Contains(curr_user))
            {
                return Unauthorized();
            }
            var tasks = await _context.Tasks.Include(t => t.Assignees).Include(t => t.ParentMilestone).Where(t => t.ParentMilestone == ms && !t.Completed && t.Assignees.Contains(curr_user)).ToListAsync();

            List<ReturnTaskDTO> tasks_dto = new List<ReturnTaskDTO>();
            foreach (TaskItem task in tasks)
            {
                tasks_dto.Add(TaskToReturnDTO(task));
            }

            return new ObjectResult(tasks_dto);
        }


        // GET: api/Tasks/AllUserMilestoneTasks/3
        /// <summary>
        /// Gets all incomplete and complete tasks for the specified milestone and current user
        /// </summary>
        /// <param name="msid">The id of the milestone</param>
        /// <returns>List of tasks for the milestone</returns>
        [Authorize]
        [HttpGet("AllUserMilestoneTasks/{msid}")]
        public async Task<ActionResult<ReturnTaskDTO>> GetAllUserMilestoneTasks(int msid)
        {
            User curr_user = GetCurrentUser(HttpContext);
            if (_context.Tasks == null)
            {
                return NotFound();
            }

            var ms = await _context.Milestones.Include(m => m.Project).Where(m => m.Id == msid).FirstOrDefaultAsync();

            if (ms == null) { return NotFound(); }
            var team = await _context.Teams.Where(te => te.Project == ms.Project).Include(te => te.Members).Where(te=>te.Members.Contains(curr_user)).FirstOrDefaultAsync();


            if (team == null)
            {
                return NotFound();
            }

            if (!team.Members.Contains(curr_user))
            {
                return Unauthorized();
            }
            var tasks = await _context.Tasks.Include(t => t.Assignees).Where(t => t.ParentMilestone == ms && t.Assignees.Contains(curr_user)).ToListAsync();


            List<ReturnTaskDTO> tasks_dto = new List<ReturnTaskDTO>();
            foreach (TaskItem task in tasks)
            {
                tasks_dto.Add(TaskToReturnDTO(task));
            }

            return new ObjectResult(tasks_dto);
        }

        //POST: api/Tasks/create
        /// <summary>
        /// Creates a new task from a task DTO. 
        /// </summary>
        /// <param name="taskDTO">the DTO to create the new task from</param>
        /// <returns>Ok if successful, error otherwise. problem, Notfound, or Unauthorized</returns>
        [HttpPost("create")]
        [Authorize]
        public async Task<ActionResult> CreateTask(CreateTaskDTO taskDTO)
        {
            User curr = GetCurrentUser(HttpContext);

            ICollection<User> taskAssignees = new List<User>();
            foreach (int userID in taskDTO.Assignees)
            {
                var curUser = await _context.Users.Where(u => u.UserId == userID).FirstOrDefaultAsync();
                if (curUser != null)
                {
                    taskAssignees.Add(curUser);
                }
            }

            Team t = await _context.Teams.Where(t => t.Id == taskDTO.TeamID).Include(t => t.Members).FirstOrDefaultAsync();

            if (t == null)
            {
                return NotFound(taskDTO.TeamID);
            }

            if (!t.Members.Contains(curr))
            {
                return Unauthorized(curr.Id);
            }

            Milestone TaskMs = null;
            TaskItem TaskPT = null;
            if (taskDTO.ParentTaskID != null)
            {
                TaskPT = await _context.Tasks.FindAsync(taskDTO.ParentTaskID);
            }
            if (taskDTO.ParentMilestoneID != null)
            {
                TaskMs = await _context.Milestones.FindAsync(taskDTO.ParentMilestoneID);
            }

            var task = new TaskItem
            {
                DueDate = StrToDate(taskDTO.DueDate),
                Description = taskDTO.Description,
                Completed = taskDTO.Completed,
                Name = taskDTO.Name,
                Team = await _context.Teams.FindAsync(taskDTO.TeamID),
                ParentMilestone = TaskMs,
                ParentTask = TaskPT,
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

        //POST: api/Tasks/edit
        /// <summary>
        /// Edits a task using a TaskDTO
        /// </summary>
        /// <param name="taskDTO"></param>
        /// <returns>Ok if successful</returns>
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
                var curUser = await _context.Users.Where(u => u.UserId == userID).FirstOrDefaultAsync();
                if (curUser != null)
                {
                    taskAssignees.Add(curUser);
                }
            }
            TaskItem task = await _context.Tasks.Where(t => t.Id == taskDTO.Id).Include(t => t.Team).FirstOrDefaultAsync();

            Team t = await _context.Teams.Where(t => t.Id == task.Team.Id).Include(t => t.Members).FirstOrDefaultAsync();

            if (t == null)
            {
                return NotFound(t.Id);
            }

            if (!t.Members.Contains(curr))
            {
                return Unauthorized(curr.Id);
            }

            Milestone TaskMs = null;
            TaskItem TaskPT = null;
            if (taskDTO.ParentTaskID != null)
            {
                TaskPT = await _context.Tasks.FindAsync(taskDTO.ParentTaskID);
            }
            if (taskDTO.ParentMilestoneID != null)
            {
                TaskMs = await _context.Milestones.FindAsync(taskDTO.ParentMilestoneID);
            }
            _context.Tasks.Remove(task);
            _context.SaveChanges();
            task.DueDate = StrToDate(taskDTO.DueDate);
            task.Description = taskDTO.Description;
            task.Completed = taskDTO.Completed;
            task.Name = taskDTO.Name;

            task.ParentMilestone = TaskMs;
            task.ParentTask = TaskPT;

            task.Assignees = taskAssignees;
            _context.Tasks.Add(task);
            _context.SaveChanges();

            return Ok();
        }

        [HttpPost("ChangeTaskMilestone/{taskid}/{msid}")]
        [Authorize]
        public async Task<ActionResult> ChangeTaskMilestone(int taskid, int msid)
        {
            User curr = GetCurrentUser(HttpContext);
            TaskItem t = await _context.Tasks.Where(t => t.Id == taskid).Include(t => t.Team).FirstOrDefaultAsync();
            if (t == null)
            {
                return NotFound();
            }
            Team te = await _context.Teams.Where(te => te.Id == t.Team.Id).Include(te => te.Members).FirstOrDefaultAsync();
            if (!te.Members.Contains(curr))
            {
                return Unauthorized();
            }

            Milestone ms = _context.Milestones.Find(msid);
            if (ms == null)
            {
                return NotFound();
            }
            t.ParentMilestone = ms;
            _context.SaveChanges();
            return Ok();
        }

        //POST: api/Tasks/assign/5/6
        /// <summary>
        /// Assigns a user to a task
        /// </summary>
        /// <param name="taskid">The id of the task to assign to</param>
        /// <param name="userid">The id of the user to assign</param>
        /// <returns>Ok if successful</returns>
        [HttpPost("assign/{taskid}/{userid}")]
        [Authorize]
        public async Task<ActionResult<BasicTaskDTO>> Assign(int taskid, int userid)
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
            if (!team.Members.Contains(toassign) || !team.Members.Contains(curr))
            {
                return Unauthorized();
            }
            task.Assignees.Add(toassign);
            _context.SaveChanges();
            return Ok();
        }

        //POST: api/tasks/unassign/5/6
        /// <summary>
        /// Unassign a user from a task
        /// </summary>
        /// <param name="taskid">The id of the task</param>
        /// <param name="userid">The id of the user</param>
        /// <returns>Ok if successful</returns>
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
            if (!team.Members.Contains(toassign) || !team.Members.Contains(curr))
            {
                return Unauthorized();
            }
            task.Assignees.Remove(toassign);
            _context.SaveChanges();
            return Ok();
        }

        //POST: api/tasks/markcomplete/id
        /// <summary>
        /// Mark a task as complete
        /// </summary>
        /// <param name="id">The id of the task</param>
        /// <returns>Ok if successful</returns>
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

        //POST: api/tasks/markincomplete/id
        /// <summary>
        /// Marks a task incomplete
        /// </summary>
        /// <param name="id">THe task to mark incomplete</param>
        /// <returns>Ok if successful</returns>
        [HttpPost("markincomplete/{id}")]
        [Authorize]
        public async Task<ActionResult<BasicTaskDTO>> MarkIncomplete(int id)
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
            task.Completed = false;
            _context.SaveChanges();
            return Ok();


        }

        // DELETE: api/Tasks/5
        /// <summary>
        /// Deletes a task
        /// </summary>
        /// <param name="id">The id of the task</param>
        /// <returns>Ok if successful</returns>
        [HttpDelete("{id}")]
        [Authorize]
        public async Task<IActionResult> DeleteTask(int id)
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



            _context.Tasks.Remove(task);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        /// <summary>
        /// Converts a Task to a DTO
        /// </summary>
        /// <param name="task">the Task</param>
        /// <returns>the BasicTaskDTO</returns>
        private static BasicTaskDTO TaskToBasicDTO(TaskItem task)
        {
            int? ptid = null;
            int? pmid = null;
            if (task.ParentTask != null)
            {
                ptid = task.ParentTask.Id;
            }
            if (task.ParentMilestone != null)
            {
                pmid = task.ParentMilestone.Id;
            }
            List<int> assgids = new List<int>();
            foreach (User u in task.Assignees)
            {
                assgids.Add(u.UserId);
            }
            return new BasicTaskDTO
            {
                Id = task.Id,
                Name = task.Name,
                Description = task.Description,
                TeamID = task.Team.Id,
                ParentTaskID = ptid,
                ParentMilestoneID = pmid,
                Assignees = assgids,
                DueDate = DateToStr(task.DueDate),
                Completed = task.Completed,

            };
        }

        /// <summary>
        /// Cibverts a task to a ReturnTaskDTO
        /// </summary>
        /// <param name="task">the Task</param>
        /// <returns>the ReturnTaskDTO</returns>
        private static ReturnTaskDTO TaskToReturnDTO(TaskItem task)
        {
            int? ptid = null;
            int? pmid = null;
            if (task.ParentTask != null)
            {
                ptid = task.ParentTask.Id;
            }
            if (task.ParentMilestone != null)
            {
                pmid = task.ParentMilestone.Id;
            }
            List<UserProfileDTO> assgd = new List<UserProfileDTO>();
            foreach (User u in task.Assignees)
            {
                assgd.Add(UsertoProfileDTO(u));
            }
            return new ReturnTaskDTO
            {
                Id = task.Id,
                Name = task.Name,
                Description = task.Description,
                TeamID = task.Team.Id,
                ParentTaskID = ptid,
                ParentMilestoneID = pmid,
                Assignees = assgd,
                DueDate = DateToStr(task.DueDate),
                Completed = task.Completed,

            };
        }

        /// <summary>
        /// Converts a string date (month/day/year(
        /// </summary>
        /// <param name="date">The date in month/day/year string format</param>
        /// <returns>a DateTime representing that date</returns>
        private static DateTime StrToDate(string date)
        {
            var splitdate = date.Split('/');
            DateTime d = new DateTime(int.Parse(splitdate[2]), int.Parse(splitdate[0]), int.Parse(splitdate[1]));
            return d;
        }

        /// <summary>
        /// Converts a DateTime to a string representation of the date (year-month-day)
        /// </summary>
        /// <param name="d">The DateTime</param>
        /// <returns>a string in year-month-day format</returns>
        private static string DateToStr(DateTime d)
        {
            return "" + d.Year + "-" + d.Month + "-" + d.Day;
        }

        /// <summary>
        /// Converts a User to a UserProfileDTO
        /// </summary>
        /// <param name="user"></param>
        /// <returns>a UserProfileDTO</returns>
        private static UserProfileDTO UsertoProfileDTO(User user) =>
        new UserProfileDTO
        {
            Id = user.UserId,
            Name = user.Name,
            Email = user.Email,
            Bio = user.Bio,
            Major = user.Major,
            EmploymentStatus = user.EmploymentStatus,
            StudentStatus = user.StudentStatus,
            Interests = user.Interests
        };

    }
}
