using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WorkTogether.Migrations
{
    /// <inheritdoc />
    public partial class invitecode : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "InviteCode",
                table: "Classes",
                type: "longtext",
                nullable: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "InviteCode",
                table: "Classes");
        }
    }
}
