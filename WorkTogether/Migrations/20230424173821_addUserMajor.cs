using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WorkTogether.Migrations
{
    /// <inheritdoc />
    public partial class addUserMajor : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Major",
                table: "Users",
                type: "longtext",
                nullable: false);

            migrationBuilder.AlterColumn<string>(
                name: "Description",
                table: "Classes",
                type: "longtext",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "longtext");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Major",
                table: "Users");

            migrationBuilder.AlterColumn<string>(
                name: "Description",
                table: "Classes",
                type: "longtext",
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "longtext",
                oldNullable: true);
        }
    }
}
