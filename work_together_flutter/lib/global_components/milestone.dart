class Milestone {
  String name = "";
  String description = "";
  String deadline = "";
  int tasksCompleted = 0;
  int totalTasks = 0;

  Milestone(String milestoneName, String milestoneDescriptionData,
      String milestoneDeadline, int numCompleteTasks, int numTotalTasks) {
    name = milestoneName;
    description = milestoneDescriptionData;
    deadline = milestoneDeadline;
    tasksCompleted = numCompleteTasks;
    totalTasks = numTotalTasks;
  }
}
