namespace WorkTogether.Models
{
    public class TaskItem
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public Team Team { get; set; }

        public string Description {get; set; }
        public TaskItem? ParentTask { get; set; }
        public Milestone ParentMilestone { get; set; }
        public ICollection<User> Assignees { get; set; }
    }
}
