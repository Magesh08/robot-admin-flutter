import 'package:admin_app_flutter/api/api_service.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'dart:convert';

class RobotTray extends StatefulWidget {
  const RobotTray({super.key});

  @override
  State<RobotTray> createState() => _RobotTrayState();
}

class _RobotTrayState extends State<RobotTray> {
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();

  final int numRecords = 20;
  int offset = 0;
  List<Map<String, dynamic>> trays = [];
  bool hasMore = true;
  bool isLoading = false;
  int totalTrayCount = 0;

  @override
  void initState() {
    super.initState();
    fetchTrays();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        fetchTrays();
      }
    });
  }

  Future<void> fetchTrays() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    final response = await _apiService.fetchTrays(
      offset: offset,
      numRecords: numRecords,
    );

    if (response['status'] == 'success' && response['records'] != null) {
      final newTrays = List<Map<String, dynamic>>.from(response['records']);

      setState(() {
        trays.addAll(newTrays);
        offset += numRecords;
        hasMore = newTrays.length == numRecords;
        totalTrayCount = response['total_count'] ?? trays.length;
      });
    } else {
      debugPrint(
        'Failed to load trays: ${response['message'] ?? 'Unknown error'}',
      );
    }

    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildTrayCard(Map<String, dynamic> tray) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text('Tray ID: ${tray['tray_id'] ?? 'N/A'}'),
        subtitle: Text(
          'Weight: ${tray['tray_weight'] ?? 'N/A'} g\n'
          'Height: ${tray['tray_height'] ?? 'N/A'} mm\n'
          'Updated At: ${tray['updated_at'] ?? 'N/A'}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'Total Trays: $totalTrayCount',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: trays.length + 1,
            itemBuilder: (context, index) {
              if (index < trays.length) {
                return buildTrayCard(trays[index]);
              } else if (hasMore) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: Text('No more trays')),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
