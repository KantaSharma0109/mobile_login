import 'package:flutter/material.dart';
import 'package:mobile_login/controllers/auth_service.dart';
import 'package:mobile_login/pages/login_page.dart';
import 'package:mobile_login/pages/customer_page.dart';

class HomePage extends StatelessWidget {
  // const HomePage({super.key});

  final String? userId;

  const HomePage({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'User ID: ${userId ?? "No user ID"}', // Display the user ID
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Welcome user to this app"),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
                onPressed: () {
                  AuthService.logout();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: const Text("Logout")),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomerPage(userId: userId)),
                );
              },
              child: const Text('Customer Page'),
            ),
          ],
        ),
      ),
    );
  }
}
