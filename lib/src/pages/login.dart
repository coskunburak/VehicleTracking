import 'package:bloc_yapisi/src/blocs/loginBLoC/auth_bloc.dart';
import 'package:bloc_yapisi/src/blocs/loginBLoC/auth_event.dart';
import 'package:bloc_yapisi/src/blocs/loginBLoC/auth_state.dart';
import 'package:bloc_yapisi/src/elements/pageLoading.dart';
import 'package:bloc_yapisi/src/pages/list.dart';
import 'package:bloc_yapisi/src/repositories/auth_repository.dart';
import 'package:bloc_yapisi/src/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        ),
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: appBarBackgroundColor,
              elevation: 0,
              title: const Text(
                "Giriş",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Giriş Yap'),
                  Tab(text: 'Kayıt Ol'),
                  Tab(text: 'Şifremi Unuttum'),
                ],
              ),
            ),
            body: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Authenticated) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListScreen(),
                    ),
                  );
                }
                if (state is UnAuthenticated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                    ),
                  );
                }
                if (state is SignUpSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kayıt Başarılı')),
                  );
                }
                if (state is ResetPasswordSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Şifre sıfırlama e-postası gönderildi')),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TabBarView(
                  children: [
                    _buildLoginTab(context),
                    _buildSignUpTab(context),
                    _buildResetPasswordTab(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginTab(BuildContext context) {
    final TextEditingController _loginEmailController = TextEditingController();
    final TextEditingController _loginPasswordController =
        TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _loginEmailController,
            decoration: InputDecoration(
              labelText: 'E-posta',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: Colors.blue.shade50,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _loginPasswordController,
            decoration: InputDecoration(
              labelText: 'Şifre',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: Colors.blue.shade50,
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Loading) {
                return pageLoading();
              }
              return ElevatedButton(
                onPressed: () {
                  try {
                    FocusManager.instance.primaryFocus?.unfocus();
                  } catch (e) {}

                  final email = _loginEmailController.text;
                  final password = _loginPasswordController.text;
                  context.read<AuthBloc>().add(LoginRequested(email: email, password: password));
                },
                child: const Text('Giriş Yap'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpTab(BuildContext context) {
    final TextEditingController _signUpNameController =
    TextEditingController();
    final TextEditingController _signUpSurnameController =
    TextEditingController();
    final TextEditingController _signUpEmailController =
        TextEditingController();
    final TextEditingController _signUpPasswordController =
        TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _signUpNameController,
            decoration: InputDecoration(
              labelText: 'Ad',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: Colors.blue.shade50,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _signUpSurnameController,
            decoration: InputDecoration(
              labelText: 'Soyad',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: Colors.blue.shade50,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _signUpEmailController,
            decoration: InputDecoration(
              labelText: 'E-posta',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: Colors.blue.shade50,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _signUpPasswordController,
            decoration: InputDecoration(
              labelText: 'Şifre',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: Colors.blue.shade50,
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Loading) {
                return pageLoading();
              }
              return ElevatedButton(
                onPressed: () {
                  try {
                    FocusManager.instance.primaryFocus?.unfocus();
                  } catch (e) {}

                  final email = _signUpEmailController.text;
                  final password = _signUpPasswordController.text;
                  final name = _signUpNameController.text;
                  final surname = _signUpSurnameController.text;
                  context.read<AuthBloc>().add(SignUpRequested(email: email, password: password, name: name, surname: surname,));
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ListScreen()));
                },
                child: const Text('Kayıt Ol'),

              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResetPasswordTab(BuildContext context) {
    final TextEditingController _resetPasswordEmailController =
        TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _resetPasswordEmailController,
            decoration: InputDecoration(
              labelText: 'E-posta Adresinizi Girin',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: Colors.blue.shade50,
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Loading) {
                return pageLoading();
              }
              return ElevatedButton(
                onPressed: () {
                  try {
                    FocusManager.instance.primaryFocus?.unfocus();
                  } catch (e) {}

                  final email = _resetPasswordEmailController.text;
                  context.read<AuthBloc>().add(ResetPasswordRequested(email: email));
                },
                child: const Text('Şifreyi Sıfırla'),
              );
            },
          ),
        ],
      ),
    );
  }
}
