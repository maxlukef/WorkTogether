using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WorkTogether.Models
{
    /// <summary>
    /// Model class for a user in Work Together
    /// </summary>
    public class User
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        public string Name { get; set; }

        public string Email { get; set; }

        public string Bio { get; set; }

        public ICollection<StudentClass> StudentClasses { get; set; }

        public ICollection<TAClass> TAClasses { get; set; }

        public ICollection<Team> Teams { get; set; }

        public ICollection<TaskItem> Tasks { get; set; }


    }
}
