using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WorkTogether.Models
{
    public class Response
    {
        public string? Status { get; set; }
        public string? Message { get; set; }
    }
}
