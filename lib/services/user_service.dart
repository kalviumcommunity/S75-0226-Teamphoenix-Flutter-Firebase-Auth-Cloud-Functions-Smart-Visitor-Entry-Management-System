import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/index.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String _collection = 'users';

  Future<void> createUser({
    required String uid,
    required String email,
    required String name,
    required String role,
  }) async {
    try {
      await _db.collection(_collection).doc(uid).set({
        'id': uid,
        'email': email,
        'name': name,
        'role': role,
        'createdAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<AppUser?> getUser(String uid) async {
    try {
      final doc = await _db.collection(_collection).doc(uid).get();
      if (doc.exists) {
        return AppUser.fromJson(doc.data() ?? {});
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await _db.collection(_collection).doc(uid).update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AppUser>> getAllUsers() async {
    try {
      final snapshot = await _db.collection(_collection).get();
      return snapshot.docs.map((doc) => AppUser.fromJson(doc.data())).toList();
    } catch (e) {
      rethrow;
    }
  }
}
