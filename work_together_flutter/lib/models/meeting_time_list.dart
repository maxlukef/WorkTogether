import 'package:riverpod/riverpod.dart';

class MeetingTime {
  String timeOfDay;
  List<String> daysOfWeek;
  String note;

  MeetingTime(this.timeOfDay, this.daysOfWeek, this.note);

  setTimeOfDay(String timeOfDay) {
    this.timeOfDay = timeOfDay;
  }

  setNote(String note) {
    this.note = note;
  }

  addDayOfWeek(String day) {
    daysOfWeek.add(day);
  }

  removeDayOfWeek(String day) {
    daysOfWeek.remove(day);
  }
}

class MeetingTimeList extends Notifier<List<MeetingTime>> {
  @override
  List<MeetingTime> build() {
    return [];
  }

  void addMeetingTime(MeetingTime meetingTime) {
    state = [...state, meetingTime];
  }

  void removeMeetingTime(int index) {
    state.removeAt(index);
    state = [...state];
  }
}

var meetingTimeListNotifierProvider =
    NotifierProvider<MeetingTimeList, List<MeetingTime>>(MeetingTimeList.new);
