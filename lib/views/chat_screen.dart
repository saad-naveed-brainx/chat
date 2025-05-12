import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [],
      ),
      body: Column(
        children: [
          Expanded(child: Container(color: Colors.white, child: Text('Chat'))),
        ],
      ),
    );
  }
}
