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
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: CustomAppBar(title: "Chat"),
      body: Center(child: Text("Chat Coming Soon")),
    );
  }
}
