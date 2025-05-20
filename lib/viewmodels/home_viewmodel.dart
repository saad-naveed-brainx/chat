import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/app_router.dart';
import '../repositories/user_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final UserRepository _repository;
  String myUserId = '';
  bool isLoading = false;

  HomeViewModel({UserRepository? repository})
    : _repository = repository ?? UserRepository();

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> getUsers() async {
    setLoading(true);
    try {
      await _repository.initialize();
      myUserId = await _repository.getCurrentUserId();
      setLoading(false);
    } catch (e) {
      setLoading(false);
      debugPrint('Error getting users: $e');
    }
  }

  Stream<QuerySnapshot> getUsersStream() {
    return _repository.getUsersStream();
  }

  void navigateToChat(BuildContext context, String userId, String userName) {
    AppRouter.moveToChatScreen(context, userId, userName);
  }
}
