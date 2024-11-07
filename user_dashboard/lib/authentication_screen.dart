import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'registration.dart';
import 'sign_in.dart';

class AuthenticationScreen extends StatefulWidget {
  final AuthService authService;

  AuthenticationScreen({Key? key, required this.authService}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

enum AuthMode { signIn, register }

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  AuthMode _authMode = AuthMode.signIn;

  void _toggleAuthMode() {
    setState(() {
      _authMode =
          _authMode == AuthMode.signIn ? AuthMode.register : AuthMode.signIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Auth Demo'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _authMode == AuthMode.signIn
                  ? SignIn(
                      authService: widget.authService,
                      onAuthSuccess: () {},
                    )
                  : Registration(
                      authService: widget.authService,
                      onRegistrationSuccess: () {},
                    ),
              SizedBox(height: 20),
              TextButton(
                onPressed: _toggleAuthMode,
                child: Text(
                  _authMode == AuthMode.signIn
                      ? 'Don\'t have an account? Register'
                      : 'Already have an account? Sign In',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
