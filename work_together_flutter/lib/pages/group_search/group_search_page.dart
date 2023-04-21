import 'package:flutter/material.dart';
import 'package:work_together_flutter/pages/group_search/components/student_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/widgets.dart';

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
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 10,
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          // return Tile(
          //   index: index,
          //   extent: (index % 5 + 1) * 100
          // );
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
      );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.index,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: Colors.blue,
      height: extent,
      child: Center(
        child: CircleAvatar(
          minRadius: 20,
          maxRadius: 20,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Text('$index', style: const TextStyle(fontSize: 20)),
        ),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}