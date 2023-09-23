import 'package:flutter/material.dart';
import 'package:work_together_flutter/http_request.dart';
import 'package:work_together_flutter/models/chat_models/chat_info_dto.dart';
import 'package:work_together_flutter/pages/chat/chat_page.dart';
import 'package:work_together_flutter/pages/chat/create_conversation.dart';
import '../../global_components/custom_app_bar.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  List<ChatInfo>? conversations;

  @override
  void initState() {
    super.initState();
    getConversationsApiCall();
  }

  Future<void> getConversationsApiCall() async {
    conversations = await HttpService().getConversationInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return conversations == null
        ? const CircularProgressIndicator()
        : Scaffold(
            backgroundColor: const Color(0xFFFFFFFF),
            appBar: const CustomAppBar(
              title: "Conversations",
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: conversations!.length,
                      itemBuilder: createConversation),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                            // Bring user to create task page.
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return const CreateConversation();
                                },
                              ));
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
                )
              ],
            ),
          );
  }

  Widget? createConversation(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade200),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return ChatPage(
                  chatInfo: conversations![index],
                );
              },
            ));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              conversations![index].name,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 18),
            ),
          )),
    );
  }
}
