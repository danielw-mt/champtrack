import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import 'package:handball_performance_tracker/constants/stringsAuthentication.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.height;
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: new Image.asset(
                "assets/champtrack_logo.png",
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                width: 0.5 * width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          StringsAuth.lAppTitle,
                          style: TextStyle(
                              color: buttonDarkBlueColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          StringsAuth.lLogInButton,
                          style: TextStyle(
                              color: buttonDarkBlueColor, fontSize: 30),
                        )),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: StringsAuth.lEmail,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: StringsAuth.lPassword,
                        ),
                      ),
                    ),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          child: const Text(StringsAuth.lSignInButton),
                          onPressed: () {
                            print(emailController.text);
                            print(passwordController.text);
                          },
                        )),
                    TextButton(
                      onPressed: () {
                        //forgot password screen
                      },
                      child: const Text(
                        StringsAuth.lForgotPassword,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        const Text(StringsAuth.lNoAccount),
                        TextButton(
                          child: const Text(
                            StringsAuth.lSignUpButton,
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            //signup screen
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  Future signIn() async {
    // show an indication that user is signing in
    var progress = Alert(
      context: context,
      content: Container(
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          color: Colors.white70,
        ),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blue[200],
              borderRadius: BorderRadius.circular(10.0)),
          width: 300.0,
          height: 200.0,
          alignment: AlignmentDirectional.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: CircularProgressIndicator(
                    value: null,
                    strokeWidth: 7.0,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25.0),
                child: Center(
                  child: Text(
                    "loading.. wait...",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Alert loadingAlert = Alert(
        context: context,
        content: Column(
          children: [
            Text(StringsAuth.lLoggingIn),
            CircularProgressIndicator(color: buttonDarkBlueColor),
          ],
        ),
        buttons: []);

    progress.show();
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
            Text(StringsAuth.lSigningUp),
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
    // switch to sign up view
    setState(() {
      isLogin = !isLogin;
    });
  }

  void onClickedReset() {
    // switch to password reset view
    setState(() {
      isReset = !isReset;
    });
  }

  void sendPasswordResetEmail() async {
    // show an indication that user is signing up
    Alert loadingAlert = Alert(
        context: context,
        content: Column(
          children: [
            Text(StringsAuth.lSendingResetMail),
            CircularProgressIndicator(),
          ],
        ),
        buttons: []);
    loadingAlert.show();
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      loadingAlert.dismiss();
    } on FirebaseAuthException catch (e) {
      loadingAlert.dismiss();
      Alert(context: context, content: Text(e.message.toString())).show();
    }
    onClickedReset();
  }
}
