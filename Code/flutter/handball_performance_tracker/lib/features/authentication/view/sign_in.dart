import 'package:handball_performance_tracker/features/authentication/authentication.dart';
import 'package:handball_performance_tracker/features/dashboard/dashboard.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.height;
    AuthState authState = context.watch<AuthBloc>().state;
    if (authState.authStatus == AuthStatus.AuthError) {
      // Display error message in a dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(StringsAuth.lSignUpError),
            content: Text(authState.error!),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(StringsAuth.lOk),
              ),
            ],
          ),
        );
      });
    }
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.authStatus == AuthStatus.Authenticated) {
            // Navigating to the dashboard screen if the user is authenticated
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardView()));
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.authStatus == AuthStatus.Loading) {
              // Showing the loading indicator while the user is signing in
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.authStatus == AuthStatus.UnAuthenticated || state.authStatus == AuthStatus.AuthError) {
              List<Widget> loginHeader = [
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      StringsAuth.lAppTitle,
                      style: TextStyle(color: buttonDarkBlueColor, fontSize: height / 100 * 3, fontWeight: FontWeight.bold),
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
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.grey.shade800),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: buttonGreyColor)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: buttonGreyColor)),
                      disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: buttonGreyColor)),
                      labelStyle: TextStyle(color: Colors.grey.shade800),
                      labelText: StringsAuth.lEmail,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      filled: true,
                      fillColor: buttonGreyColor),
                  validator: (value) {
                    return value != null && !EmailValidator.validate(value) ? StringsAuth.lInvalidEmail : null;
                  },
                ),
              );
              var passwordField = Container(
                height: height * 0.1,
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: buttonGreyColor)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: buttonGreyColor)),
                        disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: buttonGreyColor)),
                        labelStyle: TextStyle(color: Colors.grey.shade800),
                        labelText: StringsAuth.lPassword,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: buttonGreyColor),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return value != null && value.length < 6 ? StringsAuth.lMin6Chars : null;
                    }),
              );

              // Showing the sign in form if the user is not authenticated
              return Form(
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          child: new Image.asset(
                            "files/Intercep_Logo.png",
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
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(buttonLightBlueColor)),
                                        child: Text(StringsAuth.lSignInButton, style: TextStyle(fontSize: height / 100 * 2, color: Colors.black)),
                                        onPressed: () {
                                          _authenticateWithEmailAndPassword(context);
                                        })),
                                TextButton(
                                  onPressed: () {
                                    // TODO implement reset screen
                                  },
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
                                          style: TextStyle(fontSize: height / 100 * 2, color: buttonDarkBlueColor),
                                        ),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => const SignUp()),
                                          );
                                        } // switch to sign up mode
                                        )
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  void _authenticateWithEmailAndPassword(context) {
    print("authenticating");
    if (_formKey.currentState!.validate()) {
      print("form validated");
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(_emailController.text, _passwordController.text),
      );
    }
  }
}
