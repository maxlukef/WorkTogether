using System.ComponentModel.DataAnnotations;

namespace WorkTogether.Models
{
    public class Register
    {
        [EmailAddress]
        [Required(ErrorMessage = "Email is required")]
        public string? Email { get; set; }
        [Required(ErrorMessage = "Password is required")]
        public string? Password { get; set; }

        [Required(ErrorMessage = "Name is required")]
        public string? Name { get; set; }

        [Required(ErrorMessage = "Bio is required")]
        public string? Bio { get; set; }

        [Required(ErrorMessage = "Major is required")]
        public string? Major { get; set; }

        [Required(ErrorMessage = "Employment Status is required")]
        public string? EmploymentStatus { get; set; }

        [Required(ErrorMessage = "Student Status is required")]
        public string? StudentStatus { get; set; }
        //Comma separated string detailing the user's interests
        [Required(ErrorMessage = "Interests are required")]
        public string? Interests { get; set; }
    }
}
