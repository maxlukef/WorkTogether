import 'package:flutter/material.dart';
import 'package:work_together_flutter/main.dart';
import 'package:work_together_flutter/pages/chat/Components/message.dart';
import '../../global_components/custom_app_bar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.names,
  }) : super(key: key);

  // List of users the conversation is happening between.
  final List<String> names;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [];

  // Test Messages.
  Message m1 = Message("Hello!", "John Coder", 2);
  Message m2 = Message("Hi John!", "Sebastian Carson", 4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: CustomAppBar(
        title: widget.names.join(", "),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: messages.length,
          itemBuilder: createMessage),
    );
  }

  Widget? createMessage(BuildContext context, int index) {
    Message currentMessage = messages[index];
    Widget textMessage;

    // Change message look if the logged in user sent it.
    if (currentMessage.senderID == loggedUserId) {
      textMessage = Column(
        children: [
          Text(
            currentMessage.senderName,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
          Container(
            color: Colors.blue,
            child: Text(
              currentMessage.messageText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    }
    // Different appearance if the message was sent by anybody else.
    else {
      textMessage = Column(
        children: [
          Text(
            currentMessage.senderName,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
          Container(
            color: Colors.grey.shade50,
            child: Text(
              currentMessage.messageText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: textMessage,
    );
  }
}
