import 'package:riverpod/riverpod.dart';

class FilterChoices {
  Set<String> skillsSet;
  Set<String> interestsSet;
  bool isOverlappingMeetingTime;
  String expectedHours;
  String studentStatus;
  String employmentStatus;
  bool filterIsActive;

  FilterChoices(
      this.skillsSet,
      this.interestsSet,
      this.isOverlappingMeetingTime,
      this.expectedHours,
      this.studentStatus,
      this.employmentStatus,
      this.filterIsActive);

  addToSkillsSet(String skill) {
    skillsSet.add(skill);
  }

  getSkillsSet() {
    return skillsSet;
  }

  getInterestsSet() {
    return interestsSet;
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

  setIsOverlappingMeetingTime(bool isOverlappingMeetingTime) {
    this.isOverlappingMeetingTime = isOverlappingMeetingTime;
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

  setfilterIsActive(bool filterIsActive) {
    this.filterIsActive = filterIsActive;
  }
}

class FilterChoicesNotifier extends Notifier<FilterChoices> {
  @override
  FilterChoices build() {
    Set<String> skillsSet = <String>{};
    Set<String> interestsSet = <String>{};
    bool isOverlappingMeetingTime = false;
    String expectedHours = "";
    String studentStatus = "N/A";
    String employmentStatus = "N/A";
    bool filterIsActive = false;

    return FilterChoices(skillsSet, interestsSet, isOverlappingMeetingTime,
        expectedHours, studentStatus, employmentStatus, filterIsActive);
  }
}

var filterChoicesNotifierProvider =
    NotifierProvider<FilterChoicesNotifier, FilterChoices>(
        FilterChoicesNotifier.new);
