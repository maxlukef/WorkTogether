import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {

  StudentCard(
      {
        required this.profilePic,
        required this.fullName,
        required this.major,
        required this.availableMornings,
        required this.availableAfternoons,
        required this.availableEvenings,
        required this.skills,
        required this.expectedGrade,
        required this.weeklyHours,
        required this.interests,
      }
  );

  String text = "this is some cool text";
  final String fullName;
  String major;
  List<String> availableMornings;
  List<String> availableAfternoons;
  List<String> availableEvenings;
  List<String> skills;
  String expectedGrade;
  int weeklyHours;
  List<String> interests;
  Image profilePic;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10,
        color: const Color(0xFFf2f2f2),
        //margin: const EdgeInsets.all(10),
         child: Padding(
           padding: EdgeInsets.all(10),
           child:Column(children: [
             Row(
                 children: [
                   Container(
                       height: 40,
                       width: 40,
                       decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           image: DecorationImage(
                               image: profilePic!.image
                           )
                       )
                   ),
                   Text(fullName)

                 ]),
             Divider(
               color: Colors.black
             ),
             Align(alignment: Alignment.centerLeft, child: Text("Availability")),
             Card(
               elevation: 5,
               color: const Color(0xFFf2f2f2),
               child: Padding(
                 padding: EdgeInsets.all(5),
                 child: Row(

                   children: [
                       Align(
                         alignment: Alignment.centerLeft,
                         child:Container(
                             height: 13,
                             width: 13,
                             decoration: BoxDecoration(
                               shape: BoxShape.circle,
                               color: Color(0xFF11dc5c),
                             )
                         ),
                       ),
                       Expanded(
                         child: Align(
                           alignment: Alignment.centerRight,
                           child: Padding(
                               padding: EdgeInsets.all(1),
                               child: Container(
                                   height: 13,
                                   width: 13,
                                   decoration: BoxDecoration(
                                     shape: BoxShape.circle,
                                     color: Color(0xFF11dc5c),
                                   )
                               )),
                         ),
                       ),
                     Align(
                         alignment: Alignment.centerRight,
                         child: Padding(
                           padding: EdgeInsets.all(1),
                           child: Container(
                               height: 13,
                               width: 13,
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 color: Color(0xFF11dc5c),
                               )
                           )),
                         ),
                     Align(
                       alignment: Alignment.centerRight,
                       child: Padding(
                           padding: EdgeInsets.all(1),
                           child: Container(
                               height: 13,
                               width: 13,
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 color: Color(0xFF11dc5c),
                               )
                           )),
                     ),
                     Align(
                       alignment: Alignment.centerRight,
                       child: Padding(
                           padding: EdgeInsets.all(1),
                           child: Container(
                               height: 13,
                               width: 13,
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 color: Color(0xFF11dc5c),
                               )
                           )),
                     ),
                 ]
                 )
               )
             ),
             Card(
                 elevation: 5,
                 color: const Color(0xFFf2f2f2),
                 child: Padding(
                     padding: EdgeInsets.all(5),
                     child: Row(

                         children: [
                           Align(
                             alignment: Alignment.centerLeft,
                             child:Container(
                                 height: 13,
                                 width: 13,
                                 decoration: BoxDecoration(
                                   shape: BoxShape.circle,
                                   color: Color(0xFF11dc5c),
                                 )
                             ),
                           ),
                           Expanded(
                             child: Align(
                               alignment: Alignment.centerRight,
                               child: Padding(
                                   padding: EdgeInsets.all(1),
                                   child: Container(
                                       height: 13,
                                       width: 13,
                                       decoration: BoxDecoration(
                                         shape: BoxShape.circle,
                                         color: Color(0xFF11dc5c),
                                       )
                                   )),
                             ),
                           ),
                           Align(
                             alignment: Alignment.centerRight,
                             child: Padding(
                                 padding: EdgeInsets.all(1),
                                 child: Container(
                                     height: 13,
                                     width: 13,
                                     decoration: BoxDecoration(
                                       shape: BoxShape.circle,
                                       color: Color(0xFF11dc5c),
                                     )
                                 )),
                           ),
                           Align(
                             alignment: Alignment.centerRight,
                             child: Padding(
                                 padding: EdgeInsets.all(1),
                                 child: Container(
                                     height: 13,
                                     width: 13,
                                     decoration: BoxDecoration(
                                       shape: BoxShape.circle,
                                       color: Color(0xFF11dc5c),
                                     )
                                 )),
                           ),
                           Align(
                             alignment: Alignment.centerRight,
                             child: Padding(
                                 padding: EdgeInsets.all(1),
                                 child: Container(
                                     height: 13,
                                     width: 13,
                                     decoration: BoxDecoration(
                                       shape: BoxShape.circle,
                                       color: Color(0xFF11dc5c),
                                     )
                                 )),
                           ),
                         ]
                     )
                 )
             ),
             Divider(
                 color: Colors.black
             ),
             Align(alignment: Alignment.centerLeft, child: Text("Skills")),
             Divider(
                 color: Colors.black
             ),
             Align(alignment: Alignment.centerLeft, child: Text("Project Expectations")),
             IntrinsicHeight( child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                      Text("Grade"),
                       Text("B"),
                     ]
                 ),
                 VerticalDivider( thickness: 1, color: Colors.black),
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text("Weekly Hours"),
                       Text("5"),
                     ]
                 ),
               ]
             )),
             Divider(
                 color: Colors.black
             ),
             Align(alignment: Alignment.centerLeft, child: Text("Interests")),
             Divider(
                 color: Colors.black
             ),
           ]
           )
         ),
        );
  }
}
