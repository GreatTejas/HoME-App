import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoomDetailScreen extends StatelessWidget {
  final String roomId;
  const RoomDetailScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    const logs = [
      ('Check-in inspection', '12 Jul 2026', 'Handover inspection', 'All items in good condition', Icons.login_rounded),
      ('Maintenance review', '03 Jul 2026', 'Facilities team', 'Desk lamp replaced', Icons.build_outlined),
      ('Check-out inspection', '22 Dec 2025', 'Handover inspection', 'No damages recorded', Icons.logout_rounded),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFA),
      appBar: AppBar(backgroundColor: const Color(0xFFFCFCFA), elevation: 0, surfaceTintColor: Colors.transparent, leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)), title: const Text('Room details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 108), children: [
        Text('Room $roomId', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.6)),
        const SizedBox(height: 24),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFF0F5F1), borderRadius: BorderRadius.circular(16)), child: const Row(children: [Icon(Icons.verified_outlined, color: Color(0xFF2D6948)), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Last inspection complete', style: TextStyle(fontWeight: FontWeight.w700)), SizedBox(height: 2), Text('12 Jul 2026 - signed by student and security', style: TextStyle(fontSize: 12, color: Color(0xFF5F6C62)))]))])),
        const SizedBox(height: 30),
        const Text('Inspection history', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        ...logs.map((log) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFE7E9E5)), borderRadius: BorderRadius.circular(16)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFF1F4F0), borderRadius: BorderRadius.circular(10)), child: Icon(log.$5, color: const Color(0xFF173D32), size: 20)), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(log.$1, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text(log.$2, style: const TextStyle(fontSize: 12, color: Color(0xFF737A74))), const SizedBox(height: 7), Text(log.$3, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)), const SizedBox(height: 3), Text(log.$4, style: const TextStyle(fontSize: 13, color: Color(0xFF656B66)))])), const Icon(Icons.chevron_right, color: Color(0xFF939993))]))),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => context.push('/inspections/new/$roomId'), backgroundColor: const Color(0xFF173D32), foregroundColor: Colors.white, elevation: 0, icon: const Icon(Icons.add), label: const Text('Add inspection', style: TextStyle(fontWeight: FontWeight.w700))),
    );
  }
}
