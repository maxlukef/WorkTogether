import 'package:flutter/material.dart';
import 'package:work_together_flutter/global_components/tag_small.dart';

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
                   Padding(
                     padding: EdgeInsets.only(left: 10),
                     child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Align(alignment: Alignment.centerLeft, child: Text(fullName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700))),
                               Align(alignment: Alignment.centerLeft, child: Text(major, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700))),
                             ]
                         )
                     )
                 ]),
             Divider(
               color: Colors.black
             ),
        Padding(padding: EdgeInsets.only(bottom: 5),
            child: Align(alignment: Alignment.centerLeft, child: Text("Availability", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)))),
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
                             child: Icon(Icons.sunny),
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
                                   ),
                                 child: Align(alignment: Alignment.center, child: Text("M", style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800),),)
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
        Padding(padding: EdgeInsets.only(bottom: 5),
            child: Align(alignment: Alignment.centerLeft, child: Text("Skills", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)))),
             Align(
               alignment: Alignment.centerLeft,
               child: Wrap(
                   children: const [
                     Padding(
                       padding: EdgeInsets.only(top: 3, right: 6, bottom: 3),
                       child: Tag(text: "Python"),
                     ),
                     Padding(
                       padding: EdgeInsets.only(top: 3, right: 6, bottom: 3),
                       child: Tag(text: "Databases"),
                     ),
                     Padding(
                       padding: EdgeInsets.only(top: 3, right: 6, bottom: 3),
                       child: Tag(text: "Backend Development"),
                     ),
                     Padding(
                       padding: EdgeInsets.only(top: 3, right: 6, bottom: 3),
                       child: Tag(text: "Django"),
                     ),
                   ]
               ),
             ),
             Divider(
                 color: Colors.black
             ),
             Padding(padding: EdgeInsets.only(bottom: 5),
                 child: Align(alignment: Alignment.centerLeft,
                     child: Text("Project Expectations", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)))),
             IntrinsicHeight( child: Row(
               children: [
                 Expanded(
                   flex: 10,
                   child: Column(
                       children: [
                         Text("Grade", style: TextStyle(fontSize: 8)),
                         Text("B", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                       ]
                   ),
                 ),
                 Expanded(
                   flex: 1,
                   child: VerticalDivider( thickness: 1, color: Colors.black),
                 ),
                 Expanded(
                   flex: 10,
                   child: Column(
                       children: [
                         Text("Weekly Hours", style: TextStyle(fontSize: 8)),
                         Text("5", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                       ]
                   ),
                 )
               ]
             )),
             Divider(
                 color: Colors.black
             ),
        Padding(padding: EdgeInsets.only(bottom: 5),
            child: Align(alignment: Alignment.centerLeft, child: Text("Interests", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)))),
             Align(
               alignment: Alignment.centerLeft,
               child: Wrap(
                   children: const [
                     Padding(
                       padding: EdgeInsets.only(top: 3, right: 6, bottom: 3),
                       child: Tag(text: "Rock Climbing"),
                     ),
                     Padding(
                       padding: EdgeInsets.only(top: 3, right: 6, bottom: 3),
                       child: Tag(text: "Reading"),
                     ),
                     Padding(
                       padding: EdgeInsets.only(top: 3, right: 6, bottom: 3),
                       child: Tag(text: "Food"),
                     ),
                     Padding(
                       padding: EdgeInsets.only(top: 3, right: 6, bottom: 3),
                       child: Tag(text: "Building Houses"),
                     ),
                     Padding(
                       padding: EdgeInsets.only(top: 3, right: 6, bottom: 3),
                       child: Tag(text: "All Things Awesome"),
                     ),
                   ]
               ),
             ),
             Divider(
                 color: Colors.black
             ),
           ]
           )
         ),
        );
  }
}
