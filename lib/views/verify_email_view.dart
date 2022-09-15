import 'package:dstnotes/constants/routes.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Center(
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                "We have sent you a verification email, please check it in your email box"),
          ),
          ElevatedButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text("Send email again")),
          ElevatedButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                // ignore: use_build_context_synchronously
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text("Restart"))
        ]),
      ),
    );
  }
}
