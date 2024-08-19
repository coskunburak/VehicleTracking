import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/loginBLoC/auth_bloc.dart';
import 'package:aractakip2/src/blocs/loginBLoC/auth_event.dart';
import 'package:aractakip2/src/blocs/loginBLoC/auth_state.dart';
import '../elements/pageLoading.dart';

Widget buildLoginTab(BuildContext context) {
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
            fillColor: Colors.white,
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
            fillColor: Colors.white,
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4a4b65)
                ),
              child: const Text('Giriş Yap',style: TextStyle(color: Colors.white),),
            );
          },
        ),
      ],
    ),
  );
}