namespace WorkTogether.Models
{
    /// <summary>
    /// Represents a question on a questionnaire
    /// </summary>
    public class Question
    {
        public int Id { get; set; }
        /// <summary>
        /// The string representation of a question.
        /// </summary>
        public string Prompt { get; set; }

        /// <summary>
        /// This represents the type of response that we should be expecting, i.e. String, Int, Boolean...
        /// </summary>
        public string Type { get; set; }
        
        /// <summary>
        /// The Questionnaire that this Question is a part of.
        /// </summary>
        public Questionnaire Questionnaire { get; set; }
    }
}
