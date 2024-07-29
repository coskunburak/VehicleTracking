import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference collectionKisiler =
  FirebaseFirestore.instance.collection("Kisiler");

  Future<DocumentSnapshot> getUserInfo(String uid) async {
    try {
      return await collectionKisiler.doc(uid).get();
    } catch (e) {
      throw Exception('Error fetching user info: $e');
    }
  }

  Future<void> updateUser(String uid, String email) async {
    if (uid.isEmpty) {
      throw Exception('UID cannot be empty');
    }
    try {
      await collectionKisiler.doc(uid).update({'email': email}); // Kullanıcıyı güncelleyen kısım(database)

      User? user = _firebaseAuth.currentUser; // Kullanıcıyı auth da güncelleyen kısım
      if (user != null && user.uid == uid) {
        await user.updateEmail(email);
      }
    } catch (e) {
      throw Exception('Error updating user info: $e');
    }
  }

  Future<void> deleteUser(String uid) async {
    if (uid.isEmpty) {
      throw Exception('UID cannot be empty');
    }
    try {
      await collectionKisiler.doc(uid).delete(); // kullanıcı silen kısım(databaseden)
      User? user = _firebaseAuth.currentUser; // Authdan kullanıcıyı silen kısım
      if (user != null && user.uid == uid) {
        await user.delete();
      }
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }
}
