import 'package:riverpod/riverpod.dart';

class TagList extends Notifier<List<String>> {
  @override
  List<String> build() {
    return [];
  }

  void addTag(String tagContent) {
    state = [...state, tagContent];
  }

  void removeTag(int index) {
    state.removeAt(index);
    state = [...state];
  }
}

var tagListNotifierProvider =
    NotifierProvider<TagList, List<String>>(TagList.new);
