import 'package:flutter/material.dart';
import 'package:work_together_flutter/global_components/our_colors.dart';
import 'package:work_together_flutter/http_request.dart';
import 'package:work_together_flutter/main.dart';
import 'package:work_together_flutter/models/chat_models/chat_info_dto.dart';
import 'package:work_together_flutter/models/chat_models/chat_message_dto.dart';
import 'package:work_together_flutter/models/chat_models/send_message_dto.dart';
import '../../global_components/custom_app_bar.dart';
import 'dart:async';

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
  Timer? timer;
  List<ChatMessage>? messages;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Change the delay to change how frequently the chat page refreshes itself.
    timer = Timer.periodic(
        const Duration(seconds: 5), (Timer t) => getMessagesApiCall());
    getMessagesApiCall();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> getMessagesApiCall() async {
    messages = await HttpService().getMessages(widget.chatInfo.id);
    setState(() {});
  }

  void sendMessage(String text) async {
    if (text.isEmpty) {
      return;
    }
    SendMessageDto dto = SendMessageDto(widget.chatInfo.id, text);
    await HttpService().sendMessage(dto);
    await getMessagesApiCall();
    messageController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return messages == null
        ? const Center(
            child: SizedBox(
                height: 50, width: 50, child: CircularProgressIndicator()),
          )
        : Scaffold(
            backgroundColor: const Color(0xFFFFFFFF),
            appBar: CustomAppBar(
              title: widget.chatInfo.name,
            ),
            body: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: SizedBox(
                  width: 675,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 55),
                            itemCount: messages!.length,
                            itemBuilder: createMessage),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 10, bottom: 10, top: 10),
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Row(
                            children: <Widget>[
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: messageController,
                                  maxLines: null,
                                  onSubmitted: sendMessage,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      hintText: "Write message...",
                                      hintStyle: TextStyle(color: Colors.black),
                                      border: InputBorder.none),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    sendMessage(messageController.text);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: ourLightColor()),
                                  child: const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget createMessage(BuildContext context, int index) {
    ChatMessage currentMessage = messages![index];
    Widget textMessage;
    bool sentByUser = currentMessage.senderID == loggedUserId;
    // Change message look if the logged in user sent it.
    if (sentByUser) {
      textMessage = formatMessage(currentMessage,
          const Color.fromARGB(255, 129, 190, 240), Colors.black, true);
    }
    // Different appearance if the message was sent by anybody else.
    else {
      textMessage = formatMessage(
          currentMessage, Colors.grey.shade200, Colors.black, false);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            sentByUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                softWrap: true,
                style: TextStyle(color: textColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
