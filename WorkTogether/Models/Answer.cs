namespace WorkTogether.Models
{
    /// <summary>
    /// Represents a students answer to a question on a questionnaire
    /// </summary>
    public class Answer
    {
        public int Id { get; set; }
        
        /// <summary>
        /// Holds a string representation of the answer to a question.
        /// </summary>
        public string AnswerStr { get; set; }

        /// <summary>
        /// The Question object to be answered.
        /// </summary>
        public Question Question { get; set; }

        /// <summary>
        /// The User who's Answer this is.
        /// </summary>
        public User Answerer { get; set; }
    }

    public class AnswerDTO
    {
        public int Id { get; set; }
        public string AnswerText { get; set; }
        public int QuestionId { get; set; }
        public int AnswererId { get; set; }
        public string AnswererName { get; set; }
    }
}
