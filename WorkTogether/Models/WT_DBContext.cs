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


        /// <summary>
        /// Seeds dummy users and dummy classes if your database is empty.
        /// </summary>
        public async Task Seed()
        {
            if (Users.Count<User>() == 0)
            {
                User newUser2 = new User();
                newUser2.Name = "Bob Programmer";
                newUser2.Interests = "Cinema,Skiing,Programming";
                newUser2.StudentStatus = "Professor";
                newUser2.Bio = "As a capstone professor and film critic, I spend my days assisting students in learning programming and my evenings watching movies.";
                newUser2.Email = "u0000001@utah.edu";
                newUser2.EmploymentStatus = "Full Time";
                Users.Add(newUser2);

                Class newClass = new Class();
                newClass.Name = "CS 2420: Data Structures and Algs";
                newClass.Description = "The weed-out class.";
                newClass.Professor = newUser2;
                Classes.Add(newClass);

                Class newClass2 = new Class();
                newClass2.Name = "CS 4000: Capstone Design";
                newClass2.Description = "The first phase of the capstone project.";
                newClass2.Professor = newUser2;
                Classes.Add(newClass2);

<<<<<<< WorkTogether/Models/WT_DBContext.cs
                User newUser = new User();
                newUser.Name = "John Coder";
                newUser.Interests = "Hiking,Biking,Coding";
                newUser.StudentStatus = "Full Time Student";
                newUser.Bio = "As an avid outdoor enthusiast and software developer, I have found a perfect balance between my two passions. In my free time, I love to explore new trails and go camping.";
                newUser.Email = "u0000000@utah.edu";
                newUser.EmploymentStatus = "Unemployed";
=======
>>>>>>> WorkTogether/Models/WT_DBContext.cs
                Users.Add(newUser);

<<<<<<< WorkTogether/Models/WT_DBContext.cs
                StudentClass studentClass1 = new StudentClass();
                studentClass1.Class = newClass;
                studentClass1.Student = newUser;
                StudentClasses.Add(studentClass1);

                User newUser3 = new User();
                newUser3.Name = "Jim Roberts";
                newUser3.Interests = "Fishing, Cartography";
                newUser3.StudentStatus = "Full Time Student";
                newUser3.Bio = "As a fishing cartographer, I am concerned with the mapping of fishing spots";
                newUser3.Email = "u0000002@utah.edu";
                newUser3.EmploymentStatus = "Unemployed";
                Users.Add(newUser3);
=======
                this.SaveChanges();
                
            }
        }
>>>>>>> WorkTogether/Models/WT_DBContext.cs

                StudentClass studentClass2 = new StudentClass();
                studentClass2.Class = newClass;
                studentClass2.Student = newUser3;
                StudentClasses.Add(studentClass2);

                User newUser4 = new User();
                newUser4.Name = "Sebastion Carson";
                newUser4.Interests = "Barbecue, Butterfly Watching, Flutter";
                newUser4.StudentStatus = "Part Time Student";
                newUser4.Bio = "As an avid butterfly watcher, I am very good at writing Flutter frontends. I also smoke a mean brisket.";
                newUser4.Email = "u0000003@utah.edu";
                newUser4.EmploymentStatus = "Part Time";
                Users.Add(newUser4);

                StudentClass studentClass3 = new StudentClass();
                studentClass3.Class = newClass;
                studentClass3.Student = newUser4;
                StudentClasses.Add(studentClass3);

                User newUser5 = new User();
                newUser5.Name = "Ronda Carey";
                newUser5.Interests = "Cheese Making, Carpet Weaving, Embedded Systems";
                newUser5.StudentStatus = "Part Time Student";
                newUser5.Bio = "I specialize in embedded systems. I also enjoy weaving carpets and making cheese.";
                newUser5.Email = "u0000004@utah.edu";
                newUser5.EmploymentStatus = "Part Time";
                Users.Add(newUser5);

                StudentClass studentClass4 = new StudentClass();
                studentClass4.Class = newClass;
                studentClass4.Student = newUser5;
                StudentClasses.Add(studentClass4);

                User newUser6 = new User();
                newUser6.Name = "Dale Hayden";
                newUser6.Interests = "Jigsaw Puzzles, Horseback Riding, React.js";
                newUser6.StudentStatus = "Full Time Student";
                newUser6.Bio = "I specialize in React.js. I also enjoy horseback riding and jigsaw puzzles.";
                newUser6.Email = "u0000005@utah.edu";
                newUser6.EmploymentStatus = "Unemployed";
                Users.Add(newUser6);

                StudentClass studentClass5 = new StudentClass();
                studentClass5.Class = newClass;
                studentClass5.Student = newUser6;
                StudentClasses.Add(studentClass5);


                User newUser7 = new User();
                newUser7.Name = "Harriett Morton";
                newUser7.Interests = "Kickball, Furniture Building, ASP .NET Core";
                newUser7.StudentStatus = "Full Time Student";
                newUser7.Bio = "I specialize in Microsoft's ASP.NET Core architecture. I also play kickball and build furniture.";
                newUser7.Email = "u0000006@utah.edu";
                newUser7.EmploymentStatus = "Unemployed";
                Users.Add(newUser7);

                StudentClass studentClass6 = new StudentClass();
                studentClass6.Class = newClass;
                studentClass6.Student = newUser7;
                StudentClasses.Add(studentClass6);

                StudentClass studentClass2_7 = new StudentClass();
                studentClass2_7.Class = newClass2;
                studentClass2_7.Student = newUser7;
                StudentClasses.Add(studentClass2_7);

                User newUser8 = new User();
                newUser8.Name = "Donny Owen";
                newUser8.Interests = "Urban Spelunking, Geocaching, Leetcoding";
                newUser8.StudentStatus = "Part Time Student";
                newUser8.Bio = "I enjoy leetcoding as a hobby. I also like geocaching and urban spelunking.";
                newUser8.Email = "u0000007@utah.edu";
                newUser8.EmploymentStatus = "Unemployed";
                Users.Add(newUser8);

                StudentClass studentClass7 = new StudentClass();
                studentClass7.Class = newClass;
                studentClass7.Student = newUser8;
                StudentClasses.Add(studentClass7);

                StudentClass studentClass2_8 = new StudentClass();
                studentClass2_8.Class = newClass2;
                studentClass2_8.Student = newUser8;
                StudentClasses.Add(studentClass2_8);

                User newUser9 = new User();
                newUser9.Name = "Melissa Walker";
                newUser9.Interests = "Rock Painting, Drawing Charicatures, OpenGL";
                newUser9.StudentStatus = "Full Time Student";
                newUser9.Bio = "As an artist, I am primarily concerned with Rock Painting, Charicatures, and OpenGL";
                newUser9.Email = "u0000008@utah.edu";
                newUser9.EmploymentStatus = "Unemployed";
                Users.Add(newUser9);

                StudentClass studentClass8 = new StudentClass();
                studentClass8.Class = newClass;
                studentClass8.Student = newUser9;
                StudentClasses.Add(studentClass8);

                StudentClass studentClass2_9 = new StudentClass();
                studentClass2_9.Class = newClass2;
                studentClass2_9.Student = newUser9;
                StudentClasses.Add(studentClass2_9);

                User newUser10 = new User();
                newUser10.Name = "Ian Sheppard";
                newUser10.Interests = "Beach Volleyball, Record Collecting, Data Science";
                newUser10.StudentStatus = "Part Time Student";
                newUser10.Bio = "I am an avid data scientist and i enjoy applying those skills to my record collection. I like to stay active by playing Beach Volleyball.";
                newUser10.Email = "u0000009@utah.edu";
                newUser10.EmploymentStatus = "Part Time";
                Users.Add(newUser10);

                StudentClass studentClass9 = new StudentClass();
                studentClass9.Class = newClass;
                studentClass9.Student = newUser10;
                StudentClasses.Add(studentClass9);

                StudentClass studentClass2_10 = new StudentClass();
                studentClass2_10.Class = newClass2;
                studentClass2_10.Student = newUser10;
                StudentClasses.Add(studentClass2_10);

                User newUser11 = new User();
                newUser11.Name = "Susan Scott";
                newUser11.Interests = "Flower Arranging, Windsurfing, Networks";
                newUser11.StudentStatus = "Full Time Student";
                newUser11.Bio = "I am skilled with all aspects of computer networks. In my free time I enjoy windsurfing and flower arranging.";
                newUser11.Email = "u0000010@utah.edu";
                newUser11.EmploymentStatus = "Part Time";
                Users.Add(newUser11);
                StudentClass studentClass10 = new StudentClass();
                studentClass10.Class = newClass;
                studentClass10.Student = newUser11;
                StudentClasses.Add(studentClass10);

                StudentClass studentClass2_11 = new StudentClass();
                studentClass2_11.Class = newClass2;
                studentClass2_11.Student = newUser11;
                StudentClasses.Add(studentClass2_11);

                User newUser12 = new User();
                newUser12.Name = "Oliver Burch";
                newUser12.Interests = "Trail Building/Maintenance, Rock Collecting, Game Development";
                newUser12.StudentStatus = "Full Time Student";
                newUser12.Bio = "I am a skilled game developer. In my free time I like to maintain and build trails, collecting rocks along the way.";
                newUser12.Email = "u0000011@utah.edu";
                newUser12.EmploymentStatus = "Part Time";
                Users.Add(newUser12);

                StudentClass studentClass2_12 = new StudentClass();
                studentClass2_12.Class = newClass2;
                studentClass2_12.Student = newUser12;
                StudentClasses.Add(studentClass2_12);

                User newUser13 = new User();
                newUser13.Name = "Lily Galvan";
                newUser13.Interests = "Robotics, Oboe, Artificial Intelligence";
                newUser13.StudentStatus = "Full Time Student";
                newUser13.Bio = "I am a dedicated Oboe player who is interested in robotics in AI. One day I want to make a fully autonomous robotic oboe player.";
                newUser13.Email = "u0000012@utah.edu";
                newUser13.EmploymentStatus = "Part Time";
                Users.Add(newUser13);

                StudentClass studentClass2_13 = new StudentClass();
                studentClass2_13.Class = newClass2;
                studentClass2_13.Student = newUser13;
                StudentClasses.Add(studentClass2_13);

                User newUser14 = new User();
                newUser14.Name = "Barrett Mcclure";
                newUser14.Interests = "Beekeeping, Powerlifting, COBOL";
                newUser14.StudentStatus = "Full Time Student";
                newUser14.Bio = "I am a beekeeper who is currently studying COBOL. I am the only person I know who is learning COBOL, and I like to powerlift in my free time for exercise.";
                newUser14.Email = "u0000013@utah.edu";
                newUser14.EmploymentStatus = "Part Time";
                Users.Add(newUser14);

                StudentClass studentClass2_14 = new StudentClass();
                studentClass2_14.Class = newClass2;
                studentClass2_14.Student = newUser14;
                StudentClasses.Add(studentClass2_14);

                User newUser15 = new User();
                newUser15.Name = "Tracy Kramer";
                newUser15.Interests = "Model Cars, Fencing, CUDA";
                newUser15.StudentStatus = "Part Time Student";
                newUser15.Bio = "My focus in coding is on CUDA. In my free time, I enjoy fencing and collecting model cars.";
                newUser15.Email = "u0000014@utah.edu";
                newUser15.EmploymentStatus = "Part Time";
                Users.Add(newUser15);

                StudentClass studentClass2_15 = new StudentClass();
                studentClass2_15.Class = newClass2;
                studentClass2_15.Student = newUser15;
                StudentClasses.Add(studentClass2_15);

                User newUser16 = new User();
                newUser16.Name = "Ruthie Jones";
                newUser16.Interests = "Go-Kart Racing, Crocheting, Scientific Computing";
                newUser16.StudentStatus = "Part Time Student";
                newUser16.Bio = "I am primarily concerned with Scientific Computing. In my free time, I enjoy Go-Kart Racing and Crocheting";
                newUser16.Email = "u0000015@utah.edu";
                newUser16.EmploymentStatus = "Part Time";
                Users.Add(newUser16);

                StudentClass studentClass2_16 = new StudentClass();
                studentClass2_16.Class = newClass2;
                studentClass2_16.Student = newUser16;
                StudentClasses.Add(studentClass2_16);

                this.SaveChanges();

            }
        }
    }
}
