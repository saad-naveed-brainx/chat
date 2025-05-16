import 'package:chatme/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/view_constants.dart';
import '../config/app_router.dart';

class CreateUserProfile extends StatefulWidget {
  const CreateUserProfile({super.key});

  @override
  State<CreateUserProfile> createState() => _CreateUserProfileState();
}

class _CreateUserProfileState extends State<CreateUserProfile> {
  TextEditingController nameController = TextEditingController();
  final uuid = Uuid();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void validateAndSave() {
    if (formKey.currentState!.validate()) {
      _createUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(ViewConstants.createUserProfile)),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.gap20Px,
                    vertical: AppConstants.gap10Px,
                  ),
                  child: TextFormField(
                    controller: nameController,
                    validator: nameValidator,
                    onTapOutside: (_) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      hintText: ViewConstants.enterYourName,
                      filled: true,
                      fillColor: Colors.grey[100],
                      prefixIcon: const Icon(Icons.person, color: Colors.blue),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.gap14Px,
                        ),
                        borderSide: BorderSide(color: Colors.blue.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.gap14Px,
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue.shade200,
                          width: AppConstants.gap2Px,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: AppConstants.gap14Px,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.gap20Px,
                ),
                child: ElevatedButton(
                  onPressed: validateAndSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.gap24Px * 2,
                      vertical: AppConstants.gap14Px,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.gap14Px * 2,
                      ),
                    ),
                    elevation: 5,
                    shadowColor: Colors.blue.withOpacity(0.5),
                  ),
                  child: const Text(
                    ViewConstants.startChatting,
                    style: TextStyle(
                      fontSize: AppConstants.gap14Px,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null) {
      AppRouter.moveToHomeScreen(context);
    }
  }

  Future<void> _createUser() async {
    if (nameController.text.isNotEmpty) {
      String userId = uuid.v4();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);
      UserModel user = UserModel(id: userId, name: nameController.text);
      await FirebaseFirestore.instance.collection('users').add(user.toJson());
      AppRouter.moveToHomeScreen(context);
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
}
