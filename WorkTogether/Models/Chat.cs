namespace WorkTogether.Models
{
    public class Chat
    {

        public int Id { get; set; }

        public string Name { get; set; }

        public ICollection<Message> Messages { get; set;}

        public ICollection<User> Users { get; set;}
    }

    public class ChatInfoDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public List<UserProfileDTO> Users { get; set; }
    }
}
