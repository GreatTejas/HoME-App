import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// ── NEW: import the API client ──
import '../../../core/api/api_client.dart';

// ── CHANGED: StatelessWidget → StatefulWidget (needed for API calls) ──
class RoomDetailScreen extends StatefulWidget {
  final String roomId;
  const RoomDetailScreen({super.key, required this.roomId});

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  bool _isLoading = true;
  String? _error;

  // Room data from API
  String _roomNumber = '';
  String _roomType = '';
  int _capacity = 0;
  int _occupancy = 0;

  // Storage items (inspection history) from API
  List<Map<String, dynamic>> _storageItems = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // ── NEW: Fetch room details + storage items in parallel ─────────
  // Calls:
  //   GET /api/rooms/:id          → roomController.getRoomById
  //   GET /api/storage-items?roomId=:id → storageController.getAllStorageItems
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Fire both requests at the same time for speed
      final results = await Future.wait([
        ApiClient.instance.get('/api/rooms/${widget.roomId}'),
        ApiClient.instance.get('/api/storage-items?roomId=${widget.roomId}'),
      ]);

      final roomData = results[0] as Map<String, dynamic>;
      final itemsData = results[1] as List;

      setState(() {
        _roomNumber = roomData['roomNumber']?.toString() ??
            roomData['room_number']?.toString() ??
            widget.roomId;
        _roomType = roomData['roomType']?.toString() ??
            roomData['room_type']?.toString() ??
            'standard';
        _capacity = roomData['capacity'] ?? 0;
        _occupancy =
            roomData['occupancyCount'] ?? roomData['occupancy_count'] ?? 0;
        _storageItems = itemsData.cast<Map<String, dynamic>>();
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
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F7F9),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF7F7F9),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.black, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F7F9),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF7F7F9),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.black, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text('Could not load room',
                  style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: _fetchData, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Room Details',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── CHANGED: Show real room number from API ──
                Text('Room $_roomNumber',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                    '$_roomType - Capacity: $_capacity - Occupancy: $_occupancy',
                    style:
                        TextStyle(fontSize: 16, color: Colors.grey.shade600)),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.black12),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Storage Items / History',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                // ── CHANGED: Show real storage items from API ──
                if (_storageItems.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text('No inspection records yet',
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 16)),
                    ),
                  )
                else
                  ..._storageItems.map((item) {
                    final description =
                        item['description']?.toString() ?? 'No description';
                    final photoUrl = item['photoUrl'] ?? item['photo_url'];
                    final takenAt = item['takenAt'] ?? item['taken_at'] ?? '';
                    final belongsTo =
                        item['belongsTo'] ?? item['belongs_to'] ?? '';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2))
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(takenAt.toString(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade500)),
                                const SizedBox(height: 6),
                                Text(belongsTo.toString(),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(description,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                        height: 1.3)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _buildPhoto(photoUrl),
                          )
                        ],
                      ),
                    );
                  }),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () async {
          // Navigate to inspection form, and refresh data when user comes back
          await context.push('/inspections/new/${widget.roomId}');
          _fetchData(); // Refresh after inspection is submitted
        },
        icon: const Icon(Icons.add_task),
        label: const Text('New Inspection'),
      ),
    );
  }

  Widget _buildPhoto(dynamic photoUrl) {
    final url = photoUrl?.toString() ?? '';
    if (url.isEmpty) {
      return Container(
        width: 80,
        height: 80,
        color: Colors.grey.shade100,
        child: const Icon(Icons.image_outlined, color: Colors.grey),
      );
    }

    if (url.startsWith('data:image')) {
      final encoded = url.substring(url.indexOf(',') + 1);
      return Image.memory(
        base64Decode(encoded),
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      url,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: 80,
        height: 80,
        color: Colors.red.shade50,
        child: const Icon(Icons.broken_image_outlined, color: Colors.red),
      ),
    );
  }
}
