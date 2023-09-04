import 'package:riverpod/riverpod.dart';

class InterestList extends Notifier<List<String>> {
  @override
  List<String> build() {
    return [];
  }

  void addInterest(String interestContent) {
    state = [...state, interestContent];
  }

  void removeInterest(int index) {
    state.removeAt(index);
    state = [...state];
  }
}

var interestListNotifierProvider =
    NotifierProvider<InterestList, List<String>>(InterestList.new);
