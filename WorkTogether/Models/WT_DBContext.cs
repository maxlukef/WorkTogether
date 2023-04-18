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
        public async Task Seed()
        {
            if(Users.Count<User>() == 0)
            {
                User newUser = new User();
                newUser.Name = "John Coder";
                newUser.Interests = "Hiking,Biking,Coding";
                newUser.StudentStatus = "Full Time Student";
                newUser.Bio = "As an avid outdoor enthusiast and software developer, I have found a perfect balance between my two passions. In my free time, I love to explore new trails and go camping.";
                newUser.Email = "u0000000@utah.edu";
                newUser.EmploymentStatus = "Unemployed";
                
                
                User newUser2 = new User();
                newUser2.Name = "Bob Programmer";
                newUser2.Interests = "Cinema,Skiing,Programming";
                newUser2.StudentStatus = "Professor";
                newUser2.Bio = "As a capstone professor and film critic, I spend my days assisting students in learning programming and my evenings watching movies.";
                newUser2.Email = "u0000001@utah.edu";
                newUser2.EmploymentStatus = "Full Time";
                
                
                //this.SaveChanges();
                Class newClass = new Class();
                newClass.Name = "CS 2420: Data Structures and Algs";
                newClass.Description = "The first half of the capstone project.";
                newClass.Professor = newUser2;
                

                StudentClass johnClass = new StudentClass();
                johnClass.Student = newUser;
                johnClass.Class = newClass;

<<<<<<< WorkTogether/Models/WT_DBContext.cs
                Users.Add(newUser);
                Users.Add(newUser2);
                StudentClasses.Add(johnClass);
                Classes.Add(newClass);

                this.SaveChanges();
                
            }
        }
        public DbSet<TodoItem> TodoItems { get; set; } = null!;
        public DbSet<TodoList> TodoLists { get; set; } = null!;
=======

>>>>>>> WorkTogether/Models/WT_DBContext.cs

        public DbSet<User> Users { get; set; } = null!;
        public DbSet<Class> Classes { get; set; } = null!;

        public DbSet<Project> Projects { get; set; } = null!;

        public DbSet<Milestone> Milestones { get; set; } = null!;

        public DbSet<Team> Teams { get; set; } = null!;

        public DbSet<TaskItem> Tasks { get; set; } = null!;

        public DbSet<Questionnaire> Questionnaires { get; set; } = null!;

        public DbSet<Question> Questions { get; set; } = null!;

        public DbSet<Answer> Answers { get; set; } = null!;


        //These exist to make the multiple many to many relationships between Users and Classes work.
        public DbSet<TAClass> TAClasses { get; set; } = null!;
        public DbSet<StudentClass> StudentClasses { get; set; } = null!;
    }
}
