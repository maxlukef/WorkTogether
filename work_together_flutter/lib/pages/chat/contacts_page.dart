import 'package:flutter/material.dart';
import 'package:work_together_flutter/pages/chat/chat_page.dart';
import '../../global_components/custom_app_bar.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  List<Widget> conversations = [];
  double dividerGap = 20.0;

  @override
  Widget build(BuildContext context) {
    List<String> garyList = ["Gary"];
    List<String> comboNameList = ["Gary", "Danny", "Robert"];
    conversations.add(createConversation(garyList));
    conversations.add(createConversation(comboNameList));

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: const CustomAppBar(
        title: "Conversations",
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: conversations.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const ChatPage();
                      },
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: conversations[index],
                  )),
            );
          }),
    );
  }

  // Eventually add a profile picture to the conversations.
  Widget createConversation(List<String> names) {
    String combinedNames = names.join(", ");

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
          combinedNames,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 18),
        ),
      ],
    );
  }
}
