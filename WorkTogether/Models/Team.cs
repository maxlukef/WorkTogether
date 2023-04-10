﻿using System.ComponentModel.DataAnnotations.Schema;

namespace WorkTogether.Models
{
    /// <summary>
    /// Model class for a team in work together
    /// </summary>
    public class Team
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public ICollection<User> Members { get; set; }

        /// <summary>
        /// Whether or not a team is complete - i.e. is it still in the team building phase (False), or has it moved onto the project stage (True)
        /// </summary>
        public bool Complete { get; set; }

        Project? Project { get; set; }
    }
}