using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using WorkTogether.Models;

namespace WorkTogether.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GeneralController : ControllerBase
    {

        private readonly WT_DBContext _context;
        private readonly UserManager<User> _um;
        public GeneralController(WT_DBContext context, UserManager<User> um)
        {
            _context = context;
            _um = um;
        }

        [HttpPost("ResetDemo")]
        public async Task<IActionResult> ResetDb()
        {
            await _context.Database.EnsureDeletedAsync();
            await _context.Database.EnsureCreatedAsync();
            await _context.Seed(_um);
            return Ok();
        }


        //changes the year of the team formation deadline for the seeded capstone project
        
        [HttpPost("changeteamdate/{year}")]
        public async Task<ActionResult> ChangeDateDemo(int year)
        {
            Project tochange = _context.Projects.Find(1);
            DateTime tfd = tochange.TeamFormationDeadline;
            DateTime t2 = new DateTime(year, tfd.Month, tfd.Day);
            tochange.TeamFormationDeadline = t2;
            _context.SaveChanges();
            return Ok();
        }
    }
}
