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

  // Test Messages. Create these dynamically when api is setup.
  Message m1 = Message("Hello!", "John Coder", 2);
  Message m2 = Message("Hi John!", "Sebastian Carson", 4);

  @override
  Widget build(BuildContext context) {
    messages.add(m1);
    messages.add(m2);

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
      textMessage =
          formatMessage(currentMessage, Colors.blue, Colors.white, true);
    }
    // Different appearance if the message was sent by anybody else.
    else {
      textMessage = formatMessage(
          currentMessage, Colors.grey.shade200, Colors.black, false);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [textMessage, const Divider()],
      ),
    );
  }

  Widget formatMessage(Message currentMessage, Color backgroundColor,
      Color textColor, bool currentUser) {
    // Display "You" if the current user sent the message,
    // Else display the name of the sender.
    String sender = "";
    if (currentUser) {
      sender = "You";
    } else {
      sender = currentMessage.senderName;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sender,
          style: const TextStyle(fontSize: 15, color: Colors.black),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                currentMessage.messageText,
                style: TextStyle(color: textColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
