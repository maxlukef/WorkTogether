import 'package:flutter/material.dart';
import 'package:work_together_flutter/http_request.dart';
import 'package:work_together_flutter/main.dart';
import 'package:work_together_flutter/models/chat_models/chat_info_dto.dart';
import 'package:work_together_flutter/models/chat_models/chat_message_dto.dart';
import '../../global_components/custom_app_bar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.chatInfo,
  }) : super(key: key);

  // List of users the conversation is happening between.
  final ChatInfo chatInfo;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessage>? messages;

  @override
  void initState() {
    super.initState();
    getConversationsApiCall();
  }

  Future<void> getConversationsApiCall() async {
    messages = await HttpService().getMessages(widget.chatInfo.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return messages == null
        ? const CircularProgressIndicator()
        : Scaffold(
            backgroundColor: const Color(0xFFFFFFFF),
            appBar: CustomAppBar(
              title: widget.chatInfo.name,
            ),
            body: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: messages!.length,
                itemBuilder: createMessage),
          );
  }

  Widget? createMessage(BuildContext context, int index) {
    ChatMessage currentMessage = messages![index];
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

  Widget formatMessage(ChatMessage currentMessage, Color backgroundColor,
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
                currentMessage.content,
                style: TextStyle(color: textColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
