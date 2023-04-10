namespace WorkTogether.Models
{
    /// <summary>
    /// Model class for a Work Together project.
    /// </summary>
    public class Project
    {
        public int Id { get; set; }
        public string Name { get; set; }
        
        public string Description { get; set; }

        public Class Class { get; set; }
        
        public int MinTeamSize { get; set; }

        public int MaxTeamSize { get; set; }

        public DateOnly Deadline { get; set; }

        public Questionnaire Questionnaire { get; set; }
    }
}
