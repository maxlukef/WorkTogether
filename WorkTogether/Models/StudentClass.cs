namespace WorkTogether.Models
{
    /// <summary>
    /// Join table for the many-many relationship of Users(as students) and Classes
    /// </summary>
    public class StudentClass
    {
        public int ID { get; set; }
        public Class Class { get; set; }

        public User Student {get; set;} 
    }
}
