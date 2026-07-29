import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoomListScreen extends StatefulWidget {
  final String hostelId;
  const RoomListScreen({super.key, required this.hostelId});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  String _query = '';
  final _rooms = const ['101', '102', '103', '104', '105', '106', '201', '202', '203', '204', '205', '206'];

  @override
  Widget build(BuildContext context) {
    final shown = _rooms.where((room) => room.contains(_query)).toList();
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFF173D32), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.home_work_outlined, color: Colors.white, size: 21)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Room register', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
                Text('Hostel ${widget.hostelId}', style: const TextStyle(fontSize: 13, color: Color(0xFF6D746E))),
              ])),
              IconButton(onPressed: () => context.go('/login'), icon: const Icon(Icons.logout_outlined), tooltip: 'Sign out'),
            ]),
            const SizedBox(height: 28),
            const Text('Rooms', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, letterSpacing: -0.5)),
            const SizedBox(height: 5),
            Text('${_rooms.length} rooms in your hostel', style: const TextStyle(color: Color(0xFF687069))),
            const SizedBox(height: 22),
            TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(hintText: 'Search room number', prefixIcon: const Icon(Icons.search), filled: true, fillColor: const Color(0xFFF1F3F0), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none)),
            ),
            const SizedBox(height: 18),
            Expanded(child: ListView.separated(
              itemCount: shown.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final room = shown[index];
                return Material(color: Colors.white, borderRadius: BorderRadius.circular(16), child: InkWell(
                  borderRadius: BorderRadius.circular(16), onTap: () => context.push('/hostels/${widget.hostelId}/rooms/$room'),
                  child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE7E9E5)), borderRadius: BorderRadius.circular(16)), child: Row(children: [
                    Container(width: 48, height: 48, alignment: Alignment.center, decoration: BoxDecoration(color: const Color(0xFFF1F4F0), borderRadius: BorderRadius.circular(12)), child: Text(room, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
                    const Spacer(),
                    const Icon(Icons.chevron_right, color: Color(0xFF858B86)),
                  ])),
                ));
              },
            )),
          ]),
        ),
      ),
    );
  }
}
