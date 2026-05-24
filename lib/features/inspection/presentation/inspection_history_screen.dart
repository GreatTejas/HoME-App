import 'package:flutter/material.dart';

class InspectionHistoryScreen extends StatelessWidget {
  const InspectionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data matching your 'inspections' table
    final mockInspections = [
      {'id': '1', 'room': '101', 'date': 'Today, 10:00 AM', 'status': 'complete'},
      {'id': '2', 'room': '102', 'date': 'Yesterday', 'status': 'complete'},
      {'id': '3', 'room': '205', 'date': 'May 20', 'status': 'pending'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Inspection Log')),
      body: ListView.separated(
        itemCount: mockInspections.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final insp = mockInspections[index];
          final isComplete = insp['status'] == 'complete';

          return ListTile(
            leading: const Icon(Icons.assignment_turned_in_outlined),
            title: Text('Room ${insp['room']}'),
            subtitle: Text('Date: ${insp['date']}'),
            trailing: Chip(
              label: Text(isComplete ? 'Complete' : 'Pending'),
              backgroundColor: isComplete ? Colors.green.shade100 : Colors.orange.shade100,
              labelStyle: TextStyle(color: isComplete ? Colors.green.shade900 : Colors.orange.shade900),
            ),
          );
        },
      ),
    );
  }
}
