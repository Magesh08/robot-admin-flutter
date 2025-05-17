import 'package:flutter/material.dart';
import 'package:admin_app_flutter/pages/Robot_Slots/robot_slots.dart';
import 'package:admin_app_flutter/pages/Robot_Tray/robot_tray.dart';
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Welcome, ${widget.userName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    robotOptions.map((option) {
                      final isSelected = option == selectedOption;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => selectedOption = option);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: isSelected ? 3 : 0,
                            backgroundColor:
                                isSelected ? theme.primaryColor : Colors.white,
                            foregroundColor:
                                isSelected ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color:
                                    isSelected
                                        ? theme.primaryColor
                                        : Colors.grey.shade300,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: Text(option),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _getContent(),
            ),
          ),
        ],
      ),
    );
  }
}
