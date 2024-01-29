import 'package:Mynotes/constants/routes.dart';
import 'package:Mynotes/services/auth/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(appBar: AppBar(
      title: Text('Verify Email'),backgroundColor: Colors.teal,foregroundColor: Colors.white,),
      body: Column(children: [
        const Text("We've sent you an email verification, please verify your account"),
        const Text("If you havent't received a verification email yet, press Send email verification"),
        Text('Please verify email address first'),
        TextButton(onPressed: () async{
          final user = AuthService.firebase().currentUser;
          await AuthService.firebase().sendEmailVerification();
        }, child: const Text('Send email Verification')),
        TextButton(onPressed: () async{
          await AuthService.firebase().logout();
          Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
        }, child: Text('Go back to login')),
      ],
      ),
    );
  }
}