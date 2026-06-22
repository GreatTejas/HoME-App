import 'package:flutter/material.dart';
import '../../../core/api/api_client.dart';

class InspectionHistoryScreen extends StatefulWidget {
  const InspectionHistoryScreen({super.key});

  @override
  State<InspectionHistoryScreen> createState() =>
      _InspectionHistoryScreenState();
}

class _InspectionHistoryScreenState extends State<InspectionHistoryScreen> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchInspections();
  }

  Future<void> _fetchInspections() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await ApiClient.instance.get('/api/storage-items');
      setState(() {
        _items = (data as List).cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inspection Log')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('Could not load inspections',
                style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text(_error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade500)),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: _fetchInspections, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_items.isEmpty) {
      return RefreshIndicator(
        onRefresh: _fetchInspections,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ListView(
              children: [
                SizedBox(height: constraints.maxHeight * 0.25),
                Center(
                  child: Text(
                    'No inspections yet',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _fetchInspections,
      child: ListView.separated(
        itemCount: _items.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = _items[index];
          final room = item['room'];
          final roomNumber = room is Map
              ? room['roomNumber'] ?? room['room_number'] ?? item['roomId']
              : item['roomId'];
          final description =
              item['description']?.toString() ?? 'Inspection record';
          final takenAt = item['takenAt'] ?? item['taken_at'] ?? '';

          return ListTile(
            leading: const Icon(Icons.assignment_turned_in_outlined),
            title: Text('Room $roomNumber'),
            subtitle: Text('$description\n$takenAt'),
            isThreeLine: true,
            trailing: Chip(
              label: const Text('Complete'),
              backgroundColor: Colors.green.shade100,
              labelStyle: TextStyle(color: Colors.green.shade900),
            ),
          );
        },
      ),
    );
  }
}
