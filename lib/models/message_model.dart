class MessageModel {
  final String sender;
  final String receiver;
  final String text;
  final dynamic timestamp;
  final String chatId;

  MessageModel({
    required this.sender,
    required this.receiver,
    required this.text,
    required this.timestamp,
    required this.chatId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      sender: json['sender'],
      receiver: json['receiver'],
      text: json['text'],
      timestamp: json['timestamp'],
      chatId: json['chatId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'receiver': receiver,
      'text': text,
      'timestamp': timestamp,
      'chatId': chatId,
    };
  }
}
