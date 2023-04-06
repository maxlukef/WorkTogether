namespace WorkTogether.Models
{
    /// <summary>
    /// Join table for the many-many relationship of Users (as TAs) and Classes.
    /// </summary>
    public class TAClass
    {
        public int ID { get; set; }
        Class Class { get; set; }

        User TA {get; set; }
    }
}
