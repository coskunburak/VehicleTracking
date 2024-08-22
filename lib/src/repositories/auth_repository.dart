import 'package:bloc_yapisi/src/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference collectionKisiler = FirebaseFirestore.instance.collection("Kisiler");
  final CollectionReference collectionPermissions = FirebaseFirestore.instance.collection("permissions");
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

      int permissionId = await _getNextPermissionId();

      await collectionPermissions.doc(permissionId.toString()).set({
        'vehicleIdList': [],
        'canEditUser': false,
        'canEditVehicle': false,
        'authorityLevel': 0,
        'permissionId': permissionId,
        'canEditUserVehicles' : false,
      });

      await _addUserToFirestore(userCredential.user?.uid, email, password, name, surname, permissionId);
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

  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>?> getUserPermissions(String uid) async {
    try {
      DocumentSnapshot snapshot = await collectionKisiler.doc(uid).get();
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        String permissionId = data['permissionId'].toString();

        DocumentSnapshot permissionSnapshot = await collectionPermissions.doc(permissionId).get();
        if (permissionSnapshot.exists) {
          return permissionSnapshot.data() as Map<String, dynamic>?;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Error getting permissions: $e');
    }
  }

  Future<int> _getNextPermissionId() async {
    QuerySnapshot snapshot = await collectionPermissions.orderBy('permissionId', descending: true).limit(1).get();
    if (snapshot.docs.isEmpty) {
      return 1;
    }
    int maxId = snapshot.docs.first['permissionId'] as int;
    return maxId + 1;
  }

  Future<void> _addUserToFirestore(
      String? uid,
      String email,
      String password,
      String name,
      String surname,
      int permissionId,
      ) async {
    if (uid == null) return;

    Timestamp now = Timestamp.now();

    await collectionKisiler.doc(uid).set({
      'email': email,
      'name': name,
      'surname': surname,
      'createdAt': now,
      'loginTimes': FieldValue.arrayUnion([now]),
      'permissionId': permissionId,
    }, SetOptions(merge: true));
  }

  Stream<int?> getUserAuthorityLevelStream(String uid) {
    return FirebaseFirestore.instance
        .collection('Kisiler')
        .doc(uid)
        .snapshots()
        .asyncMap((snapshot) async {
      if (snapshot.exists) {
        var userData = snapshot.data() as Map<String, dynamic>;
        String permissionId = userData['permissionId'].toString();

        DocumentSnapshot permissionSnapshot = await FirebaseFirestore.instance
            .collection('permissions')
            .doc(permissionId)
            .get();

        if (permissionSnapshot.exists) {
          var permissionData = permissionSnapshot.data() as Map<String, dynamic>;
          return permissionData['authorityLevel'] as int?;
        }
      }
      return null;

    });
  }

  Future<bool> getCanEditUser(String uid) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Kisiler')
          .doc(uid)
          .get();

      if (userSnapshot.exists) {
        var userData = userSnapshot.data() as Map<String, dynamic>;
        String permissionId = userData['permissionId'].toString();

        DocumentSnapshot permissionSnapshot = await FirebaseFirestore.instance
            .collection('permissions')
            .doc(permissionId)
            .get();

        if (permissionSnapshot.exists) {
          var permissionData = permissionSnapshot.data() as Map<String, dynamic>;
          return permissionData['canEditUser'] as bool;
        }
      }
      return false;
    } catch (e) {
      throw Exception('Error getting canEditUser: $e');
    }
  }

  Future<bool> getCanEditVehicle(String uid) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Kisiler')
          .doc(uid)
          .get();

      if (userSnapshot.exists) {
        var userData = userSnapshot.data() as Map<String, dynamic>;
        String permissionId = userData['permissionId'].toString();

        DocumentSnapshot permissionSnapshot = await FirebaseFirestore.instance
            .collection('permissions')
            .doc(permissionId)
            .get();

        if (permissionSnapshot.exists) {
          var permissionData = permissionSnapshot.data() as Map<String, dynamic>;
          return permissionData['canEditVehicle'] as bool;
        }
      }
      return false;
    } catch (e) {
      throw Exception('Error getting canEditVehicle: $e');
    }
  }

  Future<void> addVehicleToUserPermissions(String plate) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception('No user logged in');
    }

    try {
      DocumentSnapshot userSnapshot = await collectionKisiler.doc(userId).get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        String permissionId = userData['permissionId'].toString();

        DocumentReference permissionDoc = collectionPermissions.doc(permissionId);
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot permissionSnapshot = await transaction.get(permissionDoc);

          if (permissionSnapshot.exists) {
            final permissionData = permissionSnapshot.data() as Map<String, dynamic>;
            List<dynamic> vehicleIdList = List.from(permissionData['vehicleIdList'] ?? []);

            if (!vehicleIdList.contains(plate)) {
              vehicleIdList.add(plate);
              transaction.update(permissionDoc, {'vehicleIdList': vehicleIdList});
            }
          }
        });
      }
    } catch (e) {
      throw Exception('Error updating vehicleIdList: $e');
    }
  }
}
