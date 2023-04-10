namespace WorkTogether.Models
{
    /// <summary>
    /// Represents a Questionnaire for the team building phase of Work Together
    /// </summary>
    public class Questionnaire
    {
        public int Id { get; set; }
        
        /// <summary>
        /// List of Questions on this Questionnaire
        /// </summary>
        public ICollection<Question> Questions { get; set; }

        /// <summary>
        /// The Project that this Questionnaire is associated with
        /// </summary>
        public Project Project { get; set; }

        public int ProjectID { get; set; }
    }
}
