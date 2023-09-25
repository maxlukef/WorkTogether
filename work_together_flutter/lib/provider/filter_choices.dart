import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class FilterChoices {
  Set<String> skillsSet;
  Set<String> interestsSet;
  RangeValues expectedHours;
  String expectedGrade;
  bool filterIsActive;

  FilterChoices(this.skillsSet, this.interestsSet, this.expectedHours,
      this.expectedGrade, this.filterIsActive);

  addToSkillsSet(String skill) {
    if (skill.trim() == "") {
      return;
    } else {
      skillsSet.add(skill);
    }
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
    if (interest.trim() == "") {
      return;
    } else {
      interestsSet.add(interest);
    }
  }

  removeInterestFromSet(String interest) {
    interestsSet.remove(interest);
  }

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
    RangeValues expectedHours = const RangeValues(0, 0);
    String expectedGrade = "N/A";
    bool filterIsActive = false;

    return FilterChoices(
        skillsSet, interestsSet, expectedHours, expectedGrade, filterIsActive);
  }
}

var filterChoicesNotifierProvider =
    NotifierProvider<FilterChoicesNotifier, FilterChoices>(
        FilterChoicesNotifier.new);
