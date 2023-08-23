class Task {
  String name = "";
  String description = "";
  String assignedUser = "";
  String dueDate = "";

  Task(String taskName, String taskDescritpionData, String taskDueDate,
      String assignedUserData) {
    description = taskDescritpionData;
    assignedUser = assignedUserData;
    dueDate = taskDueDate;
    name = taskName;
  }
}
