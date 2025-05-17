import 'package:admin_app_flutter/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:admin_app_flutter/api/api_service.dart';
import 'package:admin_app_flutter/pages/main/main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final apiService = ApiService();
  final authService = AuthService();
  String? errorMessage;
  final phoneFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  void login() async {
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    final response = await apiService.loginUser(phone, password);

    if (response['status'] == 'success') {
      await authService.saveToken(response['token']);

      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (_) => MainPage(userName: response['user_name']),
        ),
      );
    } else {
      _showErrorDialog(response['message'] ?? 'Login failed');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Login Failed'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              focusNode: phoneFocusNode,
              decoration: InputDecoration(labelText: 'Phone'),
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(passwordFocusNode);
              },
            ),
            TextField(
              controller: passwordController,
              focusNode: passwordFocusNode,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text("Login")),
            if (errorMessage != null) ...[
              SizedBox(height: 10),
              Text(errorMessage!, style: TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
