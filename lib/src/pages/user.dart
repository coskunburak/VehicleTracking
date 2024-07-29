import 'package:bloc_yapisi/src/blocs/firebaseBLoC/firebase_bloc.dart';
import 'package:bloc_yapisi/src/blocs/firebaseBLoC/firebase_event.dart';
import 'package:bloc_yapisi/src/blocs/firebaseBLoC/firebase_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloc_yapisi/src/repositories/user_repository.dart';

import 'login.dart';

class UserPage extends StatelessWidget {
  final _emailController = TextEditingController();

  UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return BlocProvider(
      create: (context) => FirebaseBloc(userRepository: UserRepository()),
      child: Builder(
        builder: (context) {
          if (user != null) {
            context.read<FirebaseBloc>().add(FetchUserInfoRequested(uid: user.uid));
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('Kullanıcı Bilgileri'),
            ),
            body: BlocListener<FirebaseBloc, FirebaseState>(
              listener: (context, state) {
                if (state is UserUpdated) {
                  if (user != null) {
                    context.read<FirebaseBloc>().add(FetchUserInfoRequested(uid: user.uid));
                  }
                } else if (state is UserDeleted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                }
              },
              child: BlocBuilder<FirebaseBloc, FirebaseState>(
                builder: (context, state) {
                  if (state is FirebaseLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is UserInfoLoaded) {
                    final userInfo = state.userInfo.data() as Map<String, dynamic>?;

                    if (userInfo != null) {
                      _emailController.text = userInfo['email'] ?? '';
                    }

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Yeni Mail Adresinizi Giriniz:',
                              labelStyle: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  final newEmail = _emailController.text.trim();
                                  if (user != null && newEmail.isNotEmpty) {
                                    context.read<FirebaseBloc>().add(
                                      UpdateUserRequested(uid: user.uid, email: newEmail),
                                    );
                                  }
                                },
                                child: Text('Güncelle', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              SizedBox(width: 50.0),
                              ElevatedButton(
                                onPressed: () {
                                  if (user != null) {
                                    context.read<FirebaseBloc>().add(
                                      DeleteUserRequested(uid: user.uid),
                                    );
                                  }
                                },
                                child: Text('Hesabı Sil', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (state is FirebaseError)
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                'Error: ${state.error}',
                                style: TextStyle(color: Colors.redAccent, fontSize: 16.0, fontWeight: FontWeight.w600),
                              ),
                            ),
                        ],
                      ),
                    );
                  } else if (state is FirebaseError) {
                    return Center(child: Text('Error: ${state.error}'));
                  } else {
                    return Center(child: Text('Kullanıcı Hesabı Bulunamadı'));
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
