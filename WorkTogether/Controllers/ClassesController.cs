using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Drawing.Printing;
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

        // GET: api/Classes/5
        [HttpGet("{id}")]
        public async Task<ActionResult<ClassDTO>> GetClass(int id)
        {
            if (_context.Classes == null)
            {
                return NotFound();
            }
            var @class = ClassToDTO(await _context.Classes.Include(c => c.Professor).Where(c => c.Id == id).FirstOrDefaultAsync());

            if (@class == null)
            {
                return NotFound();
            }

            return @class;
        }



        /// <summary>
        /// Allows professors to get the invite code for a class, that they can then give to students to allow them to join on Work Together
        /// </summary>
        /// <param name="classid">The ID of the class</param>
        /// <returns>A string(the code)</returns>
        [HttpGet("getinvitecode/{classid}")]
        [Authorize]
        public async Task<ActionResult<string>> GetInviteCode(int classid)
        {
            User curr = GetCurrentUser(HttpContext);
            Class c = await _context.Classes.Where(c => c.Id == classid).Include(c => c.Professor).FirstOrDefaultAsync();
            if (c == null)
            {
                return NotFound();
            }
            if (c.Professor != curr)
            {
                return Unauthorized();
            }
            return c.InviteCode;
        }

        /// <summary>
        /// Allows a student to join a class with it's invite code.
        /// </summary>
        /// <param name="invcode">The invite code</param>
        /// <returns>a DTO for the joined class, if successful.</returns>
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
            if (await _context.StudentClasses.Include(sc => sc.Student).Include(sc => sc.Class).Where(sc => sc.Class == c && sc.Student == curr).CountAsync() > 0)
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

            List<StudentClass> c_u = await _context.StudentClasses.Include(sc => sc.Student).Include(sc => sc.Class).Where(sc => sc.Student == u && sc.Class.Id == id).ToListAsync();



            if (c_u.Count == 0 && c.Professor.Id != u.Id)
            {
                return Unauthorized();
            }


            List<StudentClass> sc = await _context.StudentClasses.Include(s => s.Class).Include(s => s.Student).Where(s => s.Class.Id == id).ToListAsync();
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

            var professorClasses = await _context.Classes.Include(c => c.Professor).Where(c => c.Professor == u).ToListAsync();
            foreach (var c in professorClasses)
            {
                classes.Add(ClassToDTO(c));
            }
            return classes;
        }

        /// <summary>
        /// Gets the classes that the current user is professor for.
        /// </summary>
        /// <returns>A list of classes</returns>
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

        /// <summary>
        /// Creates a class, assigning the user doing it as professor.
        /// </summary>
        /// <param name="cd">The CreateClassDTO with the info to create the class.</param>
        /// <returns>If successful, a ClassDTO for the new class.</returns>
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

        /// <summary>
        /// Allows a professor to edit the info for their class
        /// </summary>
        /// <param name="cd">an EditClassDTO containing the changes</param>
        /// <returns>a ClassDTO for the edited class, if successful.</returns>
        [HttpPost("edit")]
        [Authorize]
        public async Task<ActionResult<ClassDTO>> EditClass(EditClassDTO cd)
        {
            User curr = GetCurrentUser(HttpContext);
            Class c = await _context.Classes.Where(c => c.Id == cd.Id).Include(c => c.Professor).FirstOrDefaultAsync();
            if (c == null)
            {
                return NotFound(cd);
            }
            if (c.Professor != curr)
            {
                return Unauthorized();
            }
            c.Name = cd.Name;
            c.Description = cd.Description;
            _context.SaveChanges();
            return ClassToDTO(c);
        }



        /// <summary>
        /// Allows a prof to delete one of their classes.
        /// </summary>
        /// <param name="id">The ID of the class</param>
        /// <returns>200 ok if successful.</returns>
        [HttpDelete("{id}")]
        [Authorize]
        public async Task<IActionResult> DeleteClass(int id)
        {
            User curr = GetCurrentUser(HttpContext);
            if (_context.Classes == null)
            {
                return NotFound();
            }
            var @class = await _context.Classes.Include(c => c.Professor).Where(c => c.Id == id).FirstOrDefaultAsync();
            if (@class == null)
            {
                return NotFound();
            }
            if (@class.Professor != curr)
            {
                return Unauthorized();
            }

            _context.Classes.Remove(@class);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        /// <summary>
        /// Gets the current authorized user making a request
        /// </summary>
        /// <param name="httpContext">The HTTPContext from inside the endpoint</param>
        /// <returns>the current User</returns>
        private User GetCurrentUser(HttpContext httpContext)
        {
            string userEmail = httpContext.User.Identity.Name;
            User u1 = _context.Users.Where(u => u.Email == userEmail).FirstOrDefault();
            return u1;
        }

        /// <summary>
        /// Turns a class into a DTO
        /// </summary>
        /// <param name="curClass">The class</param>
        /// <returns>The DTO</returns>
        private static ClassDTO ClassToDTO(Class curClass) =>
            new ClassDTO
            {
                Id = curClass.Id,
                Name = curClass.Name,
                ProfessorID = curClass.Professor.UserId,
                Description = curClass.Description
            };

        /// <summary>
        /// Converts a User into a UserProfileDTO
        /// </summary>
        /// <param name="user">The user</param>
        /// <returns>The DTO</returns>
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
