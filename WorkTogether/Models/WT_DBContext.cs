using Microsoft.AspNetCore.Hosting.Server;
using Microsoft.EntityFrameworkCore;
using MySql.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using static System.Net.Mime.MediaTypeNames;

namespace WorkTogether.Models
{
    public class WT_DBContext : DbContext
    {
        public WT_DBContext(DbContextOptions<WT_DBContext> options)
            : base(options)
        {
        }

        protected readonly IConfiguration Configuration;
        protected override void OnConfiguring(DbContextOptionsBuilder options)
        {
        }

        public DbSet<TodoItem> TodoItems { get; set; } = null!;
        public DbSet<TodoList> TodoLists { get; set; } = null!;

        public DbSet<User> Users { get; set; } = null!;
        public DbSet<Class> Classes { get; set; } = null!;

        //These exist to make the many to many relationships between Users and Classes work.
        public DbSet<TAClass> TAClasses { get; set; } = null!;
        public DbSet<StudentClass> StudentClasses { get; set; } = null!;
    }
}
