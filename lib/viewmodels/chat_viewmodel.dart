import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';
import '../repositories/chat_repository.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatRepository _repository = ChatRepository();
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  String currentUserId = '';
  String? chatId;
  bool isLoading = true;

  ChatRepository get repository => _repository;

  Future<void> initialize(String user2Id) async {
    isLoading = true;
    notifyListeners();

    await _fetchCurrentUser();
    chatId = _repository.generateChatId(currentUserId, user2Id);

    isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getString('userId') ?? '';
  }

  void scrollToBottom() {
    if (!scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> sendMessage(String receiverId) async {
    if (textController.text.isNotEmpty &&
        !textController.text.contains(RegExp(r'^\s*$'))) {
      final message = MessageModel(
        sender: currentUserId,
        receiver: receiverId,
        text: textController.text,
        timestamp: FieldValue.serverTimestamp(),
        chatId: chatId ?? '',
      );

      await _repository.sendMessage(message);
      textController.clear();
      scrollToBottom();
    }
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
