using System;
using System.Collections.Generic;
using System.Drawing.Printing;
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
    public class ClassesController : ControllerBase
    {
        private readonly WT_DBContext _context;

        public ClassesController(WT_DBContext context)
        {
            _context = context;
        }

        // GET: api/Classes
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ClassDTO>>> GetClasses()
        {
            if (_context.Classes == null)
            {
                return NotFound();
            }
            var classList = await _context.Classes.Include(c=>c.Professor).ToListAsync();
            var classDTOList = new List<ClassDTO>();
            foreach (Class c in classList) 
            {
                classDTOList.Add(ClassToDTO(c));
            }

            return Ok(classDTOList);
        }

        // GET: api/Classes/5
        [HttpGet("{id}")]
        public async Task<ActionResult<ClassDTO>> GetClass(int id)
        {
            if (_context.Classes == null)
            {
                return NotFound();
            }
            var @class = ClassToDTO(await _context.Classes.Include(c=>c.Professor).Where(c=>c.Id==id).FirstOrDefaultAsync());

            if (@class == null)
            {
                return NotFound();
            }

            return @class;
        }

  

        [HttpGet("getinvitecode/{classid}")]
        [Authorize]
        public async Task<ActionResult<string>> GetInviteCode(int classid)
        {
            User curr = GetCurrentUser(HttpContext);
            Class c = await _context.Classes.Where(c => c.Id == classid).Include(c => c.Professor).FirstOrDefaultAsync();
            if(c==null)
            {
                return NotFound();
            }
            if(c.Professor != curr)
            {
                return Unauthorized();
            }
            return c.InviteCode;
        }

        [HttpGet("joinclass/{invcode}")]
        [Authorize]
        public async Task<ActionResult<bool>> Join(string invcode)
        {
            User curr = GetCurrentUser(HttpContext);
            Class c = await _context.Classes.Where(c => c.InviteCode == invcode).FirstOrDefaultAsync();
            if (c == null)
            {
                return NotFound();
            }
            if (c.Professor == curr)
            {
                return Unauthorized();
            }
            if(await _context.StudentClasses.Include(sc=>sc.Student).Include(sc=>sc.Class).Where(sc => sc.Class == c && sc.Student == curr).CountAsync() > 0)
            {
                return BadRequest("Student already in this class");
            }
            StudentClass n = new StudentClass();
            n.Student = curr;
            n.Class = c;
            _context.StudentClasses.Add(n);
            _context.SaveChanges();
            return true;
        }

        /// <summary>
        /// This gets all the students in the given class.
        /// </summary>
        /// <param name="id">The ID of the class</param>
        /// <returns>A list of UserProfiles of the students</returns>
        //GET: api/Classes/getstudentsinclass/10
        [HttpGet("getstudentsinclass/{id}")]
        [Authorize]
        public async Task<ActionResult<IEnumerable<UserProfileDTO>>> GetStudentsInClass(int id)
        {
            User u = GetCurrentUser(HttpContext);

            Class c = await _context.Classes.Where(c => c.Id == id).Include(c => c.Professor).FirstOrDefaultAsync();
            if (c == null)
            {
                return NotFound();
            }

            List<StudentClass> c_u = await _context.StudentClasses.Include(sc => sc.Student).Include(sc=>sc.Class).Where(sc => sc.Student == u && sc.Class.Id == id).ToListAsync();



            if(c_u.Count == 0 && c.Professor.Id != u.Id) {
                return Unauthorized();
            }


            List<StudentClass> sc = await _context.StudentClasses.Include(s=> s.Class).Include(s=>s.Student).Where(s => s.Class.Id == id).ToListAsync();
            List<UserProfileDTO> students = new List<UserProfileDTO>();
            foreach (var s in sc)
            {
                students.Add(UsertoProfileDTO(s.Student));
            }
            return students;

        }


        /// <summary>
        /// Gets the classes that the authenticated user is part of
        /// </summary>
        /// <returns>A list of classDTOs</returns>
        //GET /api/classes/currentuserclasses
        [Authorize]
        [HttpGet("currentuserclasses")]
        public async Task<ActionResult<IEnumerable<ClassDTO>>> GetCurrentUserClasses()
        {
            User u = GetCurrentUser(HttpContext);

            var studentClasses = await _context.StudentClasses.Where(r => r.Student.UserId == u.UserId).Include(r => r.Class.Professor).ToListAsync(); 

            List<ClassDTO> classes = new List<ClassDTO>();
            foreach (var studentClass in studentClasses)
            {
                classes.Add(ClassToDTO(studentClass.Class));
            }
            return classes;
        }

        //get classes that the current user is prof of
        [Authorize]
        [HttpGet("profclasses")]
        public async Task<ActionResult<IEnumerable<ClassDTO>>> GetUserProfessorClasses()
        {
            User u = GetCurrentUser(HttpContext);
            var classes = await _context.Classes.Include(c => c.Professor).Where(c => c.Professor == u).ToListAsync(); 
            List<ClassDTO> classesdto = new List<ClassDTO>();
            foreach (var cl in classes)
            {
                classesdto.Add(ClassToDTO(cl));
            }
            return classesdto;
        }

        [HttpPost("create")]
        [Authorize]
        public async Task<ActionResult<ClassDTO>> CreateClass(CreateClassDTO cd)
        {
            User curr = GetCurrentUser(HttpContext);
            Class c = new Class();
            c.Name = cd.Name;
            c.Description = cd.Description;
            c.Professor = curr;
            _context.Classes.Add(c);
            _context.SaveChanges();
            return ClassToDTO(c);
        }

        [HttpPost("edit")]
        [Authorize]
        public async Task<ActionResult<ClassDTO>> EditClass(EditClassDTO cd)
        {
            User curr = GetCurrentUser(HttpContext);
            Class c = await _context.Classes.Where(c => c.Id == cd.Id).Include(c => c.Professor).FirstOrDefaultAsync();
            if(c == null)
            {
                return NotFound(cd);
            }
            if(c.Professor != curr)
            {
                return Unauthorized();
            }
            c.Name = cd.Name;
            c.Description = cd.Description;
            _context.SaveChanges();
            return ClassToDTO(c);
        }




        // DELETE: api/Classes/5
        [HttpDelete("{id}")]
        [Authorize]
        public async Task<IActionResult> DeleteClass(int id)
        {
            User curr = GetCurrentUser(HttpContext);
            if (_context.Classes == null)
            {
                return NotFound();
            }
            var @class = await _context.Classes.Include(c=>c.Professor).Where(c=>c.Id==id).FirstOrDefaultAsync();
            if (@class == null)
            {
                return NotFound();
            }
            if(@class.Professor != curr)
            {
                return Unauthorized();
            }

            _context.Classes.Remove(@class);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ClassExists(int id)
        {
            return (_context.Classes?.Any(e => e.Id == id)).GetValueOrDefault();
        }

        private User GetCurrentUser(HttpContext httpContext)
        {
            string userEmail = httpContext.User.Identity.Name;
            User u1 = _context.Users.Where(u => u.Email == userEmail).FirstOrDefault();
            return u1;
        }

        private static ClassDTO ClassToDTO(Class curClass) =>
            new ClassDTO
            { 
                Id = curClass.Id,
                Name = curClass.Name,
                ProfessorID = curClass.Professor.UserId,
                Description = curClass.Description
            };

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

        /*
  //GET: api/Classes/getbystudentid/10
  [HttpGet("getbystudentID/{id}")]
  [Authorize]
  public async Task<ActionResult<IEnumerable<ClassDTO>>> GetClassesByStudentID(int id)
  {
      string userEmail = HttpContext.User.Identity.Name;
      User u1 = await _context.Users.Where(u => u.Email == userEmail).FirstOrDefaultAsync();

      if (u1.UserId != id)
      {
          return Unauthorized();
      }

      var result = await (from studentClass in _context.StudentClasses
                          join course in _context.Classes on studentClass.Class.Id equals course.Id
                          where studentClass.Student.UserId == id
                          select new { Id = course.Id, ProfessorID = course.Professor.UserID, Name = course.Name, Description = course.Description }).ToListAsync();

      List<ClassDTO> classList = new List<ClassDTO>();

      foreach (var c in result) {
          classList.Add(ClassToDTO(new Class { Id = c.Id, ProfessorUserID = c.ProfessorID, Name = c.Name,  Description = c.Description}));
      }

      return classList;
  }
        
         
         
         
        // PUT: api/Classes/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutClass(int id, Class @class)
        {
            if (id != @class.Id)
            {
                return BadRequest();
            }

            _context.Entry(@class).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ClassExists(id))
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
        
         
         
                 // POST: api/Classes
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Class>> PostClass(ClassDTO classDTO)
        {
            if (_context.Classes == null)
            {
                return Problem("Entity set 'WT_DBContext.Classes'  is null.");
            }
            
            Class @class = new Class
            {
                Id = classDTO.Id,
                Name = classDTO.Name,
                ProfessorUserID = classDTO.ProfessorID,
                Description = classDTO.Description
            };

            _context.Classes.Add(@class);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetClass", new { id = @class.Id }, @class);
        }*/


    }
}
