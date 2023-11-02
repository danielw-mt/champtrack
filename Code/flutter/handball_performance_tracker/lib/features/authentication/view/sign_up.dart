import 'package:handball_performance_tracker/features/authentication/authentication.dart';
import 'package:handball_performance_tracker/features/dashboard/dashboard.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _clubNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.height;

    AuthBloc authBloc = context.watch<AuthBloc>();
    if (authBloc.state.authStatus == AuthStatus.AuthError) {
      // Display error message in a dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(StringsAuth.lSignUpError),
            content: Text(authBloc.state.error!),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(StringsAuth.lOk),
              ),
            ],
          ),
        ).then((value) => authBloc..add(DisplayError()));
      });
    }

    return Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.Authenticated) {
          // Navigating to the dashboard screen if the user is authenticated
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const DashboardView(),
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
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
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: Colors.grey.shade800),
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
              validator: (value) {
                return value != null && !EmailValidator.validate(value)
                    ? StringsAuth.lInvalidEmail
                    : null;
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  return value != null && value.length < 6
                      ? StringsAuth.lMin6Chars
                      : null;
                }),
          );
          var clubField = Container(
            height: height * 0.1,
            padding: const EdgeInsets.all(10),
            child: TextFormField(
                keyboardType: TextInputType.name,
                controller: _clubNameController,
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  return value != null && value.length < 4
                      ? StringsAuth.lMin6Chars
                      : null;
                }),
          );
          if (state.authStatus == AuthStatus.Loading) {
            // Displaying the loading indicator while the user is signing up
            return const Center(child: CircularProgressIndicator());
          }
          if (state.authStatus == AuthStatus.UnAuthenticated ||
              state.authStatus == AuthStatus.AuthError) {
            // Displaying the sign up form if the user is not authenticated
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child:
                                  ListView(shrinkWrap: true, children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  child: new Image.asset(
                                    height: height * 0.2,
                                    "files/Intercep_Logo.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: 0.5 * width,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 20, 10, 0),
                                              child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<
                                                                  Color>(
                                                              buttonLightBlueColor)),
                                                  child: Text(
                                                      StringsAuth.lSignUpButton,
                                                      style: TextStyle(
                                                          fontSize:
                                                              height / 100 * 2,
                                                          color: Colors.black)),
                                                  onPressed: () {
                                                    _createAccountWithEmailAndPassword(
                                                        context);
                                                  })),
                                          Row(
                                            children: <Widget>[
                                              const Text(
                                                  StringsAuth.lAccountExists),
                                              TextButton(
                                                  child: Text(
                                                    StringsAuth
                                                        .lBackToSignInButton,
                                                    style: TextStyle(
                                                        fontSize:
                                                            height / 100 * 2,
                                                        color:
                                                            buttonDarkBlueColor),
                                                  ),
                                                  onPressed: (() => Navigator
                                                              .pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        SignIn()),
                                                          ) // switch back to sign in mode
                                                      ))
                                            ],
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                          ),
                                        ]),
                                  ),
                                )
                              ]),
                            )),
                      ),

                      // const Text("Or"),
                      // IconButton(
                      //   onPressed: () {
                      //     _authenticateWithGoogle(context);
                      //   },
                      //   icon: Image.network(
                      //     "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png",
                      //     height: 30,
                      //     width: 30,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    ));
  }

  void _createAccountWithEmailAndPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      print("form validated");
      BlocProvider.of<AuthBloc>(context).add(
        SignUpRequested(
          _clubNameController.text,
          _emailController.text,
          _passwordController.text,
        ),
      );
      
    }
  }

  // void _authenticateWithGoogle(context) {
  //   BlocProvider.of<AuthBloc>(context).add(
  //     GoogleSignInRequested(),
  //   );
  // }
}
