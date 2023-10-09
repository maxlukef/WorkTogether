using Microsoft.Identity.Client;

namespace WorkTogether.Models
{
    public class Notification
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public Boolean IsInvite { get; set; }
        public int AttachedProject { get; set; }
        public int FromID { get; set; }
        public string FromName { get; set; }
        public int ToID { get; set; }
        public string ToName { get; set; }
        public DateTime SentAt { get; set; }
        public Boolean Read { get; set; }
    }

    public class NotificationDTO
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public Boolean IsInvite { get; set; }
        public int ProjectID { get; set; }
        public string? ProjectName { get; set; }
        public int ClassID { get; set; }
        public string? ClassName { get; set; }
        public int FromID { get; set; }
        public string FromName { get; set; }
        public int ToID { get; set; }
        public string ToName { get; set; }
        public DateTime SentAt { get; set; }
        public Boolean Read { get; set; }
    }
}
