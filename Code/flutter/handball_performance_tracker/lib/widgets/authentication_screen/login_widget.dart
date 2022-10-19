import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import 'package:handball_performance_tracker/constants/stringsAuthentication.dart';
import 'package:handball_performance_tracker/widgets/authentication_screen/alert_widget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../data/database_repository.dart';
import '../../controllers/persistent_controller.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  PersistentController persistentController = PersistentController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController clubNameController = TextEditingController();
  bool isLogin = true;
  bool isReset = false;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.height;
    List<Widget> loginHeader = [
      Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: Text(
            StringsAuth.lAppTitle,
            style: TextStyle(
                color: buttonDarkBlueColor,
                fontSize: height / 100 * 3,
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
            style: TextStyle(color: buttonDarkBlueColor, fontSize: 30),
          )),
    ];
    var eMailField = Container(
      height: height * 0.1,
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: emailController,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.grey.shade800),
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: buttonGreyColor)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: buttonGreyColor)),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: buttonGreyColor)),
            labelStyle: TextStyle(color: Colors.grey.shade800),
            labelText: StringsAuth.lEmail,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: buttonGreyColor),
      ),
    );
    var passwordField = Container(
      height: height * 0.1,
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: true,
        controller: passwordController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: buttonGreyColor)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: buttonGreyColor)),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: buttonGreyColor)),
            labelStyle: TextStyle(color: Colors.grey.shade800),
            labelText: StringsAuth.lPassword,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: buttonGreyColor),
      ),
    );
    var clubField = Container(
      height: height * 0.1,
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: false,
        controller: clubNameController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: buttonGreyColor)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: buttonGreyColor)),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: buttonGreyColor)),
            labelStyle: TextStyle(color: Colors.grey.shade800),
            labelText: StringsAuth.lClubName,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: buttonGreyColor),
      ),
    );
    if (isReset) {
      // password reset mode
      return Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: new Image.asset(
                  "images/champtrack_logo.png",
                  height: height * 0.2,
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
                      loginHeader[0],
                      loginHeader[1],
                      loginHeader[2],
                      eMailField,
                      Container(
                          height: 70,
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          buttonLightBlueColor)),
                              child: Text(StringsAuth.lResetPassword,
                                  style: TextStyle(
                                      fontSize: height / 100 * 2,
                                      color: Colors.black)),
                              onPressed: sendPasswordResetEmail)),
                      Row(
                        children: <Widget>[
                          TextButton(
                            child: Text(
                              StringsAuth.lBackToSignInButton,
                              style: TextStyle(
                                  fontSize: height / 100 * 2,
                                  color: buttonDarkBlueColor),
                            ),
                            onPressed: onClickedReset, // deactivate reset mode
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
    } else if (isLogin) {
      // sign in mode (default)
      return Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: new Image.asset(
                  "images/champtrack_logo.png",
                  height: height * 0.2,
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
                      loginHeader[0],
                      loginHeader[1],
                      loginHeader[2],
                      eMailField,
                      passwordField,
                      Container(
                          width: 0.5 * width,
                          height: 70,
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          buttonLightBlueColor)),
                              child: Text(StringsAuth.lSignInButton,
                                  style: TextStyle(
                                      fontSize: height / 100 * 2,
                                      color: Colors.black)),
                              onPressed: signIn)),
                      TextButton(
                        onPressed: onClickedReset,
                        child: Text(
                          StringsAuth.lForgotPassword,
                          style: TextStyle(color: buttonDarkBlueColor),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          const Text(StringsAuth.lNoAccount),
                          TextButton(
                              child: Text(
                                StringsAuth.lSignUpButton,
                                style: TextStyle(
                                    fontSize: height / 100 * 2,
                                    color: buttonDarkBlueColor),
                              ),
                              onPressed:
                                  onClickedSignUp // switch to sign up mode
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
      // sign up mode
    } else {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: new Image.asset(
              height: height * 0.2,
              "images/champtrack_logo.png",
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
                    loginHeader[0],
                    loginHeader[1],
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          StringsAuth.lSignUpButton,
                          style: TextStyle(
                              color: buttonDarkBlueColor,
                              fontSize: height / 100 * 3),
                        )),
                    clubField,
                    eMailField,
                    passwordField,
                    Container(
                        height: height * 0.1,
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        buttonLightBlueColor)),
                            child: Text(StringsAuth.lSignUpButton,
                                style: TextStyle(
                                    fontSize: height / 100 * 2,
                                    color: Colors.black)),
                            onPressed: signUp)),
                    Row(
                      children: <Widget>[
                        TextButton(
                            child: Text(
                              StringsAuth.lBackToSignInButton,
                              style: TextStyle(
                                  fontSize: height / 100 * 2,
                                  color: buttonDarkBlueColor),
                            ),
                            onPressed:
                                onClickedSignUp // switch back to sign in mode
                            )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ]),
            ),
          )
        ]),
      );
    }
  }

  Future signIn() async {
    // show an indication that user is signing in
    Alert loadingAlert = Alert(
        context: context,
        buttons: [],
        content: CustomAlertWidget(StringsAuth.lLoggingIn));

    loadingAlert.show();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      // pop the indicator after account has been created
      loadingAlert.dismiss();
    } on FirebaseAuthException catch (e) {
      loadingAlert.dismiss();
      Alert(
              context: context,
              buttons: [],
              content: Text(e.message.toString(),
                  style: TextStyle(color: Colors.grey.shade800)),
              style: AlertStyle(backgroundColor: buttonLightBlueColor))
          .show();
      // pop alert once it sign in is completed

    }
  }

  Future signUp() async {
    DatabaseRepository repository = persistentController.repository;
    // show an indication that user is signing up
    Alert loadingAlert = Alert(
        context: context,
        buttons: [],
        content: CustomAlertWidget(StringsAuth.lSigningUp));

    loadingAlert.show();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      repository.createClub(clubNameController.text.trim());
      loadingAlert.dismiss();
      // pop the indicator after account has been created
    } on FirebaseAuthException catch (e) {
      await loadingAlert.dismiss();
      Alert(
              context: context,
              buttons: [],
              content: Text(e.message.toString(),
                  style: TextStyle(color: Colors.grey.shade800)),
              style: AlertStyle(backgroundColor: buttonLightBlueColor))
          .show();
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
      print(isReset);
    });
  }

  void sendPasswordResetEmail() async {
    // show an indication that user is signing up
    Alert loadingAlert = Alert(
        context: context,
        buttons: [],
        content: CustomAlertWidget(StringsAuth.lLoggingIn));
    loadingAlert.show();
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      loadingAlert.dismiss();
    } on FirebaseAuthException catch (e) {
      loadingAlert.dismiss();
      Alert(
              context: context,
              buttons: [],
              content: Text(e.message.toString(),
                  style: TextStyle(color: Colors.grey.shade800)),
              style: AlertStyle(backgroundColor: buttonLightBlueColor))
          .show();
    }
    onClickedReset();
  }
}
