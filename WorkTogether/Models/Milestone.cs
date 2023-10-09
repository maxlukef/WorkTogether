namespace WorkTogether.Models
{
    /// <summary>
    /// Model class for a milestone in Work Together
    /// </summary>
    public class Milestone
    {
        public int Id { get; set; }
        public Project Project { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime Deadline { get;set; }
        public ICollection<TaskItem> tasks { get; set; }
    }

    public class MilestoneDTO
    {
        public int Id { get; set; }
        public int ProjectID { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime Deadline { get; set; }

    }
}
