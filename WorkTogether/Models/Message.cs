namespace WorkTogether.Models
{
    public class Message
    {
        public int Id { get; set; }
        public string Content { get; set; }

        public User Sender { get; set; }

        public DateTime Sent { get; set; }

        public Chat chat { get; set; }
    }

    public class SendMessageDTO
    {
        public int ChatID { get; set; }

        public string Message { get; set; }
    }

    public class MessageDTO
    {
        public string Content { get; set; }

        public int SenderID { get; set; }

        public string SenderName { get; set; }

        public string Sent { get; set; }
    }
}
