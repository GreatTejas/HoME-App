import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// ── NEW: import the API client ──
import '../../../core/api/api_client.dart';

// ── NEW: Simple model for a Room from the backend ─────────────────
class RoomModel {
  final int id;
  final String roomNumber;
  final int floor; // We derive this from the first digit of roomNumber

  RoomModel({required this.id, required this.roomNumber, required this.floor});

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    final roomNum = json['roomNumber']?.toString() ?? json['room_number']?.toString() ?? '0';
    // Derive floor from room number: "101" → floor 1, "201" → floor 2
    int floor = 1;
    if (roomNum.isNotEmpty) {
      floor = int.tryParse(roomNum[0]) ?? 1;
    }
    return RoomModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      roomNumber: roomNum,
      floor: floor,
    );
  }
}

// ── CHANGED: StatelessWidget → StatefulWidget (needed for API loading state) ──
class RoomListScreen extends StatefulWidget {
  final String hostelId;
  const RoomListScreen({super.key, required this.hostelId});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  List<RoomModel> _rooms = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  // ── NEW: Fetch rooms from backend ─────────────────────────────
  // Calls: GET http://localhost:5000/api/rooms?hostelId=1
  // Which hits: server/routes/roomRoutes.js → roomController.getAllRooms
  Future<void> _fetchRooms() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await ApiClient.instance.get('/api/rooms?hostelId=${widget.hostelId}');
      setState(() {
        _rooms = (data as List).map((json) => RoomModel.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // ── Group rooms by floor ────────────────────────────────────────
  Map<int, List<RoomModel>> get _roomsByFloor {
    final map = <int, List<RoomModel>>{};
    for (final room in _rooms) {
      map.putIfAbsent(room.floor, () => []).add(room);
    }
    return Map.fromEntries(map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
  }

  Widget _buildWingTile(BuildContext context, String wingName, bool isExpanded, List<RoomModel> rooms) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          title: Text(wingName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          collapsedBackgroundColor: const Color(0xFFF0F2F5),
          backgroundColor: const Color(0xFFF0F2F5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          childrenPadding: const EdgeInsets.all(16),
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  // ── CHANGED: Navigate using room.id (database ID) instead of room number ──
                  onTap: () => context.go('/hostels/${widget.hostelId}/rooms/${rooms[index].id}'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      rooms[index].roomNumber,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Hostel Details',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.black),
            onPressed: () {
              // Navigate to the add room form
              context.push('/hostels/${widget.hostelId}/rooms/add');
            },
          )
        ],
      ),
      // ── CHANGED: Show loading/error/data from API ──────────────
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_off, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text('Could not load rooms', style: TextStyle(color: Colors.grey.shade600)),
                      const SizedBox(height: 8),
                      ElevatedButton(onPressed: _fetchRooms, child: const Text('Retry')),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchRooms,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // ── Build one section per floor, with rooms grouped ──
                      for (final entry in _roomsByFloor.entries) ...[
                        Text('Floor ${entry.key}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _buildWingTile(context, 'Rooms', true, entry.value),
                        const SizedBox(height: 24),
                      ],
                      if (_rooms.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Text('No rooms yet', style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}
