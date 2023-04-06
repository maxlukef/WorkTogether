namespace WorkTogether.Models
{
    /// <summary>
    /// Model class for a milestone in Work Together
    /// </summary>
    public class Milestone
    {
        public Project Project { get; set; }
        public string Title { get; set; }
        
        public string Description { get; set; }

        public DateOnly Deadline { get;set; }


    }
}
