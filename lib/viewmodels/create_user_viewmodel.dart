import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../core/constants/view_constants.dart';
import '../config/app_router.dart';

class CreateUserViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final uuid = Uuid();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> checkUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null) {
      AppRouter.moveToHomeScreen(context);
    }
  }

  Future<void> createUser(BuildContext context) async {
    if (nameController.text.isNotEmpty) {
      try {
        String userId = uuid.v4();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        UserModel user = UserModel(id: userId, name: nameController.text);
        await FirebaseFirestore.instance.collection('users').add(user.toJson());
        if (context.mounted) {
          AppRouter.moveToHomeScreen(context);
        }
      } catch (e) {
        if (context.mounted) {
          setLoading(false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error creating profile: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return ViewConstants.nameIsRequired;
    }
    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
      return ViewConstants.nameShouldOnlyContainAlphabets;
    }
    return null;
  }

  void validateAndSave(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      setLoading(true);
      await createUser(context);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
