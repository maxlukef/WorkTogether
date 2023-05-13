import 'package:flutter/material.dart';

import '../../global_components/custom_app_bar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Widget> contacts = [];
  double dividerGap = 20.0;

  @override
  Widget build(BuildContext context) {
    contacts.add(createContact("Gary"));

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: const CustomAppBar(
        title: "Chat",
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: contacts.length,
          itemBuilder: (BuildContext context, int index) {
            return ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const ChatPage();
                    },
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: contacts[index],
                ));
          }),
    );
  }

  // Eventually add a profile picture to the contacts.
  Widget createContact(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Replace this with profile picture.
        const Padding(
          padding: EdgeInsets.fromLTRB(8.0, 0, 24, 0),
          child: Icon(
            Icons.account_circle,
            color: Colors.blue,
            size: 50.0,
          ),
        ),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
        ),
      ],
    );
  }
}
