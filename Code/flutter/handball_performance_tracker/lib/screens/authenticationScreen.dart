import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AuthenticationScreen extends StatefulWidget {
  final BuildContext context;
  const AuthenticationScreen({Key? key, required this.context})
      : super(key: key);
  @override
  State<AuthenticationScreen> createState() =>
      _AuthenticationScreenState(context: context);
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final BuildContext context;
  _AuthenticationScreenState({required this.context});
  bool isLogin = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
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
            isLogin
                ? TextButton(
                    onPressed: onClickedSignUp,
                    child: Text("Sign up"),
                  )
                : Container()
          ]),
        ),
      );
    }
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
          ElevatedButton(onPressed: signUp, child: Text("Sign Up")),
          isLogin
              ? Container()
              : TextButton(
                  onPressed: onClickedSignUp,
                  child: Text("Log in"),
                )
        ]),
      ),
    );
  }

  Future signIn() async {
    // show an indication that user is signing in
    Alert loadingAlert = Alert(
        context: context,
        content: Column(
          children: [
            Text("Logging in"),
            CircularProgressIndicator(),
          ],
        ),
        buttons: []);
    loadingAlert.show();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      // pop the indicator after account has been created
      loadingAlert.dismiss();
    } on FirebaseAuthException catch (e) {
      loadingAlert.dismiss();
      Alert(context: context, content: Text(e.message.toString())).show();
      // pop alert once it sign in is completed
      
    }
  }

  Future signUp() async {
    // show an indication that user is signing up
    Alert loadingAlert = Alert(
        context: context,
        content: Column(
          children: [
            Text("Signing up"),
            CircularProgressIndicator(),
          ],
        ),
        buttons: []);
    loadingAlert.show();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      // pop the indicator after account has been created
      loadingAlert.dismiss();
    } on FirebaseAuthException catch (e) {
      loadingAlert.dismiss();
      Alert(context: context, content: Text(e.message.toString())).show();
      
    }
  }

  void onClickedSignUp() {
    setState(() {
      isLogin = !isLogin;
    });
  }
}
