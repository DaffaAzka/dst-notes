import 'package:dstnotes/constants/routes.dart';
import 'package:dstnotes/views/homepage_view.dart';
import 'package:dstnotes/views/login_view.dart';
import 'package:dstnotes/views/register_view.dart';
import 'package:dstnotes/views/verify_email_view.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dst Notes',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const Homepage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    );
  }
}
