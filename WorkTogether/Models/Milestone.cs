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

        public ICollection<Team> CompleteTeams { get; set; }
    }

    public class MilestoneDTO
    {
        public int Id { get; set; }
        public int ProjectID { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime Deadline { get; set; }

    }

    public class MilestoneDTOWithComplete
    {
        public int Id { get; set; }
        public int ProjectID { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime Deadline { get; set; }
        public bool Complete { get; set; }

    }

    public class CreateMilestoneDTO
    {
        public int ProjectID { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime Deadline { get; set; }

    }

    public class CompleteRatioDTO
    {
        public MilestoneDTO md { get; set; }
        public int complete { get; set; }
        public int numteams { get; set; }

    }

    public class CompleteIncompleteTeamsDTO
    {
        
        public List<TeamDTO> complete { get; set; }
        public List<TeamDTO> incomplete { get; set; }

    }
}
