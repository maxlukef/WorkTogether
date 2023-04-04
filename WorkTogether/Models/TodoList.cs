namespace WorkTogether.Models
{
    public class TodoList
    {
        public int Id { get; set; }
        public string ListName { get; set; }   
        public string Owner { get; set; }
        public ICollection<TodoItem> Items { get; set; }
    }
}
