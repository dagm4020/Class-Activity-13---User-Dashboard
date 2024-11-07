import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final AuthService authService;

  HomeScreen({Key? key, required this.authService}) : super(key: key);

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(authService: authService),
      ),
    );
  }

  String _getUserName() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      String email = user.email!;
      String namePart = email.split('@')[0];
      if (namePart.isNotEmpty) {
        String firstChar = namePart[0];
        if (RegExp(r'[A-Za-z]').hasMatch(firstChar)) {
          firstChar = firstChar.toUpperCase();
          namePart = firstChar + namePart.substring(1);
        }
      }
      return namePart;
    }
    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    String userName = _getUserName();

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        leading: IconButton(
          icon: Icon(Icons.person),
          tooltip: 'Profile',
          onPressed: () => _navigateToProfile(context),
        ),
      ),
      body: Center(
        child: Text(
          'Welcome, $userName!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
