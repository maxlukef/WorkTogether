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
    }
}
