using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

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
            // connect to mysql with connection string from app settings
            var connectionString = Configuration.GetConnectionString("WebApiDatabase");
            options.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString));
        }

        public DbSet<TodoItem> TodoItems { get; set; } = null!;
    }
}
