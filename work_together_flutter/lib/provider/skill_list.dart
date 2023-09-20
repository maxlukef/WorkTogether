import 'package:riverpod/riverpod.dart';

class SkillList extends Notifier<List<String>> {
  @override
  List<String> build() {
    return [];
  }

  void addSkill(String skillContent) {
    if (skillContent.trim() == "") {
      return;
    } else {
      state = [...state, skillContent];
    }
  }

  void removeSkill(int index) {
    state.removeAt(index);
    state = [...state];
  }
}

var skillListNotifierProvider =
    NotifierProvider<SkillList, List<String>>(SkillList.new);
