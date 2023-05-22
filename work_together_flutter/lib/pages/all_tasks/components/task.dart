class Task {
  String taskText = "";
  String assignedUser = "";
  String dueDate = "";

  Task(String taskTextData, String taskDueDate, String assignedUserData) {
    taskText = taskTextData;
    assignedUser = assignedUserData;
    dueDate = taskDueDate;
  }
}
