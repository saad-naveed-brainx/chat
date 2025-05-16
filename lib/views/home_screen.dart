import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatme/core/constants/app_constants.dart';
import 'package:chatme/core/constants/view_constants.dart';
import 'package:chatme/config/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String myuserId = '';
  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(ViewConstants.availableUsers))),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text(ViewConstants.noUsersFound));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.gap16Px,
                ),
                child: GestureDetector(
                  onTap: () {
                    AppRouter.moveToChatScreen(
                      context,
                      snapshot.data!.docs[index]['id'],
                      snapshot.data!.docs[index]['name'],
                    );
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.gap14Px),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.gap16Px,
                        horizontal: AppConstants.gap20Px,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade100, Colors.blue.shade300],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppConstants.gap14Px,
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: AppConstants.gap14Px),
                          Text(
                            '${snapshot.data!.docs[index]['name']}${snapshot.data!.docs[index]['id'] == myuserId ? ' (${ViewConstants.you})' : ''}',
                            style: const TextStyle(
                              fontSize: AppConstants.font20Px,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myuserId = prefs.getString('userId') ?? '';
  }
}
