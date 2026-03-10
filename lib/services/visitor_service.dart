import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/index.dart';

class VisitorService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String _collection = 'visitors';

  Future<String> addVisitor(Visitor visitor) async {
    try {
      final docRef = await _db
          .collection(_collection)
          .add(visitor.toJson());
      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateVisitor(String id, Visitor visitor) async {
    try {
      await _db.collection(_collection).doc(id).update(visitor.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<Visitor?> getVisitor(String id) async {
    try {
      final doc = await _db.collection(_collection).doc(id).get();
      if (doc.exists) {
        final data = doc.data() ?? {};
        return Visitor.fromJson({...data, 'id': doc.id});
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Visitor>> getAllVisitors() async {
    try {
      final snapshot = await _db
          .collection(_collection)
          .orderBy('entryTime', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => Visitor.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Visitor>> getInsideVisitors() async {
    try {
      final snapshot = await _db
          .collection(_collection)
          .where('status', isEqualTo: 'inside')
          .orderBy('entryTime', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => Visitor.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markVisitorExit(String id) async {
    try {
      await _db.collection(_collection).doc(id).update({
        'status': 'exited',
        'exitTime': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteVisitor(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Visitor>> streamVisitors() {
    return _db
        .collection(_collection)
        .orderBy('entryTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Visitor.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }
}
