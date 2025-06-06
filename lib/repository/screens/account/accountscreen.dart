import 'package:flutter/material.dart';
import 'package:houzy/repository/screens/bottomnav/bottomnavscreen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  void _navigateToTab(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const BottomNavScreen(initialIndex: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        backgroundColor: const Color(0xFFF54A00),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _navigateToTab(context),
          child: const Text("Go to Account Tab (Again)"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // You can also trigger navigation here if needed:
          // _navigateToTab(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFFF54A00),
      ),
    );
  }
}
