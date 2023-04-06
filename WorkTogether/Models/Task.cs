namespace WorkTogether.Models
{
    public class Task
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public Team Team { get; set; }
        public Task? ParentTask { get; set; }
        public Milestone ParentMilestone { get; set; }
        public ICollection<User> Assignees { get; set; }
    }
}
