import 'package:Mynotes/services/auth/auth_service.dart';
import 'package:Mynotes/views/login_view.dart';
import 'package:Mynotes/views/notes_view.dart';
import 'package:Mynotes/views/register_view.dart';
import 'package:Mynotes/constants/routes.dart';
import 'package:Mynotes/views/verify_email_view.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        notesRoute: (context) => const Notes_View_State(),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                print('Email verified');
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
            return const Notes_View_State();
          default:
            return const CircularProgressIndicator(strokeWidth: 25,);
        }
      },
    );
  }
}

