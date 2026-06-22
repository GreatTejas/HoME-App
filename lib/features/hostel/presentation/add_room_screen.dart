import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// ── NEW: import the API client ──
import '../../../core/api/api_client.dart';

class AddRoomScreen extends StatefulWidget {
  final String hostelId;
  const AddRoomScreen({super.key, required this.hostelId});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  String _roomNumber = '';
  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      try {
        // ── NEW: Send the room to the backend ─────────────────────
        // Calls: POST http://localhost:5000/api/rooms
        // Which hits: server/routes/roomRoutes.js → roomController.createRoom
        // The body must match what the Room model expects (see server/models/Room.js)
        await ApiClient.instance.post('/api/rooms', {
          'hostelId': int.tryParse(widget.hostelId) ?? widget.hostelId,
          'roomNumber': _roomNumber,
          'capacity': 1,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Room $_roomNumber added successfully!')),
          );
          context.pop(); // Go back to room list
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:
            const Text('Add New Room', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text('Room Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Room Number (e.g., 101)',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? 'Required' : null,
              onSaved: (val) => _roomNumber = val!,
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white))
                  : const Text('Save Room',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}
