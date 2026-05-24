import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoomListScreen extends StatelessWidget {
  final String hostelId;
  const RoomListScreen({super.key, required this.hostelId});

  Widget _buildWingTile(BuildContext context, String wingName, bool isExpanded, List<String> rooms) {
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
                  onTap: () => context.go('/hostels/$hostelId/rooms/${rooms[index]}'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      rooms[index],
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
    final List<String> wingARooms = List.generate(20, (index) => '1${index.toString().padLeft(2, '0')}');

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
              context.push('/hostels/$hostelId/rooms/add');
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Floor 1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildWingTile(context, 'Wing A', true, wingARooms),
          _buildWingTile(context, 'Wing B', false, []),
          _buildWingTile(context, 'Wing C', false, []),
          _buildWingTile(context, 'Wing D', false, []),
          
          const SizedBox(height: 24),
          const Text('Floor 2', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildWingTile(context, 'Wing A', false, []),
          _buildWingTile(context, 'Wing B', false, []),
        ],
      ),
    );
  }
}
