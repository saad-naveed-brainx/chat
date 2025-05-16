import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';
import '../core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/view_constants.dart';
import '../models/message_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user2Id, required this.user2Name});
  final String user2Id;
  final String user2Name;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  String user1 = '';
  String? chatId;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((callback) {
      iniliazeZomponent();
    });
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _scrollToBottom(delay: true);
      }
    });
  }

  Future<void> fetchCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user1 = prefs.getString('userId') ?? '';
  }

  void _scrollToBottom({bool delay = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      if (delay) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      } else {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String generateChatId(String id1, String id2) {
    if (id1.compareTo(id2) < 0) {
      return '$id1-$id2';
    } else {
      return '$id2-$id1';
    }
  }

  void _addMessage() {
    if (textEditingController.text.isNotEmpty) {
      if (textEditingController.text.contains(RegExp(r'^\s*$'))) {
        return;
      }

      FirebaseFirestore.instance
          .collection('chat')
          .add(
            MessageModel(
              sender: user1,
              receiver: widget.user2Id,
              text: textEditingController.text,
              timestamp: FieldValue.serverTimestamp(),
              chatId: chatId ?? '',
            ).toJson(),
          );
      textEditingController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Center(
            child: Text(
              widget.user2Name,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 8,
          actions: [],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.gap16Px),
            child: Column(
              children: [
                Expanded(
                  child:
                      chatId != null
                          ? StreamBuilder<QuerySnapshot>(
                            stream:
                                FirebaseFirestore.instance
                                    .collection('chat')
                                    .where('chatId', isEqualTo: chatId)
                                    .orderBy('timestamp')
                                    .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Center(
                                  child: Text(ViewConstants.noMessages),
                                );
                              }
                              return ListView.builder(
                                controller: _scrollController,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  if (snapshot.data!.docs[index]['sender'] ==
                                      user1) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppConstants.gap8Px,
                                        vertical: AppConstants.gap4Px,
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.75,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue[400],
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(26),
                                              topRight: Radius.circular(26),
                                              bottomLeft: Radius.circular(26),
                                              bottomRight: Radius.circular(1),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: AppConstants.gap16Px,
                                              vertical: AppConstants.gap12Px,
                                            ),
                                            child: Text(
                                              snapshot.data!.docs[index]['text']
                                                  as String,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppConstants.gap8Px,
                                        vertical: AppConstants.gap4Px,
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.75,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(26),
                                              topRight: Radius.circular(26),
                                              bottomLeft: Radius.circular(1),
                                              bottomRight: Radius.circular(26),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: AppConstants.gap16Px,
                                              vertical: AppConstants.gap12Px,
                                            ),
                                            child: Text(
                                              snapshot.data!.docs[index]['text']
                                                  as String,
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          )
                          : Center(child: CircularProgressIndicator()),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _addMessage,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> iniliazeZomponent() async {
    await fetchCurrentUser();
    chatId = generateChatId(user1, widget.user2Id);
    setState(() {});
  }
}
