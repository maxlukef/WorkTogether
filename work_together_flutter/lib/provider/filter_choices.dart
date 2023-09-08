import 'package:riverpod/riverpod.dart';

class FilterChoices {
  Set<String> skillsSet;
  Set<String> interestsSet;
  bool isOverlappingMeetingTime;
  String expectedHours;
  String studentStatus;
  String employmentStatus;

  FilterChoices(
      this.skillsSet,
      this.interestsSet,
      this.isOverlappingMeetingTime,
      this.expectedHours,
      this.studentStatus,
      this.employmentStatus);

  addToSkillsSet(String skill) {
    skillsSet.add(skill);
  }

  removeSkillFromSet(String skill) {
    skillsSet.remove(skill);
  }

  addToInterestsSet(String interest) {
    interestsSet.add(interest);
  }

  removeInterestFromSet(String interest) {
    interestsSet.remove(interest);
  }

  setIsOverlappingMeetingTime() {
    if (isOverlappingMeetingTime = false) {
      isOverlappingMeetingTime = true;
    } else {
      isOverlappingMeetingTime = false;
    }
  }

  setExpectedHours(String expectedHours) {
    this.expectedHours = expectedHours;
  }

  setStudentStatus(String studentStatus) {
    this.studentStatus = studentStatus;
  }

  setEmploymentStatus(String employmentStatus) {
    this.employmentStatus = employmentStatus;
  }
}

class FilterChoicesNotifier extends Notifier<FilterChoices> {
  @override
  FilterChoices build() {
    Set<String> skillsSet = <String>{};
    Set<String> interestsSet = <String>{};
    bool isOverlappingMeetingTime = false;
    String expectedHours = "";
    String studentStatus = "";
    String employmentStatus = "";

    return FilterChoices(skillsSet, interestsSet, isOverlappingMeetingTime,
        expectedHours, studentStatus, employmentStatus);
  }
}

var filterChoicesNotifierProvider =
    NotifierProvider<FilterChoicesNotifier, FilterChoices>(
        FilterChoicesNotifier.new);
