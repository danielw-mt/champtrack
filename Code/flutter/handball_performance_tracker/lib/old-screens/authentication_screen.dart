import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/old-widgets/authentication_screen/login_widget.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);
  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: LoginWidget()));
  }
}
