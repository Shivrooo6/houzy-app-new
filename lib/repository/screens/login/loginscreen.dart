import 'package:flutter/material.dart';
import 'package:houzy/repository/screens/bottomnav/bottomnavscreen.dart';
import 'package:houzy/repository/widgets/uihelper.dart';
import 'package:houzy/screens/userauth/firebaseauthservices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _employeePasswordController = TextEditingController();

  bool _isLoading = false;
  bool isCustomer = true;

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Google Sign-In failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleEmployeeLogin() async {
    final id = _employeeIdController.text.trim();
    final pass = _employeePasswordController.text.trim();

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('employees')
          .doc(id)
          .get();

      if (snapshot.exists) {
        String savedPass = snapshot.get('password');

        if (savedPass == pass) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Incorrect password")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Employee ID not found")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  void _handleForgotPassword() {
    String empId = '';
    String newPassword = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => empId = value.trim(),
              decoration: const InputDecoration(labelText: 'Employee ID'),
            ),
            TextField(
              onChanged: (value) => newPassword = value.trim(),
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (empId.isNotEmpty && newPassword.isNotEmpty) {
                try {
                  await FirebaseFirestore.instance
                      .collection('employees')
                      .doc(empId)
                      .set({'password': newPassword}, SetOptions(merge: true));

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password updated successfully")),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${e.toString()}")),
                  );
                }
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    UiHelper.CustomImage(img: "houzylogoimage.png", height: 80, width: null),
                    const Positioned(
                      top: -2,
                      left: 12,
                      child: Icon(Icons.star, color: Colors.orange, size: 18),
                    ),
                    const Positioned(
                      top: -3,
                      right: 20,
                      child: Icon(Icons.star, color: Colors.amber, size: 20),
                    ),
                    const Positioned(
                      bottom: 0,
                      left: 0,
                      child: Icon(Icons.star, color: Colors.amberAccent, size: 16),
                    ),
                    const Positioned(
                      bottom: 0,
                      right: 10,
                      child: Icon(Icons.star, color: Colors.orange, size: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                UiHelper.CustomText(
                  text: "Professional House Cleaning Service",
                  color: const Color(0xFFFE600E),
                  fontweight: FontWeight.bold,
                  fontsize: 11,
                  fontfamily: "bold",
                ),
                const SizedBox(height: 10),

                // New Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => setState(() => isCustomer = true),
                      child: const Text("Customer"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCustomer ? Colors.orange : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => setState(() => isCustomer = false),
                      child: const Text("Employee"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !isCustomer ? Colors.orange : Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0XFFe7dfdd),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Center(
                            child: UiHelper.CustomText(
                              text: "Login",
                              color: Colors.black,
                              fontweight: FontWeight.w500,
                              fontsize: 32,
                              fontfamily: "bold",
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 200,
                            child: Align(
                              alignment: const Alignment(0.1, 0.0),
                              child: Transform.translate(
                                offset: const Offset(15, 0),
                                child: UiHelper.CustomImage(img: "loginsvg.png", height: null, width: null),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          if (isCustomer) ...[
                            SizedBox(
                              height: 48,
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _isLoading ? null : _signInWithGoogle,
                                icon: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Image.asset('assets/images/googleicon.png'),
                                ),
                                label: _isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text(
                                  "Sign in with Google",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 2,
                                ),
                              ),
                            ),
                          ] else ...[
                            TextField(
                              controller: _employeeIdController,
                              decoration: const InputDecoration(labelText: "Employee ID"),
                            ),
                            TextField(
                              controller: _employeePasswordController,
                              decoration: const InputDecoration(labelText: "Password"),
                              obscureText: true,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _handleForgotPassword,
                                child: const Text("Forgot Password?"),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _handleEmployeeLogin,
                              child: const Text("Login"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text.rich(
                                TextSpan(
                                  text: 'By continuing, you agree to our ',
                                  style: const TextStyle(fontSize: 12),
                                  children: [
                                    TextSpan(
                                      text: 'T&C',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const TextSpan(text: ' policy.'),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
