import 'package:dstnotes/constants/routes.dart';
import 'package:dstnotes/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Email"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Password"),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email, password: password);
                  final user = await FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                } on FirebaseAuthException catch (e) {
                  if (e.code == "weak-password") {
                    await showErrorDialog(context, "Weak password");
                  } else if (e.code == "email-already-in-use") {
                    await showErrorDialog(context, "Email already in use");
                  } else if (e.code == "invalid-email") {
                    await showErrorDialog(context, "Invalid email address");
                  } else {
                    await showErrorDialog(context, "Error: ${e.code}");
                  }
                } catch (e) {
                  showErrorDialog(context, "Error: ${e.toString()}");
                }
              },
              child: const Text("Register")),
          Padding(
              padding: const EdgeInsets.all(2),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  },
                  child: const Text("Already register? Login here!")))
        ],
      ),
    );
  }
}
