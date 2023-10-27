class Milestone {
  int id;
  int projectId;
  String title;
  String description;
  String deadline;
  int tasksCompleted;
  int totalTasks;
  bool completed;

  Milestone(this.id, this.projectId, this.title, this.description,
      this.deadline, this.tasksCompleted, this.totalTasks, this.completed);

  double percentOfTasksComplete() {
    if (totalTasks == 0) {
      return 0.0;
    }
    return tasksCompleted / totalTasks;
  }
}
