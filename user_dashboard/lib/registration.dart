import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Registration extends StatefulWidget {
  final AuthService authService;
  final VoidCallback? onRegistrationSuccess;

  Registration(
      {Key? key, required this.authService, this.onRegistrationSuccess})
      : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await widget.authService.registerWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        await widget.authService.signOut();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Registration successful! Please sign in.'),
          backgroundColor: Colors.green,
        ));

        _formKey.currentState!.reset();
      } on FirebaseAuthException catch (e) {
        String message = '';
        switch (e.code) {
          case 'email-already-in-use':
            message = 'The email address is already in use.';
            break;
          case 'invalid-email':
            message = 'The email address is invalid.';
            break;
          case 'operation-not-allowed':
            message = 'Email/password accounts are not enabled.';
            break;
          case 'weak-password':
            message = 'The password is too weak.';
            break;
          default:
            message = 'An undefined Error happened.';
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An unexpected error occurred.'),
          backgroundColor: Colors.red,
        ));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Register',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password should be at least 6 characters';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Center(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      child: Text('Register'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
