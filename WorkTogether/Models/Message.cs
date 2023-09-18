namespace WorkTogether.Models
{
    public class Message
    {
        public int Id { get; set; }
        public string Content { get; set; }

        public User Sender { get; set; }

        public DateTime Sent { get; set; }
    }
}
