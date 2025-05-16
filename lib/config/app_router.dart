import 'package:flutter/material.dart';
import 'package:chatme/views/home_screen.dart';
import 'package:chatme/views/chat_screen.dart';
class AppRouter {
  static void moveToHomeScreen(BuildContext context){
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
  }

  static void moveToChatScreen(BuildContext context, String user2Id, String user2Name){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen(user2Id: user2Id, user2Name: user2Name)),
    );
  }
}