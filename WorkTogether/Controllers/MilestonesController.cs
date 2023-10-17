﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using WorkTogether.Models;

namespace WorkTogether.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MilestonesController : ControllerBase
    {
        private readonly WT_DBContext _context;

        public MilestonesController(WT_DBContext context)
        {
            _context = context;
        }

        private MilestoneDTO MilestoneToDTO(Milestone ms)
        {
            MilestoneDTO md = new MilestoneDTO();
            md.ProjectID = ms.Project.Id;
            md.Title = ms.Title;
            md.Description = md.Description;
            md.Deadline = ms.Deadline;
            return md;
        }

        // GET: api/Milestones
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Milestone>>> GetMilestones()
        {
          if (_context.Milestones == null)
          {
              return NotFound();
          }
            return await _context.Milestones.ToListAsync();
        }


        //Get all milestones for a project
        [HttpGet("ProjectMilestones/{pid}")]
        [Authorize]
        public async Task<ActionResult<List<MilestoneDTO>>> GetMilestonesForProject(int pid)
        {
            
            List<Milestone> ms = await _context.Milestones.Include(m => m.Project).Where(m => m.Project.Id == pid).ToListAsync();
            List<MilestoneDTO> md = new List<MilestoneDTO>();
            foreach (var msItem in ms)
            {
                md.Add(MilestoneToDTO(msItem));
            }
            return md;

        }


        // GET: api/Milestones/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Milestone>> GetMilestone(int id)
        {
          if (_context.Milestones == null)
          {
              return NotFound();
          }
            var milestone = await _context.Milestones.FindAsync(id);

            if (milestone == null)
            {
                return NotFound();
            }

            return milestone;
        }

        // PUT: api/Milestones/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutMilestone(int id, Milestone milestone)
        {
            if (id != milestone.Id)
            {
                return BadRequest();
            }

            _context.Entry(milestone).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!MilestoneExists(id))
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

        // POST: api/Milestones
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<MilestoneDTO>> PostMilestone(MilestoneDTO milestoneDTO)
        {
            if (_context.Milestones == null)
            {
                return Problem("Entity set 'WT_DBContext.Milestones'  is null.");
            }

            var milestone = new Milestone
            {
                Id = milestoneDTO.Id,
                Project = await _context.Projects.FindAsync(milestoneDTO.ProjectID),
                Title = milestoneDTO.Title,
                Description = milestoneDTO.Description,
                Deadline = milestoneDTO.Deadline,
                tasks = new List<TaskItem>(),
            };

            _context.Milestones.Add(milestone);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetMilestone", new { id = milestoneDTO.Id }, milestoneDTO);
        }

        // DELETE: api/Milestones/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteMilestone(int id)
        {
            if (_context.Milestones == null)
            {
                return NotFound();
            }
            var milestone = await _context.Milestones.FindAsync(id);
            if (milestone == null)
            {
                return NotFound();
            }

            _context.Milestones.Remove(milestone);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool MilestoneExists(int id)
        {
            return (_context.Milestones?.Any(e => e.Id == id)).GetValueOrDefault();
        }
    }
}
