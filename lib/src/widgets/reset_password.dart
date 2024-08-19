import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/loginBLoC/auth_bloc.dart';
import 'package:aractakip2/src/blocs/loginBLoC/auth_event.dart';
import 'package:aractakip2/src/blocs/loginBLoC/auth_state.dart';
import '../elements/pageLoading.dart';

Widget buildResetPasswordTab(BuildContext context) {
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
            fillColor: Colors.white,
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
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4a4b65)
              ),
              child: const Text('Şifreyi Sıfırla',style: TextStyle(color: Colors.white)),
            );
          },
        ),
      ],
    ),
  );
}