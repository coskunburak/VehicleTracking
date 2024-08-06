import 'package:bloc_yapisi/src/blocs/loginBLoC/auth_bloc.dart';
import 'package:bloc_yapisi/src/blocs/loginBLoC/auth_event.dart';
import 'package:bloc_yapisi/src/blocs/loginBLoC/auth_state.dart';
import 'package:bloc_yapisi/src/elements/pageLoading.dart';
import 'package:bloc_yapisi/src/pages/list.dart';
import 'package:bloc_yapisi/src/repositories/auth_repository.dart';
import 'package:bloc_yapisi/src/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/login_tab.dart';
import '../widgets/reset_password.dart';
import '../widgets/signup_tab.dart';

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
                    buildLoginTab(context),
                    buildSignUpTab(context),
                    buildResetPasswordTab(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
