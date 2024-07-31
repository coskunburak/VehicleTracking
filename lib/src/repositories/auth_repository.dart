import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference collectionKisiler =
      FirebaseFirestore.instance.collection("Kisiler");

  Future<void> signUp(
      {required String email,
      required String password,
      required String name,
      required String surname}) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );


      await addUserToFirestore(userCredential.user?.uid, email,password,name,surname);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('This password is too weak');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The email address is already in use');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        return false;
      }
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addUserToFirestore(
      String? uid,
      String email,
      String password,
      String name,
      String surname
      ) async {
    if (uid == null) return;

    // Şu anki zamanı al
    Timestamp now = Timestamp.now();

    // Firestore'daki kullanıcı belgesini güncelle veya oluştur
    await collectionKisiler.doc(uid).set({
      'email': email,
      'password': password,
      'name': name,
      'surname': surname,
      'createdAt': now,
      'loginTimes': FieldValue.arrayUnion([now]),
    }, SetOptions(merge:true));
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.toString());
    }
  }
}
