using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WorkTogether.Models
{
    /// <summary>
    /// Model class for a user in Work Together
    /// </summary>
    [Index(nameof(UserId), IsUnique = true)]
    [Table("AspNetUsers")]
    public class User : IdentityUser
    {
        
        public int UserId { get; set; }
        public string Name { get; set; }
        public string Bio { get; set; }
        public string Major { get; set; }
        public ICollection<StudentClass>? StudentClasses { get; set; }
        public ICollection<TAClass>? TAClasses { get; set; }
        public ICollection<Team>? Teams { get; set; }
        public ICollection<TaskItem>? Tasks { get; set; }
        public string EmploymentStatus { get; set; }
        public string StudentStatus { get; set; }
        //Comma separated string detailing the user's interests
        public string Interests { get; set; }
    }

    public class UserProfileDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Bio { get; set; }
        public string Major { get; set; }
        public string EmploymentStatus { get; set; }
        public string StudentStatus { get; set; }
        public string Interests { get; set; }

        
    }

    
}
