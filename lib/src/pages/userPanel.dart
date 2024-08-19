import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAdminScreen extends StatelessWidget {
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('Kisiler');
    QuerySnapshot snapshot = await usersCollection.get();
    List<QueryDocumentSnapshot> docs = snapshot.docs;

    return docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['uid'] = doc.id;
      return data;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Management"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Error loading users or no users found"));
          }

          List<Map<String, dynamic>> users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> user = users[index];
              String email = user['email'] ?? "No Email";

              return Card(
                child: ListTile(
                  title: Text(email),
                  onTap: () {
                    _showUserOptions(context, user);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showUserOptions(BuildContext context, Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("Arac Ekle/Cıkar"),
              onTap: () {
                _handleAddRemoveVehicle(context, user);
              },
            ),
            ListTile(
              title: Text("Düzenle"),
              onTap: () {
                _handleEditUser(context, user);
              },
            ),
            ListTile(
              title: Text("Sil"),
              onTap: () {
                _handleDeleteUser(context, user);
              },
            ),
          ],
        );
      },
    );
  }

  void _handleAddRemoveVehicle(BuildContext context, Map<String, dynamic> user) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Add/Remove Vehicle clicked for ${user['email']}")),
    );
  }
  void _handleEditUser(BuildContext context, Map<String, dynamic> user) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance.collection('Kisiler').doc(user['uid']).get();

    if (userDoc.exists) {
      Map<String, dynamic>? userData = userDoc.data();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController nameController = TextEditingController(text: userData?['name']);
          TextEditingController surnameController = TextEditingController(text: userData?['surname']);
          TextEditingController emailController = TextEditingController(text: userData?['email']);
          TextEditingController passwordController = TextEditingController(text: "");

          return AlertDialog(
            title: Text("Edit User"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Name"),
                  ),
                  TextField(
                    controller: surnameController,
                    decoration: InputDecoration(labelText: "Surname"),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email"),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  try {
                    User? currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser != null && currentUser.uid == user['uid']) {
                      if (emailController.text.isNotEmpty) {
                        await currentUser.updateEmail(emailController.text);
                      }
                      if (passwordController.text.isNotEmpty) {
                        await currentUser.updatePassword(passwordController.text);
                      }
                    }

                    await FirebaseFirestore.instance.collection('Kisiler').doc(user['uid']).update({
                      'name': nameController.text,
                      'surname': surnameController.text,
                      'email': emailController.text,
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("User updated successfully")),
                    );
                  } catch (error) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to update user: $error")),
                    );
                  }
                },
                child: Text("Save"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch user data")),
      );
    }
  }

  void _handleDeleteUser(BuildContext context, Map<String, dynamic> user) async {
    try {
      String uid = user['uid'];

      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && currentUser.uid == uid) {
        await currentUser.delete();
      }

      await FirebaseFirestore.instance.collection('Kisiler').doc(uid).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${user['email']} has been deleted")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete user: $e")),
      );
    }
  }
}
