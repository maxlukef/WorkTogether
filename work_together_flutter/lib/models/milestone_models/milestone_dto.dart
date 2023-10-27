class MilestoneDTO {
  int id;
  int projectId;
  String title;
  String description;
  DateTime deadline;

  MilestoneDTO(
      {required this.id,
      required this.projectId,
      required this.title,
      required this.description,
      required this.deadline});
}
