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

    public class ChatRenameDTO
    {
        public int Id { get; set; }
        public string NewName { get; set; }
    }


    //Set name to an empty string to use default generated name
    public class CreateChatDTO
    {
        public string Name { get; set; }

        public List<int> UserIDs { get; set; }
    }


}
