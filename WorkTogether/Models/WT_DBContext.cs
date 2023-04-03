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
            if (!options.IsConfigured)
            {
                //options.UseMySQL("server=localhost;port=3306;user=root;password=;database=database");
            }
            // connect to mysql with connection string from app settings
            var connectionString = Configuration.GetConnectionString("WebApiDatabase");
            //options.UseMySQL("Server = localhost; Port = 3306; Database = worktogether; User ID = test; Password = test;");
        }

        public DbSet<TodoItem> TodoItems { get; set; } = null!;
    }
}
