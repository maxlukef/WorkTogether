using WorkTogether.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace WorkTogether.Controllers
{
    /// <summary>
    /// This code is mostly from this tutorial: https://jayanttripathy.com/jwt-authentication-and-authorization-with-identity-framework-in-net-core-6-0/
    /// Supplies the endpoints for authorization actions.
    /// </summary>
    public class AuthController : ControllerBase
    {
        private readonly WT_DBContext _context;
        private readonly UserManager<User> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly IConfiguration _configuration;
        public AuthController(
            UserManager<User> userManager,
            RoleManager<IdentityRole> roleManager,
            IConfiguration configuration,
            WT_DBContext context)
        {
            _userManager = userManager;
            _roleManager = roleManager;
            _configuration = configuration;
            _context = context;
        }


        [HttpPost]
        [Route("login")]
        public async Task<IActionResult> Login([FromBody] Login model)
        {
            var user = await _userManager.FindByNameAsync(model.Username);
            if (user != null && await _userManager.CheckPasswordAsync(user, model.Password))
            {
                var userRoles = await _userManager.GetRolesAsync(user);
                var authClaims = new List<Claim>
                {
                    new Claim(ClaimTypes.Name, user.UserName),
                    new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                };
                foreach (var userRole in userRoles)
                {
                    authClaims.Add(new Claim(ClaimTypes.Role, userRole));
                }
                var token = GetToken(authClaims);//here
                return Ok(new
                {
                    token = new JwtSecurityTokenHandler().WriteToken(token),
                    expiration = token.ValidTo
                });
            }
            return Unauthorized();
        }

        [HttpPost]
        [Route("register")]
        public async Task<IActionResult> Register([FromBody] Register model)
        {
            var userExists = await _userManager.FindByNameAsync(model.Email);
            if (userExists != null)
                return StatusCode(StatusCodes.Status500InternalServerError, new Response { Status = "Error", Message = "User already exists!" });

            int max_userID = _context.Users.Max(p => p.UserId);
            User user = new()
            {
                Email = model.Email,
                UserName = model.Email, //we dont have much use for a username at this point, just set it to the email
                SecurityStamp = Guid.NewGuid().ToString(),
                Name = model.Name,
                Bio = model.Bio,
                Major = model.Major,
                EmploymentStatus = model.EmploymentStatus,
                Interests = model.Interests,
                StudentStatus = model.EmploymentStatus,
                UserId = max_userID + 1
            };
            var result = await _userManager.CreateAsync(user, model.Password);
            if (!result.Succeeded)
                return StatusCode(StatusCodes.Status500InternalServerError, new Response { Status = "Error", Message = "User creation failed! Please check user details and try again." });
            if (!await _roleManager.RoleExistsAsync(UserRoles.User))
                await _roleManager.CreateAsync(new IdentityRole(UserRoles.User));
            await _userManager.AddToRoleAsync(user, UserRoles.User);
            return Ok(new Response { Status = "Success", Message = "User created successfully!" });
        }

        [HttpPost]
        [Route("register-admin")]
        public async Task<IActionResult> RegisterAdmin([FromBody] Register model)
        {
            //ensure that there isn't already a user with this email
            var userExists = await _userManager.FindByNameAsync(model.Email);
            if (userExists != null)
                return StatusCode(StatusCodes.Status500InternalServerError, new Response { Status = "Error", Message = "User already exists!" });
            int max_userID = _context.Users.Max(p => p.UserId);
            User user = new()
            {
                Email = model.Email,
                UserName = model.Email, //we dont have much use for a username at this point, just set it to the email
                SecurityStamp = Guid.NewGuid().ToString(),
                Name = model.Name,
                Bio = model.Bio,
                Major = model.Major,
                EmploymentStatus = model.EmploymentStatus,
                Interests = model.Interests,
                StudentStatus = model.EmploymentStatus,
                UserId = max_userID + 1

            };
            var result = await _userManager.CreateAsync(user, model.Password);
            if (!result.Succeeded)
                return StatusCode(StatusCodes.Status500InternalServerError, new Response { Status = "Error", Message = "User creation failed! Please check user details and try again." });
            if (!await _roleManager.RoleExistsAsync(UserRoles.Admin))
                await _roleManager.CreateAsync(new IdentityRole(UserRoles.Admin));
            if (!await _roleManager.RoleExistsAsync(UserRoles.User))
                await _roleManager.CreateAsync(new IdentityRole(UserRoles.User));
            if (await _roleManager.RoleExistsAsync(UserRoles.Admin))
            {
                await _userManager.AddToRoleAsync(user, UserRoles.Admin);
            }
            if (await _roleManager.RoleExistsAsync(UserRoles.Admin))
            {
                await _userManager.AddToRoleAsync(user, UserRoles.User);
            }
            return Ok(new Response { Status = "Success", Message = "User created successfully!" });
        }

        private JwtSecurityToken GetToken(List<Claim> authClaims)
        {

            var authSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["JWTAuth:SecretKey"]));
            var token = new JwtSecurityToken(
                issuer: _configuration["JWTAuth:ValidIssuer"],
                audience: _configuration["JWTAuth:ValidAudience"],
                expires: DateTime.Now.AddHours(3),
                claims: authClaims,
                signingCredentials: new SigningCredentials(authSigningKey, SecurityAlgorithms.HmacSha256)
                );
            return token;
        }
    }
}
