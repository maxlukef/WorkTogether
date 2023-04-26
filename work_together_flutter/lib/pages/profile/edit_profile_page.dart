import 'package:flutter/material.dart';
import 'package:work_together_flutter/global_components/tag.dart';
import '../../global_components/custom_app_bar.dart';
import '../../http_request.dart';
import '../../models/user.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({Key? key, required this.user}) : super(key: key);

  final User user;
  final bioController = TextEditingController();
  final majorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bioController.text = user.bio;
    majorController.text = user.major;
    return Scaffold(
      appBar: const CustomAppBar(title: "Edit Profile"),
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Text(
              user.name,
              style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'SourceSansPro',
                  fontWeight: FontWeight.bold),
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
                padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                child: Text(
                  "Bio:",
                  style: TextStyle(fontSize: 24, fontFamily: 'SourceSansPro'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                child: TextFormField(
                  controller: bioController,
                  style: const TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SourceSansPro'),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.next,
                  onSaved: (bio) {},
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFFAFAFA),
                      hintText: "Type to Add a Bio",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xFFD9D9D9), width: 2.0))),
                  maxLines: null,
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                child: Text(
                  "Major:",
                  style: TextStyle(fontSize: 24, fontFamily: 'SourceSansPro'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                child: TextFormField(
                  controller: majorController,
                  style: const TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SourceSansPro'),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.next,
                  onSaved: (bio) {},
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFFAFAFA),
                      hintText: "Type to Add a Major",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xFFD9D9D9), width: 2.0))),
                  maxLines: null,
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                child: Text(
                  "Student Status:",
                  style: TextStyle(fontSize: 24, fontFamily: 'SourceSansPro'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                child: Row(
                  children: [
                    Tag(
                      text: user.studentStatus,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                child: Text(
                  "Employment Status:",
                  style: TextStyle(fontSize: 24, fontFamily: 'SourceSansPro'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                child: Row(
                  children: [
                    Tag(
                      text: user.employmentStatus,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                child: Text(
                  "Interests:",
                  style: TextStyle(fontSize: 24, fontFamily: 'SourceSansPro'),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                  child: Row(
                    children: [..._interestList()],
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 32, 16),
                child: SizedBox(
                  height: 45,
                  width: 45,
                  child: FloatingActionButton(
                    onPressed: () {
                      User updatedUser = User(
                        id: user.id,
                        name: user.name,
                        email: user.email,
                        bio: bioController.text,
                        employmentStatus: user.employmentStatus,
                        studentStatus: user.studentStatus,
                        interests: user.interests,
                        major: majorController.text,
                      );
                      HttpService().putUser(updatedUser);
                      Navigator.pop(context, updatedUser);
                    },
                    child: const Icon(
                      Icons.check,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      )),
    );
  }

  _interestList() {
    List<Widget> interestsList = [];

    for (var i = 0; i < user.interests.length; i++) {
      interestsList.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: Tag(text: user.interests[i]),
        ),
      );
    }
    return interestsList;
  }
}
