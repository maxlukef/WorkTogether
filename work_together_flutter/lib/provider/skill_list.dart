import 'package:riverpod/riverpod.dart';

class SkillList extends Notifier<List<String>> {
  @override
  List<String> build() {
    return [];
  }

  void addSkill(String skillContent) {
    state = [...state, skillContent];
  }

  void removeSkill(int index) {
    state.removeAt(index);
    state = [...state];
  }
}

var skillListNotifierProvider =
    NotifierProvider<SkillList, List<String>>(SkillList.new);
