import 'package:flutter/material.dart';
import 'package:work_together_flutter/global_components/tag.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(8, 64, 8, 8),
          child: Text(
            "Profile Name",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
        const Icon(
          Icons.account_circle,
          color: Colors.blue,
          size: 110.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(32.0, 16.0, 16.0, 4.0),
              child: Text(
                "Bio:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(32.0, 0, 16.0, 0),
              child: Text(
                "As an avid outdoor enthusiast and a software developer, I have found a perfect balance between my two passions. During my free time, I love to explore new trails and go camping.",
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(32.0, 16.0, 16.0, 4.0),
              child: Text(
                "Major:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(32.0, 0, 16.0, 0),
              child: Text(
                "B.S. Computer Science",
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(32.0, 16.0, 16.0, 4.0),
              child: Text(
                "Student Status:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 0, 16.0, 0),
              child: Row(
                children: const [
                  Tag(
                    text: "Full Time Student",
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(32.0, 16.0, 16.0, 4.0),
              child: Text(
                "Employment Status:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 0, 16.0, 0),
              child: Row(
                children: const [
                  Tag(
                    text: "Unemployed",
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(32.0, 16.0, 16.0, 4.0),
              child: Text(
                "Interests:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 0, 16.0, 0),
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Tag(text: "Camping"),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Tag(
                        text: "Hiking",
                      ),
                    ),
                  ],
                )),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 32, 16),
              child: SizedBox(
                height: 45,
                width: 45,
                child: FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(
                    Icons.edit,
                  ),
                ),
              ),
            )
          ],
        )
      ],
    ));
  }
}
