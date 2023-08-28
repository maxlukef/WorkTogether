using Microsoft.AspNetCore.Hosting.Server;
using Microsoft.EntityFrameworkCore;
using MySql.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using static System.Net.Mime.MediaTypeNames;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;

namespace WorkTogether.Models
{
    public class WT_DBContext : IdentityDbContext<User>
    {
        public WT_DBContext(DbContextOptions<WT_DBContext> options)
            : base(options)
        {
        }

        protected readonly IConfiguration Configuration;
        protected override void OnConfiguring(DbContextOptionsBuilder options)
        {
            base.OnConfiguring(options);
        }

        protected override void OnModelCreating(ModelBuilder modelbuilder)
        {
            base.OnModelCreating(modelbuilder);
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
                newUser2.UserId = 1;
                newUser2.Interests = "Cinema,Skiing,Programming";
                newUser2.StudentStatus = "Professor";
                newUser2.Bio = "As a capstone professor and film critic, I spend my days assisting students in learning programming and my evenings watching movies.";
                newUser2.Major = "Computer Science";
                newUser2.Email = "u0000001@utah.edu";
                newUser2.EmploymentStatus = "Full Time";
                newUser2.Major = "Computer Science";
                
                Users.Add(newUser2);

                Class newClass = new Class();
                newClass.Name = "CS 2420: Data Structures and Algs";
                newClass.Description = "The weed-out class.";
                newClass.Professor = newUser2;
                Classes.Add(newClass);

                Project newProject = new Project();
                newProject.Deadline = new DateTime(2023, 5, 5);
                newProject.Name = "Implement a hash map";
                newProject.Description = "Implement a hashmap in Java. This will take some time, so make sure you start early!";
                newProject.MaxTeamSize = 3;
                newProject.MinTeamSize = 1;
                newProject.Class = newClass;
                Projects.Add(newProject);

                Class newClass2 = new Class();
                newClass2.Name = "CS 4000: Capstone Design";
                newClass2.Description = "The first phase of the capstone project.";
                newClass2.Professor = newUser2;
                Classes.Add(newClass2);

                Project newProject2 = new Project();
                newProject2.Deadline = new DateTime(2023, 4, 26);
                newProject2.Name = "Create a prototype of your project";
                newProject2.Description = "Prepare for the prototype demo day on 4/26!";
                newProject2.MaxTeamSize = 4;
                newProject2.MinTeamSize = 4;
                newProject2.Class = newClass2;
                Projects.Add(newProject2 );



                User newUser = new User();
                newUser.Name = "John Coder";
                newUser.Interests = "Hiking,Biking,Coding";
                newUser.StudentStatus = "Full Time Student";
                newUser.Bio = "As an avid outdoor enthusiast and software developer, I have found a perfect balance between my two passions. In my free time, I love to explore new trails and go camping.";
                newUser.Major = "Computer Science";
                newUser.Email = "u0000000@utah.edu";
                newUser.EmploymentStatus = "Unemployed";
                newUser.Major = "Computer Science";
                newUser.UserId = 0;
                Users.Add(newUser);

                StudentClass studentClass1 = new StudentClass();
                studentClass1.Class = newClass;
                studentClass1.Student = newUser;
                StudentClasses.Add(studentClass1);

                User newUser3 = new User();
                newUser3.Name = "Jim Roberts";
                newUser3.Interests = "Fishing, Cartography";
                newUser3.StudentStatus = "Full Time Student";
                newUser3.Bio = "As a fishing cartographer, I am concerned with the mapping of fishing spots";
                newUser3.Major = "Computer Science";
                newUser3.Email = "u0000002@utah.edu";
                newUser3.EmploymentStatus = "Unemployed";
                newUser3.Major = "Computer Science";
                newUser3.UserId = 2;
                Users.Add(newUser3);


                StudentClass studentClass2 = new StudentClass();
                studentClass2.Class = newClass;
                studentClass2.Student = newUser3;
                StudentClasses.Add(studentClass2);

                User newUser4 = new User();
                newUser4.Name = "Sebastion Carson";
                newUser4.Interests = "Barbecue, Butterfly Watching, Flutter";
                newUser4.StudentStatus = "Part Time Student";
                newUser4.Bio = "As an avid butterfly watcher, I am very good at writing Flutter frontends. I also smoke a mean brisket.";
                newUser4.Major = "Computer Science";
                newUser4.Email = "u0000003@utah.edu";
                newUser4.EmploymentStatus = "Part Time";
                newUser4.Major = "Computer Science";
                newUser4.UserId = 3;
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
                newUser5.Major = "Computer Science";
                newUser5.Email = "u0000004@utah.edu";
                newUser5.EmploymentStatus = "Part Time";
                newUser5.Major = "Computer Science";
                newUser5.UserId = 4;
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
                newUser6.Major = "Computer Science";
                newUser6.Email = "u0000005@utah.edu";
                newUser6.EmploymentStatus = "Unemployed";
                newUser6.Major = "Computer Science";
                newUser6.UserId = 5;
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
                newUser7.Major = "Computer Science";
                newUser7.Email = "u0000006@utah.edu";
                newUser7.EmploymentStatus = "Unemployed";
                newUser7.Major = "Computer Science";
                newUser7.UserId = 6;
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
                newUser8.Major = "Computer Science";
                newUser8.Email = "u0000007@utah.edu";
                newUser8.EmploymentStatus = "Unemployed";
                newUser8.Major = "Computer Science";
                newUser8.UserId = 7;
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
                newUser9.Major = "Computer Science";
                newUser9.Email = "u0000008@utah.edu";
                newUser9.EmploymentStatus = "Unemployed";
                newUser9.Major = "Computer Science";
                newUser9.UserId = 8;
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
                newUser10.Major = "Computer Science";
                newUser10.Email = "u0000009@utah.edu";
                newUser10.EmploymentStatus = "Part Time";
                newUser10.Major = "Computer Science";
                newUser10.UserId = 9;
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
                newUser11.Major = "Computer Science";
                newUser11.Email = "u0000010@utah.edu";
                newUser11.EmploymentStatus = "Part Time";
                newUser11.Major = "Computer Science";
                newUser11.UserId = 10;
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
                newUser12.Major = "Computer Science";
                newUser12.Email = "u0000011@utah.edu";
                newUser12.EmploymentStatus = "Part Time";
                newUser12.Major = "Computer Science";
                newUser12.UserId = 11;
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
                newUser13.Major = "Computer Science";
                newUser13.Email = "u0000012@utah.edu";
                newUser13.EmploymentStatus = "Part Time";
                newUser13.Major = "Computer Science";
                newUser13.UserId = 12;
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
                newUser14.Major = "Computer Science";
                newUser14.Email = "u0000013@utah.edu";
                newUser14.EmploymentStatus = "Part Time";
                newUser14.Major = "Computer Science";
                newUser14.UserId = 13;
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
                newUser15.Major = "Computer Science";
                newUser15.Email = "u0000014@utah.edu";
                newUser15.EmploymentStatus = "Part Time";
                newUser15.Major = "Computer Science";
                newUser15.UserId = 14;
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
                newUser16.Major = "Computer Science";
                newUser16.Email = "u0000015@utah.edu";
                newUser16.EmploymentStatus = "Part Time";
                newUser16.Major = "Computer Science";
                newUser16.UserId = 15;
                Users.Add(newUser16);

                StudentClass studentClass2_16 = new StudentClass();
                studentClass2_16.Class = newClass2;
                studentClass2_16.Student = newUser16;
                StudentClasses.Add(studentClass2_16);

                this.SaveChanges();

                Project project1 = new Project();
                project1.Class = newClass;
                project1.Description = "Capstone Project";
                project1.Name = "Capstone";
                project1.MinTeamSize = 4;
                project1.MaxTeamSize = 5;
                project1.Deadline = new DateTime(2023, 5, 30);
                Projects.Add(project1);
                this.SaveChanges();

                Questionnaire default_questionnaire = new Questionnaire();
                default_questionnaire.Project = project1;
                default_questionnaire.ProjectID = project1.Id;
                Questionnaires.Add(default_questionnaire);

                this.SaveChanges();

                Question q1 = new Question();
                q1.Questionnaire = default_questionnaire;
                q1.Prompt = "Add Available Times";
                q1.Type = "Time";
                Questions.Add(q1);

                this.SaveChanges();

                Question q2 = new Question();
                q2.Questionnaire = default_questionnaire;
                q2.Prompt = "Expected Project Quality";
                q2.Type = "Select";
                Questions.Add(q2); 

                this.SaveChanges();

                Question q3 = new Question();
                q3.Questionnaire = default_questionnaire;
                q3.Prompt = "Relevant Skills";
                q3.Type = "Tag";
                Questions.Add(q3);

                this.SaveChanges();

                Question q4 = new Question();
                q4.Questionnaire = default_questionnaire;
                q4.Prompt = "Expected Hours Weekly";
                q4.Type = "Number";
                Questions.Add(q4);

                this.SaveChanges();

                Question q5 = new Question();
                q5.Questionnaire = default_questionnaire;
                q5.Prompt = "Additional Notes";
                q5.Type = "Text";
                Questions.Add(q5);

                this.SaveChanges();

                Answer u1q1 = new Answer();
                u1q1.Answerer = newUser;
                u1q1.AnswerStr = "Morning:M,W,F`Afternoon:T,Th";
                u1q1.Question = q1;
                Answers.Add(u1q1);

                Answer u1q2 = new Answer();
                u1q2.Answerer = newUser;
                u1q2.AnswerStr = "A";
                u1q2.Question = q2;
                Answers.Add(u1q2);

                Answer u1q3 = new Answer();
                u1q3.Answerer = newUser;
                u1q3.AnswerStr = "Python,Django,Backend,Databases";
                u1q3.Question = q3;
                Answers.Add(u1q3);

                Answer u1q4 = new Answer();
                u1q4.Answerer = newUser;
                u1q4.AnswerStr = "10";
                u1q4.Question = q4;
                Answers.Add(u1q4);

                Answer u1q5 = new Answer();
                u1q5.Answerer = newUser;
                u1q5.AnswerStr = "NA";
                u1q5.Question = q5;
                Answers.Add(u1q5);

                this.SaveChanges();

                Answer u2q1 = new Answer();
                u2q1.Answerer = newUser2;
                u2q1.AnswerStr = "Afternoon:T,Th`Evening:Sa,Su";
                u2q1.Question = q1;
                Answers.Add(u2q1);

                Answer u2q2 = new Answer();
                u2q2.Answerer = newUser2;
                u2q2.AnswerStr = "A";
                u2q2.Question = q2;
                Answers.Add(u2q2);

                Answer u2q3 = new Answer();
                u2q3.Answerer = newUser2;
                u2q3.AnswerStr = "C#,Full Stack Development,Entity Framework";
                u2q3.Question = q3;
                Answers.Add(u2q3);

                Answer u2q4 = new Answer();
                u2q4.Answerer = newUser2;
                u2q4.AnswerStr = "8";
                u2q4.Question = q4;
                Answers.Add(u2q4);

                Answer u2q5 = new Answer();
                u2q5.Answerer = newUser2;
                u2q5.AnswerStr = "NA";
                u2q5.Question = q5;
                Answers.Add(u2q5);

                this.SaveChanges();

                Answer u3q1 = new Answer();
                u3q1.Answerer = newUser3;
                u3q1.AnswerStr = "Morning:M,Tu,W,Th,F";
                u3q1.Question = q1;
                Answers.Add(u3q1);

                Answer u3q2 = new Answer();
                u3q2.Answerer = newUser3;
                u3q2.AnswerStr = "A";
                u3q2.Question = q2;
                Answers.Add(u3q2);

                Answer u3q3 = new Answer();
                u3q3.Answerer = newUser3;
                u3q3.AnswerStr = "Databases,App Development";
                u3q3.Question = q3;
                Answers.Add(u3q3);

                Answer u3q4 = new Answer();
                u3q4.Answerer = newUser3;
                u3q4.AnswerStr = "11";
                u3q4.Question = q4;
                Answers.Add(u3q4);

                Answer u3q5 = new Answer();
                u3q5.Answerer = newUser3;
                u3q5.AnswerStr = "NA";
                u3q5.Question = q5;
                Answers.Add(u3q5);

                this.SaveChanges();

                Answer u4q1 = new Answer();
                u4q1.Answerer = newUser4;
                u4q1.AnswerStr = "Morning:M,Tu`Evening:F,Sa";
                u4q1.Question = q1;
                Answers.Add(u4q1);

                Answer u4q2 = new Answer();
                u4q2.Answerer = newUser4;
                u4q2.AnswerStr = "B";
                u4q2.Question = q2;
                Answers.Add(u4q2);

                Answer u4q3 = new Answer();
                u4q3.Answerer = newUser4;
                u4q3.AnswerStr = "Python,Java,MySQL";
                u4q3.Question = q3;
                Answers.Add(u4q3);

                Answer u4q4 = new Answer();
                u4q4.Answerer = newUser4;
                u4q4.AnswerStr = "5";
                u4q4.Question = q4;
                Answers.Add(u4q4);

                Answer u4q5 = new Answer();
                u4q5.Answerer = newUser4;
                u4q5.AnswerStr = "NA";
                u4q5.Question = q5;
                Answers.Add(u4q5);

                this.SaveChanges();

                Answer u5q1 = new Answer();
                u5q1.Answerer = newUser5;
                u5q1.AnswerStr = "Morning:M,Th`Afternoon:F,Sa,Su`Evening:F,Sa,Su";
                u5q1.Question = q1;
                Answers.Add(u5q1);

                Answer u5q2 = new Answer();
                u5q2.Answerer = newUser5;
                u5q2.AnswerStr = "A";
                u5q2.Question = q2;
                Answers.Add(u5q2);

                Answer u5q3 = new Answer();
                u5q3.Answerer = newUser5;
                u5q3.AnswerStr = "Front End Development,Javascript,Design";
                u5q3.Question = q3;
                Answers.Add(u5q3);

                Answer u5q4 = new Answer();
                u5q4.Answerer = newUser5;
                u5q4.AnswerStr = "7";
                u5q4.Question = q4;
                Answers.Add(u5q4);

                Answer u5q5 = new Answer();
                u5q5.Answerer = newUser5;
                u5q5.AnswerStr = "NA";
                u5q5.Question = q5;
                Answers.Add(u5q5);

                this.SaveChanges();

                Answer u6q1 = new Answer();
                u6q1.Answerer = newUser6;
                u6q1.AnswerStr = "Morning:M,Tu,W,Th,F`Afternoon:M,W,F`Evening:Th";
                u6q1.Question = q1;
                Answers.Add(u6q1);

                Answer u6q2 = new Answer();
                u6q2.Answerer = newUser6;
                u6q2.AnswerStr = "A";
                u6q2.Question = q2;
                Answers.Add(u6q2);

                Answer u6q3 = new Answer();
                u6q3.Answerer = newUser6;
                u6q3.AnswerStr = "Databases,Javascript,Python,C#,Automation";
                u6q3.Question = q3;
                Answers.Add(u6q3);

                Answer u6q4 = new Answer();
                u6q4.Answerer = newUser6;
                u6q4.AnswerStr = "15";
                u6q4.Question = q4;
                Answers.Add(u6q4);

                Answer u6q5 = new Answer();
                u6q5.Answerer = newUser6;
                u6q5.AnswerStr = "NA";
                u6q5.Question = q5;
                Answers.Add(u6q5);

                this.SaveChanges();

                Answer u7q1 = new Answer();
                u7q1.Answerer = newUser7;
                u7q1.AnswerStr = "Morning:M,Tu,Th,F`Evening:Tu,F,Su";
                u7q1.Question = q1;
                Answers.Add(u7q1);

                Answer u7q2 = new Answer();
                u7q2.Answerer = newUser7;
                u7q2.AnswerStr = "A";
                u7q2.Question = q2;
                Answers.Add(u7q2);

                Answer u7q3 = new Answer();
                u7q3.Answerer = newUser7;
                u7q3.AnswerStr = "Design,App Development";
                u7q3.Question = q3;
                Answers.Add(u7q3);

                Answer u7q4 = new Answer();
                u7q4.Answerer = newUser7;
                u7q4.AnswerStr = "10";
                u7q4.Question = q4;
                Answers.Add(u7q4);

                Answer u7q5 = new Answer();
                u7q5.Answerer = newUser7;
                u7q5.AnswerStr = "NA";
                u7q5.Question = q5;
                Answers.Add(u7q5);

                this.SaveChanges();

                Answer u8q1 = new Answer();
                u8q1.Answerer = newUser8;
                u8q1.AnswerStr = "Evening:M,Tu,W,Th,F,Sa,Su";
                u8q1.Question = q1;
                Answers.Add(u8q1);

                Answer u8q2 = new Answer();
                u8q2.Answerer = newUser8;
                u8q2.AnswerStr = "B";
                u8q2.Question = q2;
                Answers.Add(u8q2);

                Answer u8q3 = new Answer();
                u8q3.Answerer = newUser8;
                u8q3.AnswerStr = "Databases,App Development";
                u8q3.Question = q3;
                Answers.Add(u8q3);

                Answer u8q4 = new Answer();
                u8q4.Answerer = newUser8;
                u8q4.AnswerStr = "8";
                u8q4.Question = q4;
                Answers.Add(u8q4);

                Answer u8q5 = new Answer();
                u8q5.Answerer = newUser8;
                u8q5.AnswerStr = "NA";
                u8q5.Question = q5;
                Answers.Add(u8q5);

                this.SaveChanges();

                Answer u9q1 = new Answer();
                u9q1.Answerer = newUser9;
                u9q1.AnswerStr = "Morning:M,W,F`Afternoon:Tu,Th";
                u9q1.Question = q1;
                Answers.Add(u9q1);

                Answer u9q2 = new Answer();
                u9q2.Answerer = newUser9;
                u9q2.AnswerStr = "A";
                u9q2.Question = q2;
                Answers.Add(u9q2);

                Answer u9q3 = new Answer();
                u9q3.Answerer = newUser9;
                u9q3.AnswerStr = "Ruby,Cold Fusion,Backend Development,MySQL,MariaDB";
                u9q3.Question = q3;
                Answers.Add(u9q3);

                Answer u9q4 = new Answer();
                u9q4.Answerer = newUser9;
                u9q4.AnswerStr = "6";
                u9q4.Question = q4;
                Answers.Add(u9q4);

                Answer u9q5 = new Answer();
                u9q5.Answerer = newUser9;
                u9q5.AnswerStr = "NA";
                u9q5.Question = q5;
                Answers.Add(u9q5);

                this.SaveChanges();

                Answer u10q1 = new Answer();
                u10q1.Answerer = newUser10;
                u10q1.AnswerStr = "Afternoon:M,Tu,W,Thu";
                u10q1.Question = q1;
                Answers.Add(u10q1);

                Answer u10q2 = new Answer();
                u10q2.Answerer = newUser10;
                u10q2.AnswerStr = "B";
                u10q2.Question = q2;
                Answers.Add(u10q2);

                Answer u10q3 = new Answer();
                u10q3.Answerer = newUser10;
                u10q3.AnswerStr = "Python";
                u10q3.Question = q3;
                Answers.Add(u10q3);

                Answer u10q4 = new Answer();
                u10q4.Answerer = newUser10;
                u10q4.AnswerStr = "8";
                u10q4.Question = q4;
                Answers.Add(u10q4);

                Answer u10q5 = new Answer();
                u10q5.Answerer = newUser10;
                u10q5.AnswerStr = "NA";
                u10q5.Question = q5;
                Answers.Add(u10q5);

                this.SaveChanges();

                Answer u11q1 = new Answer();
                u11q1.Answerer = newUser11;
                u11q1.AnswerStr = "Afternoon:W,F";
                u11q1.Question = q1;
                Answers.Add(u11q1);

                Answer u11q2 = new Answer();
                u11q2.Answerer = newUser11;
                u11q2.AnswerStr = "C";
                u11q2.Question = q2;
                Answers.Add(u11q2);

                Answer u11q3 = new Answer();
                u11q3.Answerer = newUser11;
                u11q3.AnswerStr = "Frontend Development,Javascript";
                u11q3.Question = q3;
                Answers.Add(u11q3);

                Answer u11q4 = new Answer();
                u11q4.Answerer = newUser11;
                u11q4.AnswerStr = "4";
                u11q4.Question = q4;
                Answers.Add(u11q4);

                Answer u11q5 = new Answer();
                u11q5.Answerer = newUser11;
                u11q5.AnswerStr = "NA";
                u11q5.Question = q5;
                Answers.Add(u11q5);

                this.SaveChanges();

                Answer u12q1 = new Answer();
                u12q1.Answerer = newUser12;
                u12q1.AnswerStr = "Morning:M,Tu,Sa`Afternoon:M,We`Evening:Tu,Th,F,Sa";
                u12q1.Question = q1;
                Answers.Add(u12q1);

                Answer u12q2 = new Answer();
                u12q2.Answerer = newUser12;
                u12q2.AnswerStr = "A";
                u12q2.Question = q2;
                Answers.Add(u12q2);

                Answer u12q3 = new Answer();
                u12q3.Answerer = newUser12;
                u12q3.AnswerStr = "C#,Entity Framework,Flutter";
                u12q3.Question = q3;
                Answers.Add(u12q3);

                Answer u12q4 = new Answer();
                u12q4.Answerer = newUser12;
                u12q4.AnswerStr = "18";
                u12q4.Question = q4;
                Answers.Add(u12q4);

                Answer u12q5 = new Answer();
                u12q5.Answerer = newUser12;
                u12q5.AnswerStr = "NA";
                u12q5.Question = q5;
                Answers.Add(u12q5);

                this.SaveChanges();

                Answer u13q1 = new Answer();
                u13q1.Answerer = newUser13;
                u13q1.AnswerStr = "Morning:M,F,Sa`Evening:Th,F,Sa,Su";
                u13q1.Question = q1;
                Answers.Add(u13q1);

                Answer u13q2 = new Answer();
                u13q2.Answerer = newUser13;
                u13q2.AnswerStr = "A";
                u13q2.Question = q2;
                Answers.Add(u13q2);

                Answer u13q3 = new Answer();
                u13q3.Answerer = newUser13;
                u13q3.AnswerStr = "Frontent Development,Flutter,Javascript,REST APIs,Design";
                u13q3.Question = q3;
                Answers.Add(u13q3);

                Answer u13q4 = new Answer();
                u13q4.Answerer = newUser13;
                u13q4.AnswerStr = "11";
                u13q4.Question = q4;
                Answers.Add(u13q4);

                Answer u13q5 = new Answer();
                u13q5.Answerer = newUser13;
                u13q5.AnswerStr = "NA";
                u13q5.Question = q5;
                Answers.Add(u13q5);

                this.SaveChanges();

                Answer u14q1 = new Answer();
                u14q1.Answerer = newUser14;
                u14q1.AnswerStr = "Morning:M`Afternoon:Th`Evening:Sa,Su";
                u14q1.Question = q1;
                Answers.Add(u14q1);

                Answer u14q2 = new Answer();
                u14q2.Answerer = newUser14;
                u14q2.AnswerStr = "B";
                u14q2.Question = q2;
                Answers.Add(u14q2);

                Answer u14q3 = new Answer();
                u14q3.Answerer = newUser14;
                u14q3.AnswerStr = "Ruby,Java,Python";
                u14q3.Question = q3;
                Answers.Add(u14q3);

                Answer u14q4 = new Answer();
                u14q4.Answerer = newUser14;
                u14q4.AnswerStr = "6";
                u14q4.Question = q4;
                Answers.Add(u14q4);

                Answer u14q5 = new Answer();
                u14q5.Answerer = newUser14;
                u14q5.AnswerStr = "NA";
                u14q5.Question = q5;
                Answers.Add(u14q5);

                this.SaveChanges();

                Answer u15q1 = new Answer();
                u15q1.Answerer = newUser15;
                u15q1.AnswerStr = "Evening:M,W,F,Sa";
                u15q1.Question = q1;
                Answers.Add(u15q1);

                Answer u15q2 = new Answer();
                u15q2.Answerer = newUser15;
                u15q2.AnswerStr = "A";
                u15q2.Question = q2;
                Answers.Add(u15q2);

                Answer u15q3 = new Answer();
                u15q3.Answerer = newUser15;
                u15q3.AnswerStr = "Flutter,Javascript,React Native";
                u15q3.Question = q3;
                Answers.Add(u15q3);

                Answer u15q4 = new Answer();
                u15q4.Answerer = newUser15;
                u15q4.AnswerStr = "8";
                u15q4.Question = q4;
                Answers.Add(u15q4);

                Answer u15q5 = new Answer();
                u15q5.Answerer = newUser15;
                u15q5.AnswerStr = "NA";
                u15q5.Question = q5;
                Answers.Add(u15q5);

                this.SaveChanges();

                Answer u16q1 = new Answer();
                u16q1.Answerer = newUser16;
                u16q1.AnswerStr = "Morning:M,Tu,W,Th,F`Afternoon:Tu,Th`Evening:F,Sa";
                u16q1.Question = q1;
                Answers.Add(u16q1);

                Answer u16q2 = new Answer();
                u16q2.Answerer = newUser16;
                u16q2.AnswerStr = "A";
                u16q2.Question = q2;
                Answers.Add(u16q2);

                Answer u16q3 = new Answer();
                u16q3.Answerer = newUser16;
                u16q3.AnswerStr = "Backend Development,Databases,C#,Python,Django";
                u16q3.Question = q3;
                Answers.Add(u16q3);

                Answer u16q4 = new Answer();
                u16q4.Answerer = newUser16;
                u16q4.AnswerStr = "13";
                u16q4.Question = q4;
                Answers.Add(u16q4);

                Answer u16q5 = new Answer();
                u16q5.Answerer = newUser16;
                u16q5.AnswerStr = "NA";
                u16q5.Question = q5;
                Answers.Add(u16q5);

                this.SaveChanges();
            }
        }
    }
}
