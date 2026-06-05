import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class HostelModel {
  final String id;
  String name;
  String stats;
  File? imageFile; // Nullable: If null, shows a placeholder

  HostelModel({
    required this.id,
    required this.name,
    required this.stats,
    this.imageFile,
  });
}

class HostelListScreen extends StatefulWidget {
  const HostelListScreen({super.key});

  @override
  State<HostelListScreen> createState() => _HostelListScreenState();
}

class _HostelListScreenState extends State<HostelListScreen> {
  // Mock State Data
  late List<HostelModel> _hostels;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize with placeholders (no images)
    _hostels = [
      HostelModel(id: '1', name: 'Maple Residence', stats: '3 Wings · 120 Rooms · 15 Vacant'),
      HostelModel(id: '2', name: 'Oak Hall', stats: '2 Wings · 80 Rooms · 8 Vacant'),
      HostelModel(id: '3', name: 'Cedar House', stats: '4 Wings · 160 Rooms · 22 Vacant'),
    ];
  }

  void _showEditModal(int index) {
    final hostel = _hostels[index];
    final TextEditingController nameController = TextEditingController(text: hostel.name);
    File? tempImage = hostel.imageFile;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows sheet to push up with keyboard
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, // Avoid keyboard
                left: 24, right: 24, top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Edit Hostel', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  
                  // Image Picker Area
                  GestureDetector(
                    onTap: () async {
                      final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
                      if (photo != null) {
                        setModalState(() => tempImage = File(photo.path));
                      }
                    },
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                      ),
                      child: tempImage == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_outlined, size: 32, color: Colors.grey.shade400),
                                const SizedBox(height: 8),
                                Text('Tap to add photo', style: TextStyle(color: Colors.grey.shade600)),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(11),
                              child: Image.file(tempImage!, fit: BoxFit.cover),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Name Editor
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Hostel Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        // Update main state and close sheet
                        setState(() {
                          _hostels[index].name = nameController.text;
                          _hostels[index].imageFile = tempImage;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Hostels', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Add New Hostel flow coming soon!')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search hostel...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // List of Hostels
              Expanded(
                child: ListView.separated(
                  itemCount: _hostels.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final hostel = _hostels[index];
                    return GestureDetector(
                      onTap: () => context.go('/hostels/${hostel.id}/rooms'),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
                          ]
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                  child: hostel.imageFile != null
                                      ? Image.file(
                                          hostel.imageFile!,
                                          height: 160,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          height: 160,
                                          width: double.infinity,
                                          color: Colors.grey.shade200,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.domain, size: 48, color: Colors.grey.shade400),
                                              const SizedBox(height: 8),
                                              Text('No Image Added', style: TextStyle(color: Colors.grey.shade500)),
                                            ],
                                          ),
                                        ),
                                ),
                                // Edit Button Overlay
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: GestureDetector(
                                    onTap: () => _showEditModal(index),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black.withOpacity(0.6),
                                      radius: 18,
                                      child: const Icon(Icons.edit, size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hostel.name,
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    hostel.stats,
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
