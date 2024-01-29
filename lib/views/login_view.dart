import 'package:Mynotes/constants/routes.dart';
import 'package:Mynotes/services/auth/auth_service.dart';
import 'package:Mynotes/utilities/showdialogerror.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import '../services/auth/auth_exceptions.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Login'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            enableSuggestions: false,
            decoration:
                const InputDecoration(hintText: "Enter your email here"),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "Enter your password "),
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase().login(
                      email: email, password: password);

                  final user= AuthService.firebase().currentUser;
                  if (user?.isEmailVerified ?? false){
                    Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                  }else{
                    Navigator.of(context).pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
                  }

                } on UserNotFoundAuthException{
                  await showErrorDialog(context, ('User not Found'));
                } on WrongPasswordAuthException{
                  await showErrorDialog(context, ('Wrong password'));
                } on GenericAuthException{
                  await showErrorDialog(context, 'Authentication Error',);
                }
              },
              child: const Text('Login')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: Text('Not registered yet? Register now fam!'),
          )
        ],
      ),
    );
  }
}

