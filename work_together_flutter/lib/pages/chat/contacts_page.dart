import 'dart:html';

import 'package:flutter/material.dart';
import 'package:work_together_flutter/global_components/our_colors.dart';
import 'package:work_together_flutter/http_request.dart';
import 'package:work_together_flutter/models/chat_models/chat_info_dto.dart';
import 'package:work_together_flutter/models/chat_models/chat_rename_dto.dart';
import 'package:work_together_flutter/pages/chat/chat_page.dart';
import 'package:work_together_flutter/pages/chat/create_conversation.dart';
import '../../global_components/custom_app_bar.dart';
import 'dart:async';

class ConversationPage extends StatefulWidget {
  const ConversationPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  List<ChatInfo>? conversations;
  TextEditingController renameController = TextEditingController();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = createTimer();
    getConversationsApiCall();
  }

  Timer createTimer() {
    return Timer.periodic(
        const Duration(seconds: 5), (Timer t) => getConversationsApiCall());
  }

  Future<void> getConversationsApiCall() async {
    conversations = await HttpService().getConversationInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return conversations == null
        ? const Center(
            child: SizedBox(
                height: 50, width: 50, child: CircularProgressIndicator()),
          )
        : Scaffold(
            backgroundColor: const Color(0xFFFFFFFF),
            appBar: const CustomAppBar(
              title: "Conversations",
            ),
            body: SizedBox(
              width: 675,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: ourLightColor()),
                              onPressed: () async {
                                timer?.cancel();
                                await Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (BuildContext context,
                                        Animation<double> animation1,
                                        Animation<double> animation2) {
                                      return const CreateConversation();
                                    },
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                                timer = createTimer();
                                await getConversationsApiCall();
                              },
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(12, 4, 12, 8),
                                child: Text(
                                  "Create Conversation",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: conversations!.length,
                      itemBuilder: loadConversation,
                      shrinkWrap: true,
                    ),
                  )
                ],
              ),
            ),
          );
  }

  Widget? loadConversation(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
          splashColor: const Color.fromARGB(0, 0, 0, 0),
          hoverColor: const Color.fromARGB(0, 0, 0, 0),
          focusColor: const Color.fromARGB(0, 0, 0, 0),
          highlightColor: const Color.fromARGB(0, 0, 0, 0),
          onTap: () async {
            timer?.cancel();
            await Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (BuildContext context,
                    Animation<double> animation1,
                    Animation<double> animation2) {
                  return ChatPage(
                    chatInfo: conversations![index],
                  );
                },
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            timer = createTimer();
            await getConversationsApiCall();
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(12),
              //   color: ourVeryLightColor(),
              // ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        conversations![index].name,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: SizedBox(
                        width: 145,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 65,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(20, 0, 0, 0)),
                                onPressed: () async {
                                  ChatInfo currentChat = conversations![index];
                                  String? newName =
                                      await openRenameDialog(currentChat.name);
                                  if (newName != null) {
                                    ChatRenameDTO dto =
                                        ChatRenameDTO(currentChat.id, newName);
                                    await HttpService().renameChat(dto);
                                    getConversationsApiCall();
                                  }
                                },
                                child: const Icon(
                                  Icons.edit,
                                  size: 20.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 65,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(20, 0, 0, 0)),
                                onPressed: () async {
                                  bool? shouldDelete = await openLeaveDialog();
                                  if (shouldDelete != null) {
                                    if (shouldDelete) {
                                      await HttpService()
                                          .leaveChat(conversations![index].id);
                                      getConversationsApiCall();
                                    }
                                  }
                                },
                                child: const Icon(
                                  Icons.delete,
                                  size: 20.0,
                                  color: Colors.black,
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
          )),
    );
  }

  Future<bool?> openLeaveDialog() => showDialog<bool?>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Leave Chat"),
          content:
              const Text("Are you sure you would like to leave this chat?"),
          actions: [
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: ourLightColor()),
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('cancel')),
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: ourLightColor()),
                onPressed: () => Navigator.of(context).pop(true), // returns val
                child: const Text('confirm')),
          ],
        ),
      );

  Future<String?> openRenameDialog(String currentName) {
    renameController.text = currentName;
    return showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Rename Chat"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Enter the new name for the chat."),
            TextField(
              controller: renameController,
              autofocus: true,
            )
          ],
        ),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: ourLightColor()),
              onPressed: () => Navigator.of(context).pop(null), // returns val
              child: const Text('cancel')),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: ourLightColor()),
              onPressed: () {
                String returnValue = renameController.text;
                renameController.text = "";
                Navigator.of(context).pop(returnValue);
              },
              child: const Text('confirm')),
        ],
      ),
    );
  }
}
