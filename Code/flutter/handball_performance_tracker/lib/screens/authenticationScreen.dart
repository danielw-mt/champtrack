import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AuthenticationScreen extends StatefulWidget {
  final BuildContext context;
  const AuthenticationScreen({Key? key, required this.context}) : super(key: key);
  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState(context: context);
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController(); 
  final BuildContext context;
  _AuthenticationScreenState({required this.context});

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            height: 40,
          ),
          TextField(
            controller: emailController,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(
            height: 4,
          ),
          TextField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            obscureText: true,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(onPressed: signIn, child: Text("Sign in")),
        ]),
      ),
    );
  }

  Future signIn() async {
    Alert alert = Alert(context: context, content: Column(
      children: [
        Text("Logging in"),
        CircularProgressIndicator(),
      ],
    ), buttons: []);
    alert.show();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());  
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    alert.dismiss(); 
  }
}
