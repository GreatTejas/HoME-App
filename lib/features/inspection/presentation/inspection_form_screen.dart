import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class InspectionFormScreen extends StatefulWidget {
  final String roomId;
  const InspectionFormScreen({super.key, required this.roomId});
  @override
  State<InspectionFormScreen> createState() => _InspectionFormScreenState();
}

class _InspectionFormScreenState extends State<InspectionFormScreen> {
  final List<TextEditingController> _studentControllers = [TextEditingController()];
  final _commentsController = TextEditingController();
  final _picker = ImagePicker();
  final Map<String, String> _conditions = {'Ceiling fan': 'Good', 'Light fixtures': 'Good', 'Study table': 'Good'};
  final List<File> _photos = [];
  File? _video;
  List<Offset?> _studentSignature = [];
  List<Offset?> _securitySignature = [];
  bool _saving = false;

  @override
  void dispose() { for (final controller in _studentControllers) { controller.dispose(); } _commentsController.dispose(); super.dispose(); }

  Future<void> _addPhoto() async {
    final image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 75);
    if (image != null) setState(() => _photos.add(File(image.path)));
  }
  Future<void> _addVideo() async {
    final video = await _picker.pickVideo(source: ImageSource.camera, maxDuration: const Duration(minutes: 2));
    if (video != null) setState(() => _video = File(video.path));
  }
  Future<void> _submit() async {
    if (_studentControllers.any((controller) => controller.text.trim().isEmpty) || _studentSignature.isEmpty || _securitySignature.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add every student name and both signatures before saving.')));
      return;
    }
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) context.pop();
  }

  Future<void> _openSignature(bool isStudent) async {
    final current = isStudent ? _studentSignature : _securitySignature;
    final result = await showModalBottomSheet<List<Offset?>>(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (_) => _SignatureSheet(points: current));
    if (result != null) setState(() { if (isStudent) { _studentSignature = result; } else { _securitySignature = result; } });
  }

  Widget _sectionTitle(String title, String subtitle) => Padding(padding: const EdgeInsets.only(top: 26, bottom: 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(fontSize: 13, color: Color(0xFF6E756F)))]));
  BoxDecoration get _card => BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6E9E4)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFA),
      appBar: AppBar(backgroundColor: const Color(0xFFFCFCFA), surfaceTintColor: Colors.transparent, elevation: 0, leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close)), title: Text('Inspect room ${widget.roomId}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 4, 20, 112), children: [
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFF0F5F1), borderRadius: BorderRadius.circular(16)), child: const Row(children: [Icon(Icons.info_outline, color: Color(0xFF286244)), SizedBox(width: 12), Expanded(child: Text('Record the room condition together before handover.', style: TextStyle(fontSize: 13, height: 1.35)))])),
        _sectionTitle('Students', 'Add everyone sharing this room.'),
        ..._studentControllers.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: entry.value,
                    decoration: InputDecoration(
                      labelText: 'Student ${entry.key + 1} name',
                      hintText: 'Enter full name',
                      prefixIcon: const Icon(Icons.person_outline),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE5E8E3)),
                      ),
                    ),
                  ),
                ),
                if (_studentControllers.length > 1)
                  IconButton(
                    onPressed: () => setState(() {
                      final removed = _studentControllers.removeAt(entry.key);
                      removed.dispose();
                    }),
                    icon: const Icon(Icons.remove_circle_outline),
                    tooltip: 'Remove student',
                  ),
              ],
            ),
          ),
        ),
        Align(alignment: Alignment.centerLeft, child: TextButton.icon(onPressed: () => setState(() => _studentControllers.add(TextEditingController())), icon: const Icon(Icons.add), label: const Text('Add another student'), style: TextButton.styleFrom(foregroundColor: const Color(0xFF173D32)))),
        const SizedBox(height: 12),
        Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15), decoration: _card, child: const Row(children: [Icon(Icons.calendar_today_outlined, size: 20), SizedBox(width: 12), Text('Inspection date'), Spacer(), Text('28 Jul 2026', style: TextStyle(fontWeight: FontWeight.w600))])),
        _sectionTitle('Item condition', 'Select the present state of every item.'),
        Container(decoration: _card, child: Column(children: _conditions.keys.map((item) => Column(children: [Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13), child: Row(children: [Expanded(child: Text(item, style: const TextStyle(fontWeight: FontWeight.w600))), DropdownButton<String>(value: _conditions[item], underline: const SizedBox(), items: const [DropdownMenuItem(value: 'Good', child: Text('Good')), DropdownMenuItem(value: 'Fair', child: Text('Fair')), DropdownMenuItem(value: 'Damaged', child: Text('Damaged'))], onChanged: (value) => setState(() => _conditions[item] = value!))])), if (item != _conditions.keys.last) const Divider(height: 1)] )).toList())),
        _sectionTitle('Evidence', 'Add photos or a short walkthrough video.'),
        Row(children: [Expanded(child: OutlinedButton.icon(onPressed: _addPhoto, icon: const Icon(Icons.camera_alt_outlined), label: const Text('Add photo'), style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF173D32), minimumSize: const Size(0, 50), side: const BorderSide(color: Color(0xFFBFC9C1)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))))), const SizedBox(width: 12), Expanded(child: OutlinedButton.icon(onPressed: _addVideo, icon: const Icon(Icons.videocam_outlined), label: const Text('Add video'), style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF173D32), minimumSize: const Size(0, 50), side: const BorderSide(color: Color(0xFFBFC9C1)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)))))]),
        if (_photos.isNotEmpty || _video != null) Padding(padding: const EdgeInsets.only(top: 12), child: Wrap(spacing: 9, runSpacing: 9, children: [ ..._photos.map((file) => ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(file, width: 78, height: 78, fit: BoxFit.cover))), if (_video != null) Container(width: 78, height: 78, decoration: BoxDecoration(color: const Color(0xFFEAF0EB), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.play_circle_outline, color: Color(0xFF173D32), size: 30)) ])),
        _sectionTitle('Comments', 'Note anything that needs context later.'),
        TextField(controller: _commentsController, maxLines: 4, decoration: InputDecoration(hintText: 'Add notes about the room condition…', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E8E3))))),
        _sectionTitle('Sign-off', 'Both parties confirm this record is accurate.'),
        _SignCard(label: 'Student signature', signed: _studentSignature.isNotEmpty, onTap: () => _openSignature(true)),
        const SizedBox(height: 10),
        _SignCard(label: 'Security signature', signed: _securitySignature.isNotEmpty, onTap: () => _openSignature(false)),
      ]),
      bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 10, 20, 18), child: ElevatedButton(onPressed: _saving ? null : _submit, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF173D32), foregroundColor: Colors.white, elevation: 0, minimumSize: const Size.fromHeight(54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: _saving ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Save inspection', style: TextStyle(fontWeight: FontWeight.w700))))),
    );
  }
}

class _SignCard extends StatelessWidget {
  final String label;
  final bool signed;
  final VoidCallback onTap;
  const _SignCard({required this.label, required this.signed, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: signed ? const Color(0xFFF0F5F1) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: signed ? const Color(0xFF74A989) : const Color(0xFFE0E4DE)),
        ),
        child: Row(
          children: [
            Icon(
              signed ? Icons.check_circle : Icons.draw_outlined,
              color: signed ? const Color(0xFF2D6948) : const Color(0xFF6A716B),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    signed ? 'Signature captured' : 'Tap to sign',
                    style: TextStyle(
                      fontSize: 12,
                      color: signed ? const Color(0xFF2D6948) : const Color(0xFF747B75),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF858B86)),
          ],
        ),
      ),
    );
  }
}

class _SignatureSheet extends StatefulWidget {
  final List<Offset?> points;
  const _SignatureSheet({required this.points});
  @override
  State<_SignatureSheet> createState() => _SignatureSheetState();
}

class _SignatureSheetState extends State<_SignatureSheet> {
  late List<Offset?> _points;
  @override
  void initState() { super.initState(); _points = List.of(widget.points); }
  @override
  Widget build(BuildContext context) => SafeArea(child: Container(padding: const EdgeInsets.fromLTRB(20, 12, 20, 20), decoration: const BoxDecoration(color: Color(0xFFFCFCFA), borderRadius: BorderRadius.vertical(top: Radius.circular(24))), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
    Center(child: Container(width: 38, height: 4, decoration: BoxDecoration(color: const Color(0xFFD5D9D4), borderRadius: BorderRadius.circular(4)))),
    const SizedBox(height: 20), const Text('Add signature', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)), const SizedBox(height: 4), const Text('Sign in the space below.', style: TextStyle(color: Color(0xFF6E756F))), const SizedBox(height: 18),
    Container(height: 190, decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFDDE2DC)), borderRadius: BorderRadius.circular(14)), child: ClipRRect(borderRadius: BorderRadius.circular(14), child: GestureDetector(onPanStart: (d) => setState(() => _points.add(d.localPosition)), onPanUpdate: (d) => setState(() => _points.add(d.localPosition)), onPanEnd: (_) => _points.add(null), child: CustomPaint(painter: _SignaturePainter(_points), child: const SizedBox.expand())))),
    const SizedBox(height: 12), Row(children: [TextButton(onPressed: () => setState(() => _points.clear()), child: const Text('Clear')), const Spacer(), TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), const SizedBox(width: 8), ElevatedButton(onPressed: _points.isEmpty ? null : () => Navigator.pop(context, _points), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF173D32), foregroundColor: Colors.white, elevation: 0), child: const Text('Confirm'))]),
  ])));
}

class _SignaturePainter extends CustomPainter {
  final List<Offset?> points;
  _SignaturePainter(this.points);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF173D32)..strokeWidth = 2.3..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    for (var i = 0; i < points.length - 1; i++) { if (points[i] != null && points[i + 1] != null) canvas.drawLine(points[i]!, points[i + 1]!, paint); }
  }
  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => oldDelegate.points != points;
}
