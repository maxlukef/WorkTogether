import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class FilterChoices {
  Set<String> skillsSet;
  Set<String> interestsSet;
  // bool isOverlappingMeetingTime;
  RangeValues expectedHours;
  String expectedGrade;
  bool filterIsActive;

  FilterChoices(
      this.skillsSet,
      this.interestsSet,
      // this.isOverlappingMeetingTime,
      this.expectedHours,
      this.expectedGrade,
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

  // setIsOverlappingMeetingTime(bool isOverlappingMeetingTime) {
  //   this.isOverlappingMeetingTime = isOverlappingMeetingTime;
  // }

  setExpectedHours(RangeValues expectedHours) {
    this.expectedHours = expectedHours;
  }

  setExpectedGrade(String expectedGrade) {
    this.expectedGrade = expectedGrade;
  }

  setfilterIsActive(bool filterIsActive) {
    this.filterIsActive = filterIsActive;
  }

  resetFilterFields() {
    skillsSet = <String>{};
    interestsSet = <String>{};
    // isOverlappingMeetingTime = false;
    expectedHours = const RangeValues(0, 0);
    expectedGrade = "N/A";
    filterIsActive = false;
  }
}

class FilterChoicesNotifier extends Notifier<FilterChoices> {
  @override
  FilterChoices build() {
    Set<String> skillsSet = <String>{};
    Set<String> interestsSet = <String>{};
    // bool isOverlappingMeetingTime = false;
    RangeValues expectedHours = const RangeValues(0, 0);
    String expectedGrade = "N/A";
    bool filterIsActive = false;

    // return FilterChoices(skillsSet, interestsSet, isOverlappingMeetingTime,
    //     expectedHours, expectedGrade, filterIsActive);

    return FilterChoices(
        skillsSet, interestsSet, expectedHours, expectedGrade, filterIsActive);
  }
}

var filterChoicesNotifierProvider =
    NotifierProvider<FilterChoicesNotifier, FilterChoices>(
        FilterChoicesNotifier.new);
