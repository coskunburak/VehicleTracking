import 'package:bloc_yapisi/src/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference collectionKisiler = FirebaseFirestore.instance.collection("Kisiler");
  final UserRepository userRepository = UserRepository();

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String surname,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await addUserToFirestore(userCredential.user?.uid, email, password, name, surname);
      String? token = await userRepository.getMessageToken();
      await userRepository.saveMessageToken(userCredential.user?.uid ?? "", token);
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
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Son giriş zamanını güncelle
      String? uid = userCredential.user?.uid;
      if (uid != null) {
        await collectionKisiler.doc(uid).update({
          'loginTimes': Timestamp.now(),
        });
      }

      String? token = await userRepository.getMessageToken();
      await userRepository.saveMessageToken(uid ?? "", token);

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
      String surname,
      ) async {
    if (uid == null) return;

    Timestamp now = Timestamp.now();

    await collectionKisiler.doc(uid).set({
      'email': email,
      'name': name,
      'surname': surname,
      'createdAt': now,
      'loginTimes': FieldValue.arrayUnion([now]),
    }, SetOptions(merge: true));
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.toString());
    }
  }
}