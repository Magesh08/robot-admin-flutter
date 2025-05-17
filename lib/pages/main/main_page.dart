// lib/pages/main_page/main_page.dart
import 'package:admin_app_flutter/pages/Robot_Slots/robot_slots.dart';
import 'package:admin_app_flutter/pages/Robot_Tray/robot_tray.dart';
import 'package:flutter/material.dart';
import 'package:admin_app_flutter/auth/auth_service.dart';
import 'package:admin_app_flutter/pages/login_page/login_page.dart';

class MainPage extends StatefulWidget {
  final String userName;

  const MainPage({super.key, required this.userName});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String selectedOption = 'Slots';

  final List<String> robotOptions = [
    'Slots',
    'Tray',
    'Retrieve Tray',
    'Remove Tray',
    'Update Slots',
    'Release Tray',
    'Map Tray',
    'Add Tray',
    'Picking Stations',
  ];

  void logout(BuildContext context) async {
    await AuthService().clearToken();
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  Widget _getContent() {
    switch (selectedOption) {
      case 'Slots':
        return const RobotSlots();
      case 'Tray':
        return const RobotTray();
      default:
        return Center(child: Text('$selectedOption coming soon...'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${widget.userName}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: robotOptions.length,
              itemBuilder: (context, index) {
                final option = robotOptions[index];
                final isSelected = option == selectedOption;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => selectedOption = option);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSelected ? Colors.blue : Colors.grey[300],
                      foregroundColor: isSelected ? Colors.white : Colors.black,
                    ),
                    child: Text(option),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(child: _getContent()),
        ],
      ),
    );
  }
}
