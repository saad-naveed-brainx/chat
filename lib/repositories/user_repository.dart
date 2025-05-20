import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final FirebaseFirestore _firestore;
  SharedPreferences? _prefs;

  UserRepository({FirebaseFirestore? firestore, SharedPreferences? prefs})
    : _firestore = firestore ?? FirebaseFirestore.instance {
    _prefs = prefs;
  }

  Future<void> initialize() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  Future<String> getCurrentUserId() async {
    await initialize();
    return _prefs?.getString('userId') ?? '';
  }

  Stream<QuerySnapshot> getUsersStream() {
    return _firestore.collection('users').snapshots();
  }
}
