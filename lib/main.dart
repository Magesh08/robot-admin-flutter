import 'package:admin_app_flutter/auth/auth_service.dart';
import 'package:admin_app_flutter/pages/login_page/login_page.dart';
import 'package:admin_app_flutter/pages/main/main_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final authService = AuthService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<String?>(
        future: authService.getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.data != null) {
            return MainPage(
              userName: 'User',
            ); // Customize with stored name if needed
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
