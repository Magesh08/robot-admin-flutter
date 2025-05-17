// lib/widgets/robot_slots.dart
import 'package:flutter/material.dart';
import 'package:admin_app_flutter/api/api_service.dart';

class RobotSlots extends StatefulWidget {
  const RobotSlots({super.key});

  @override
  State<RobotSlots> createState() => _RobotSlotsState();
}

class _RobotSlotsState extends State<RobotSlots> {
  final ApiService _apiService = ApiService();
  final ScrollController _scrollController = ScrollController();
  List<dynamic> slots = [];
  int offset = 0;
  final int numRecords = 10;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    fetchSlots();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        fetchSlots();
      }
    });
  }

  Future<void> fetchSlots() async {
    if (isLoading || !hasMore) return;
    setState(() => isLoading = true);

    final response = await _apiService.fetchSlots(
      offset: offset,
      numRecords: numRecords,
    );

    if (response['status'] == 'success' && response['records'] != null) {
      final newSlots = response['records'];
      setState(() {
        slots.addAll(newSlots);
        offset += numRecords;
        hasMore = newSlots.length == numRecords;
      });
    } else {
      setState(() => hasMore = false);
    }

    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: slots.length + 1,
      itemBuilder: (context, index) {
        if (index < slots.length) {
          final slot = slots[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text('Slot ID: ${slot['slot_id'] ?? 'N/A'}'),
              subtitle: Text(
                'Tray: ${slot['tray_id'] ?? 'No Tray'} | Status: ${slot['slot_status']}',
              ),
            ),
          );
        } else if (hasMore) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: Text('No more slots')),
          );
        }
      },
    );
  }
}
