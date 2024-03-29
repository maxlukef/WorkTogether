﻿using WorkTogether.Models;
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
    /// This code is based on this tutorial: https://jayanttripathy.com/jwt-authentication-and-authorization-with-identity-framework-in-net-core-6-0/. D
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

        /// <summary>
        /// Confirms a user's email address. Made to be called from an emailed link.
        /// </summary>
        /// <param name="token">The confirmation token embedded in the link</param>
        /// <param name="email">The user's email address, also embedded in the link</param>
        /// <returns>200 OK if successful</returns>
        [HttpGet("ConfirmEmail")]
        public async Task<IActionResult> ConfirmEmail(string token, string email)
        {
            var user = await _userManager.FindByEmailAsync(email);
            if (user == null)
                return NotFound(email);

            var result = await _userManager.ConfirmEmailAsync(user, token);
            User u = _context.Users.Where(u => u.Email == email).FirstOrDefault();
            if (result.Succeeded)
            {
                u.EmailConfirmed = true;
                _context.SaveChanges();
                return Ok("Email confirmed!");
            }
            return Problem("Confirmation Failed!");
        }
        /// <summary>
        /// Generates a JWT bearer token
        /// </summary>
        /// <param name="model">The login model, which contains 2 fields, Username and Password</param>
        /// <returns>a token to be sent in future requests for authentication</returns>
        [HttpPost]
        [Route("api/login")]
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
                    id = user.UserId,
                    name = user.Name,
                });
            }
            return Unauthorized();
        }

        /// <summary>
        /// Registers a new user
        /// </summary>
        [HttpPost]
        [Route("api/register")]
        public async Task<IActionResult> Register([FromBody] Register model)
        {
            var userExists = await _userManager.FindByNameAsync(model.Email);
            if (userExists != null)
                return StatusCode(StatusCodes.Status500InternalServerError, new Response { Status = "Error", Message = "User already exists!" });

            int max_userID = 0;
            if (_context.Users.Count() > 0)
            {
                max_userID = _context.Users.Max(p => p.UserId);
            }
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
                StudentStatus = model.StudentStatus,
                UserId = max_userID + 1
            };
            var result = await _userManager.CreateAsync(user, model.Password);
            if (!result.Succeeded)
                return StatusCode(StatusCodes.Status500InternalServerError, new Response { Status = "Error", Message = "User creation failed! Please check user details and try again." });
            if (!await _roleManager.RoleExistsAsync(UserRoles.User))
                await _roleManager.CreateAsync(new IdentityRole(UserRoles.User));
            await _userManager.AddToRoleAsync(user, UserRoles.User);

            //semd a verification email 
            if (result.Succeeded)
            {
                var emailtoken = await _userManager.GenerateEmailConfirmationTokenAsync(user);
                string emailParams = user.Email + "/" + emailtoken;
                var confirmationLink = Url.Action("ConfirmEmail", "Auth", new { token = emailtoken, email = user.Email }, Request.Scheme);

                EmailHelper emailHelper = new EmailHelper();
                string message = "<a href=\"" + confirmationLink + "\">Click here to confirm your email</a>";
                bool emailResponse = emailHelper.SendEmail(user.Email, message, "Confirm your email!");

            }


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
                id = user.UserId,
                name = user.Name,
            });
        }

        /// <summary>
        /// Registers an administrator
        /// </summary>
        [HttpPost]
        [Route("api/register-admin")]
        public async Task<IActionResult> RegisterAdmin([FromBody] Register model)
        {
            //ensure that there isn't already a user with this email
            var userExists = await _userManager.FindByNameAsync(model.Email);
            if (userExists != null)
                return StatusCode(StatusCodes.Status500InternalServerError, new Response { Status = "Error", Message = "User already exists!" });
            int max_userID = 0;
            if (_context.Users.Count() > 0)
            {
                max_userID = _context.Users.Max(p => p.UserId);
            }
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

        /// <summary>
        /// Gets the auth token for signing in a User
        /// </summary>
        /// <param name="authClaims">The user's claims</param>
        /// <returns>the JwtSecurityToken</returns>
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
