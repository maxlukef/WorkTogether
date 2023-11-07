using System.ComponentModel.DataAnnotations.Schema;

namespace WorkTogether.Models
{
    /// <summary>
    /// Model class for a class.
    /// </summary>
    public class Class
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        public int ProfessorUserID { get; set; }
        public User? Professor { get; set; }
        public string Name { get; set; }
        public string? Description { get; set; }
        public ICollection<StudentClass>? StudentClasses { get; set; }
        public ICollection<TAClass>? TAClasses { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        
        public string InviteCode { get; set; }

        
    }

    public class ClassDTO
    {
        public int Id { get; set; }
        public int ProfessorID { get; set; }
        public string Name { get; set; }
        public string? Description { get; set; }
    }
}
