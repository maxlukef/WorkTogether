import 'package:flutter/material.dart';
import 'package:work_together_flutter/pages/group_search/components/student_card.dart';

class GroupSearchPage extends StatelessWidget {
  const GroupSearchPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Image profilePic = Image.asset('images/sample_profile.jpg');
    String studentName = "Alex Childs";
    String major = "Computer Science";
    List<String> availableMornings = ['Monday', 'Tuesday', 'Thursday'];
    List<String> availableAfternoons = ['Friday', 'Saturday'];
    List<String> availableEvenings = [];
    List<String> skills = ['Backend', 'Javascript', 'Python', 'Django'];
    String expectedGrade = "A";
    int weeklyHours = 10;
    List<String> interests = ['Climbing', 'Reading', 'Racquetball'];

    return SingleChildScrollView(
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 10, right: 10),
        mainAxisSpacing: 15,
        crossAxisSpacing: 10,
        children: List.generate(20, (index) {
          return StudentCard(
            profilePic: profilePic,
            fullName: studentName,
            major: major,
            availableMornings: availableMornings,
            availableAfternoons: availableAfternoons,
            availableEvenings: availableEvenings,
            skills: skills,
            expectedGrade: expectedGrade,
            weeklyHours: weeklyHours,
            interests: interests,
          );
        }),
      )
    );
  }
}