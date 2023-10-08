namespace WorkTogether.Models
{
    public class TaskItem
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public Team Team { get; set; }
        public string Description {get; set; }
        public TaskItem? ParentTask { get; set; }
        public Milestone? ParentMilestone { get; set; }
        public ICollection<User> Assignees { get; set; }
        public DateTime DueDate { get; set; }
        public DateTime CreatedAt { get; set; }
        public Boolean Completed { get; set; }
    }

    //If the pa
    public class BasicTaskDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public int TeamID { get; set; }
        public int? ParentTaskID { get; set; }
        public int? ParentMilestoneID { get; set; }
        public ICollection<int> Assignees { get; set; }
        //Year-Month-Day
        public string DueDate { get; set; }
        public Boolean Completed { get; set; }
    }

    public class ReturnTaskDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public int TeamID { get; set; }
        public int? ParentTaskID { get; set; }
        public int? ParentMilestoneID { get; set; }
        public ICollection<UserProfileDTO> Assignees { get; set; }
        //Year-Month-Day
        public string DueDate { get; set; }
        public Boolean Completed { get; set; }
    }

    public class CreateTaskDTO
    {
        public string Name { get; set; }
        public string Description { get; set; }
        public int TeamID { get; set; }
        public int? ParentTaskID { get; set; }
        public int? ParentMilestoneID { get; set; }
        public ICollection<int> Assignees { get; set; }
        //Year-Month-Day
        public string DueDate { get; set; }
        public Boolean Completed { get; set; }
    }
}
