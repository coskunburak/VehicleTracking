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

  Future<void> updateUserInfo(String uid, Map<String, dynamic> data) async {
    try {
      await collectionKisiler.doc(uid).update(data);
    } catch (e) {
      throw Exception('Error updating user info: $e');
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await collectionKisiler.doc(uid).delete();

      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.uid == uid) {
        await user.delete();
      } else {
        throw Exception('Kullanıcı oturum açmamış.');
      }
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  Future<void> updateEmail(String newEmail) async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      if (user != null) {
        await user.updateEmail(newEmail);
        await user.sendEmailVerification();
        await FirebaseAuth.instance.signOut();
      } else {
        throw Exception('Şu anda oturum açmış bir kullanıcı bulunmuyor.');
      }
    } catch (e) {
      throw Exception(
          'E-posta adresiniz güncellenmiştir. Lütfen yeni e-posta adresinize gelen doğrulama bağlantısını kontrol edin ve yeniden giriş yapın.');
    }
  }

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    final user = _firebaseAuth.currentUser;
    final credential = EmailAuthProvider.credential(
      email: user!.email!,
      password: oldPassword,
    );

    try {
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } catch (e) {
      throw Exception('Şifre güncellenirken bir hata oluştu: $e');
    }
  }
}
