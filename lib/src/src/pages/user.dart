import 'package:bloc_yapisi/src/elements/pageLoading.dart';
import 'package:bloc_yapisi/src/pages/login.dart';
import 'package:bloc_yapisi/src/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_yapisi/src/blocs/firebaseBLoC/firebase_bloc.dart';
import 'package:bloc_yapisi/src/blocs/firebaseBLoC/firebase_event.dart';
import 'package:bloc_yapisi/src/blocs/firebaseBLoC/firebase_state.dart';
import 'package:bloc_yapisi/src/elements/locationButton.dart';
import 'package:bloc_yapisi/src/utils/global.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _emailController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return BlocProvider(
        create: (context) => FirebaseBloc(
          FirebaseInitial(),
          userRepository: UserRepository(),
        )..add(FetchUserInfoRequested(uid: user!.uid)),
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: const Text(
                "Kullanıcı Bilgileri",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: appBarBackgroundColor,
            ),
            body: BlocListener<FirebaseBloc, FirebaseState>(
              listener: (context, state) {
                if (state is UserDeleted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Login()),
                        (route) => false,
                  );
                } else if (state is UserInfoUpdated) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Güncelleme Durumu'),
                        content: const Text(
                            'Bilgileriniz güncellenmiştir, giriş ekranına yönlendiriliyorsunuz...'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                                    (route) => false,
                              );
                            },
                            child: const Text('Tamam'),
                          ),
                        ],
                      );
                    },
                  );
                } else if (state is UserPasswordUpdated) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Güncelleme Durumu'),
                        content: const Text(
                            'Şifreniz güncellenmiştir, giriş ekranına yönlendiriliyorsunuz...'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                                    (route) => false,
                              );
                            },
                            child: const Text('Tamam'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: BlocBuilder<FirebaseBloc, FirebaseState>(
                builder: (context, state) {
                  if (state is FirebaseLoading) {
                    return Center(child: pageLoading());
                  } else if (state is UserInfoLoaded) {
                    final userInfo =
                    state.userInfo.data() as Map<String, dynamic>?;

                    if (userInfo != null) {
                      // Kullanıcı bilgilerini al ve TextField'ı güncelle
                      _emailController.text = userInfo['email'] ?? 'N/A';
                      _nameController.text = userInfo['name'] ?? 'N/A';
                      _surnameController.text = userInfo['surname'] ?? 'N/A';

                      return Align(
                        alignment: Alignment.topCenter,
                        child: Card(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.indigo, Colors.blueAccent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 4.0),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.deepOrange,
                                          Colors.orangeAccent
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 4.0,
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      controller: _emailController,
                                      decoration: const InputDecoration(
                                        hintText:
                                        "Yeni Email Adresinizi Giriniz",
                                        hintStyle:
                                        TextStyle(color: Colors.white),
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.update,
                                            color: Colors.white),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 20.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.deepPurple,
                                          Colors.purpleAccent
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 4.0,
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      controller: _nameController,
                                      obscureText: false,
                                      decoration: const InputDecoration(
                                        hintText: "Ad",
                                        hintStyle:
                                        TextStyle(color: Colors.white),
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.lock,
                                            color: Colors.white),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 20.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.deepPurple,
                                          Colors.purpleAccent
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 4.0,
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      controller: _surnameController,
                                      obscureText: false,
                                      decoration: const InputDecoration(
                                        hintText: "soyad",
                                        hintStyle:
                                        TextStyle(color: Colors.white),
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.lock,
                                            color: Colors.white),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 20.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.deepPurple,
                                          Colors.purpleAccent
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 4.0,
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      controller: _oldPasswordController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        hintText: "Eski Şifrenizi Giriniz",
                                        hintStyle:
                                        TextStyle(color: Colors.white),
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.lock,
                                            color: Colors.white),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 20.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.deepPurple,
                                          Colors.purpleAccent
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 4.0,
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      controller: _newPasswordController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        hintText: "Yeni Şifrenizi Giriniz",
                                        hintStyle:
                                        TextStyle(color: Colors.white),
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.lock,
                                            color: Colors.white),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 20.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: 110,
                                        child: locationButton(
                                          onPressed: () {
                                            final newEmail =
                                                _emailController.text;
                                            final newName =
                                                _nameController.text;
                                            final newSurname =
                                                _surnameController.text;
                                            if (newEmail.isNotEmpty) {
                                              final updatedData = {
                                                'email': newEmail,
                                                'name': newName,
                                                'surname': newSurname
                                              };
                                              context.read<FirebaseBloc>().add(
                                                UpdateUserInfoRequested(
                                                  uid: user!.uid,
                                                  data: updatedData,
                                                ),
                                              );
                                            }
                                          },
                                          title: 'Güncelle',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 110,
                                        child: locationButton(
                                          onPressed: () {
                                            context.read<FirebaseBloc>().add(
                                              DeleteUserRequested(
                                                  uid: user!.uid),
                                            );
                                          },
                                          title: 'Hesabı Sil',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 110,
                                        child: locationButton(
                                          onPressed: () {
                                            final oldPassword =
                                                _oldPasswordController.text;
                                            final newPassword =
                                                _newPasswordController.text;
                                            if (oldPassword.isNotEmpty &&
                                                newPassword.isNotEmpty) {
                                              context.read<FirebaseBloc>().add(
                                                UpdatePasswordRequested(
                                                  oldPassword: oldPassword,
                                                  newPassword: newPassword,
                                                ),
                                              );
                                            }
                                          },
                                          title: 'Şifreyi Güncelle',
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                          child: Text('No user information available'));
                    }
                  } else if (state is FirebaseError) {
                    return Center(child: Text('Error: ${state.error}'));
                  } else {
                    return const Center(
                        child: Text('No user information available'));
                  }
                },
              ),
            ),
          ),
        ));
  }
}
