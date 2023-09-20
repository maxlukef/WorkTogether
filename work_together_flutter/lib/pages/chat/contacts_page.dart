import 'package:flutter/material.dart';
import 'package:work_together_flutter/http_request.dart';
import 'package:work_together_flutter/models/chat_models/chat_info_dto.dart';
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
            body: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: conversations!.length,
                itemBuilder: createConversation),
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
