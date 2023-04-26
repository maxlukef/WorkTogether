class CardInfo {
  final int id;
  final String name;
  final String major;
  final List<String> availableMornings;
  final List<String> availableAfternoons;
  final List<String> availableEvenings;
  final List<String> skills;
  final List<String> interests;
  final String expectedGrade;
  final String weeklyHours;

  CardInfo(
      {
        required this.id,
        required this.name,
        required this.major,
        required this.availableMornings,
        required this.availableAfternoons,
        required this.availableEvenings,
        required this.skills,
        required this.interests,
        required this.expectedGrade,
        required this.weeklyHours});
}