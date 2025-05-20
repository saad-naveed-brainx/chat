import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getChatMessages(String chatId) {
    return _firestore
        .collection('chat')
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp')
        .snapshots();
  }

  Future<void> sendMessage(MessageModel message) async {
    await _firestore.collection('chat').add(message.toJson());
  }

  String generateChatId(String id1, String id2) {
    if (id1.compareTo(id2) < 0) {
      return '$id1-$id2';
    } else {
      return '$id2-$id1';
    }
  }
}
