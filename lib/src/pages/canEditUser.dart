import 'package:bloc_yapisi/src/elements/appBar.dart';
import 'package:bloc_yapisi/src/pages/canEditUserVehicles.dart';
import 'package:bloc_yapisi/src/pages/userUpdate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Canedituser extends StatefulWidget {
  const Canedituser({super.key});

  @override
  State<Canedituser> createState() => _CanedituserState();
}

class _CanedituserState extends State<Canedituser> {
  final CollectionReference collectionKisiler =
  FirebaseFirestore.instance.collection("Kisiler");

  void _deleteUser(String userId) async {
    try {
      await collectionKisiler.doc(userId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: "Admin Kullanıcı Düzenleme", isBack: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: collectionKisiler.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return const Center(child: Text('No users found'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final data = user.data() as Map<String, dynamic>;
              final userId = user.id;
              final name = data['name'] ?? 'No name';
              final surname = data['surname'] ?? 'No surname';
              final email = data['email'] ?? 'No email';

              return ListTile(
                title: Text('$name $surname'),
                subtitle: Text(email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserScreen(userId: user.id),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteUser(userId);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_note, color: Colors.blue),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Canedituservehicles(userId: userId),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
