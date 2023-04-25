using Microsoft.AspNetCore.Mvc;
using WorkTogether.Models;

namespace WorkTogether.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GeneralController : ControllerBase
    {

        private readonly WT_DBContext _context;

        public GeneralController(WT_DBContext context)
        {
            _context = context;
        }

        [HttpPost("ResetDemo")]
        public async Task<IActionResult> ResetDb()
        {
            await _context.Database.EnsureDeletedAsync();
            await _context.Database.EnsureCreatedAsync();
            _context.Seed();
            return Ok();
        }
    }
}
