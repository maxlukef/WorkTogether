﻿namespace WorkTogether.Models
{
    /// <summary>
    /// Model class for a Work Together project.
    /// </summary>
    public class Project
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public int ClassId { get; set; }
        public int MinTeamSize { get; set; }
        public int MaxTeamSize { get; set; }
        public DateTime Deadline { get; set; }
        public DateTime TeamFormationDeadline { get; set; }
        public Questionnaire? Questionnaire { get; set; }
    }

    public class ProjectDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public int ClassId { get; set; }
        public int MinTeamSize { get; set; }
        public int MaxTeamSize { get; set; }
        public DateTime Deadline { get; set; }
        public DateTime TeamFormationDeadline { get; set; }
        public int QuestionnaireId { get; set; }
    }

    public class CreateProjectDTO
    {
        public string Name { get; set; }
        public string Description { get; set; }
        public int ClassId { get; set; }
        public int MinTeamSize { get; set; }
        public int MaxTeamSize { get; set; }
        public DateTime Deadline { get; set; }
        public DateTime TeamFormationDeadline { get; set; }
    }

    public class EditProjectDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public string Description { get; set; }

        public int MinTeamSize { get; set; }

        public int MaxTeamSize { get; set; }

        public DateTime Deadline { get; set; }
        public DateTime TeamFormationDeadline { get; set; }
    }
}
