using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WorkTogether.Models
{
    public class Login
    {

        [Required(ErrorMessage = "User Name is required")]
        public string? Username { get; set; }
        [Required(ErrorMessage = "Password is required")]
        public string? Password { get; set; }
    }
}
