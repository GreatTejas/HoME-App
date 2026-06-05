import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoomDetailScreen extends StatelessWidget {
  final String roomId;
  const RoomDetailScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    final historyLogs = [
      {
        'date': '2024-07-25 09:00 AM',
        'title': 'Leaving',
        'desc': 'Student checked out of the room',
        'image': null
      },
      {
        'date': '2024-07-20 10:00 AM',
        'title': 'Inspection',
        'desc': 'Checked for damages and cleanliness',
        'image': 'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&q=80&w=200'
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Room Details',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Room $roomId', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Ravi Kumar – CS23B045', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
              ],
            ),
          ),
          
          const Divider(height: 1, color: Colors.black12),
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('History', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                // NO const here, because historyLogs is dynamic
                ...historyLogs.map((log) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))
                    ]
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(log['date'] as String, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                            const SizedBox(height: 6),
                            Text(log['title'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(log['desc'] as String, style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.3)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: log['image'] != null
                          ? Image.network(
                              log['image'] as String,
                              width: 80, height: 80, fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 80, height: 80, color: Colors.red.shade50,
                                child: const Icon(Icons.broken_image_outlined, color: Colors.red),
                              ),
                            )
                          : Container(
                              width: 80, height: 80, color: Colors.grey.shade100,
                              child: const Icon(Icons.image_outlined, color: Colors.grey),
                            ),
                      )
                    ],
                  ),
                )).toList(), // .toList() is required when using the spread operator (...)
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () => context.push('/inspections/new/$roomId'),
        icon: const Icon(Icons.add_task),
        label: const Text('New Inspection'),
      ),
    );
  }
}
