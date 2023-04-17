import 'package:flutter/material.dart';
import 'package:work_together_flutter/pages/questionnaire/questionnaire.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
              child: Text(
                "Teams",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'SourceSansPro-SemiBold'),
              ),
            ),
            Center(
              child: Card(
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {},
                  child: SizedBox(
                    width: 330,
                    height: 65,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Padding(
                            padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0.0),
                            child: Text(
                              "CS-5530",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'SourceSansPro',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0.0),
                            child: Text(
                              "Task Force 141",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'SourceSansPro-SemiBold',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
              child: Text(
                "Group Search",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'SourceSansPro-SemiBold'),
              ),
            ),
            Center(
              child: Card(
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return const QuestionnairePage();
                      },
                    ));
                  },
                  child: SizedBox(
                    width: 330,
                    height: 65,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Padding(
                            padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0.0),
                            child: Text(
                              "CS-4400",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'SourceSansPro',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0.0),
                            child: Text(
                              "Computer Systems",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'SourceSansPro-SemiBold',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
