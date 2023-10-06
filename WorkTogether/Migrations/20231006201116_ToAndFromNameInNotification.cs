using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WorkTogether.Migrations
{
    /// <inheritdoc />
    public partial class ToAndFromNameInNotification : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "FromName",
                table: "Notification",
                type: "longtext",
                nullable: false);

            migrationBuilder.AddColumn<string>(
                name: "ToName",
                table: "Notification",
                type: "longtext",
                nullable: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "FromName",
                table: "Notification");

            migrationBuilder.DropColumn(
                name: "ToName",
                table: "Notification");
        }
    }
}
