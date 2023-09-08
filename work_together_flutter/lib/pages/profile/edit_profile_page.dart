import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:work_together_flutter/global_components/tag.dart';
import 'package:work_together_flutter/provider/interest_list.dart';
import '../../global_components/custom_app_bar.dart';
import '../../http_request.dart';
import '../../models/user.dart';

enum StudentStatus { fullTime, partTime }

enum EmploymentStatus { employed, unemployed }

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final majorController = TextEditingController();
  final interestsController = TextEditingController();

  StudentStatus? _studentStatus;
  EmploymentStatus? _employmentStatus;

  @override
  void initState() {
    super.initState();
    _studentStatus =
        (widget.user.studentStatus.toString() == "Full Time Student")
            ? StudentStatus.fullTime
            : StudentStatus.partTime;
    _employmentStatus = (widget.user.employmentStatus.toString() == "Employed")
        ? EmploymentStatus.employed
        : EmploymentStatus.unemployed;
  }

  onInterestsSubmitted(interest) {
    widget.user.interests.add(interest.toString());
    ref.read(interestListNotifierProvider.notifier).addInterest(interest);
    interestsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    List<String> interestList = ref.watch(interestListNotifierProvider);
    nameController.text = widget.user.name;
    bioController.text = widget.user.bio;
    majorController.text = widget.user.major;

    interestList.addAll(widget.user.interests);

    return Scaffold(
      appBar: const CustomAppBar(title: "Edit Profile"),
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                  "Name:",
                  style: TextStyle(fontSize: 24, fontFamily: 'SourceSansPro'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
                child: TextFormField(
                  controller: nameController,
                  style: const TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SourceSansPro'),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.go,
                  onChanged: (name) {
                    widget.user.name = nameController.text;
                  },
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFFAFAFA),
                      hintText: "Type to change name.",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xFFD9D9D9), width: 2.0))),
                  maxLines: null,
                ),
              ),
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
                  textInputAction: TextInputAction.go,
                  onChanged: (bio) {
                    widget.user.bio = bioController.text;
                  },
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
                  textInputAction: TextInputAction.go,
                  onChanged: (major) {
                    widget.user.major = majorController.text;
                  },
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
                padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Radio(
                                value: StudentStatus.fullTime,
                                groupValue: _studentStatus,
                                onChanged: (StudentStatus? value) {
                                  setState(() {
                                    _studentStatus = value;
                                  });
                                  widget.user.studentStatus =
                                      "Full Time Student";
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  'Full Time Student',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'SourceSansPro'),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Radio(
                                value: StudentStatus.partTime,
                                groupValue: _studentStatus,
                                onChanged: (StudentStatus? value) {
                                  setState(() {
                                    _studentStatus = value;
                                  });
                                  widget.user.studentStatus =
                                      "Part Time Student";
                                },
                              ),
                              const Expanded(
                                  child: Text(
                                'Part Time Student',
                                style: TextStyle(
                                    fontSize: 14, fontFamily: 'SourceSansPro'),
                              ))
                            ],
                          ),
                        ),
                      ],
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
                padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Radio(
                                value: EmploymentStatus.employed,
                                groupValue: _employmentStatus,
                                onChanged: (EmploymentStatus? value) {
                                  setState(() {
                                    _employmentStatus = value;
                                  });
                                  widget.user.employmentStatus = "Employed";
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  'Employed',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'SourceSansPro'),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Radio(
                                value: EmploymentStatus.unemployed,
                                groupValue: _employmentStatus,
                                onChanged: (EmploymentStatus? value) {
                                  setState(() {
                                    _employmentStatus = value;
                                  });
                                  widget.user.employmentStatus = "Unemployed";
                                },
                              ),
                              const Expanded(
                                  child: Text(
                                'Unemployed',
                                style: TextStyle(
                                    fontSize: 14, fontFamily: 'SourceSansPro'),
                              ))
                            ],
                          ),
                        ),
                      ],
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
                child: TextFormField(
                  controller: interestsController,
                  style: const TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SourceSansPro'),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.go,
                  onFieldSubmitted: (interest) {
                    onInterestsSubmitted(interestsController.text);
                  },
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFFAFAFA),
                      hintText: "Type to Add an Interest",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xFFD9D9D9), width: 2.0))),
                  maxLines: null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 8.0),
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      onInterestsSubmitted(interestsController.text);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            "Add Interest",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    )),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 4.0),
                  child: Wrap(
                    children: [
                      ...widget.user.interests.map(
                        (e) {
                          if (e.toString() != "") {
                            return Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0, 4.0, 4.0, 0),
                              child: Wrap(
                                children: [
                                  Tag(text: e.toString()),
                                  GestureDetector(
                                    child:
                                        const Icon(Icons.remove_circle_outline),
                                    onTap: () {
                                      widget.user.interests
                                          .remove(e.toString());
                                      ref
                                          .read(interestListNotifierProvider
                                              .notifier)
                                          .removeInterest(
                                              interestList.indexOf(e));
                                    },
                                  )
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      )
                    ],
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
                        id: widget.user.id,
                        name: widget.user.name,
                        email: widget.user.email,
                        bio: widget.user.bio,
                        employmentStatus: widget.user.employmentStatus,
                        studentStatus: widget.user.studentStatus,
                        interests: widget.user.interests,
                        major: widget.user.major,
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
}
