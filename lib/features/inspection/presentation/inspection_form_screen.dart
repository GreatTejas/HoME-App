import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AssetFormState {
  final int assetId;
  final String assetName;
  String condition;
  String notes;
  File? localImageFile; // Upgraded from String to actual File object
  String? maintenanceType;

  AssetFormState({
    required this.assetId,
    required this.assetName,
    this.condition = 'working',
    this.notes = '',
  });
}

class InspectionFormScreen extends StatefulWidget {
  final String roomId;
  const InspectionFormScreen({super.key, required this.roomId});

  @override
  State<InspectionFormScreen> createState() => _InspectionFormScreenState();
}

class _InspectionFormScreenState extends State<InspectionFormScreen> {
  bool _isLoading = false;
  late List<AssetFormState> _assets;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Mock fetched assets
    _assets = [
      AssetFormState(assetId: 1, assetName: 'Ceiling Fan'),
      AssetFormState(assetId: 2, assetName: 'Study Table'),
    ];
  }

  // --- Real Device Camera Logic ---
  Future<void> _takePicture(int index) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70, // Compress slightly for Cloudinary
      );
      
      if (photo != null) {
        setState(() {
          _assets[index].localImageFile = File(photo.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open camera: $e')),
      );
    }
  }

  void _submitInspection() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // Mock API delay
    // TODO: Upload each localImageFile via CloudinaryService here
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F9),
        title: Text('Inspect Room ${widget.roomId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _assets.length,
        itemBuilder: (context, index) {
          final asset = _assets[index];
          final isDamaged = asset.condition == 'damaged';

          return Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header & Toggle ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(asset.assetName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'working', icon: Icon(Icons.check_circle_outline)),
                          ButtonSegment(value: 'damaged', icon: Icon(Icons.error_outline)),
                        ],
                        selected: {asset.condition},
                        onSelectionChanged: (selection) {
                          setState(() {
                            asset.condition = selection.first;
                            if (asset.condition == 'working') {
                              asset.notes = '';
                              asset.localImageFile = null;
                              asset.maintenanceType = null;
                            }
                          });
                        },
                      ),
                    ],
                  ),

                  // --- Damaged Item UI (Camera & Notes) ---
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: isDamaged
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(height: 32),
                              
                              // Interactive Image Placeholder
                              GestureDetector(
                                onTap: () => _takePicture(index),
                                child: Container(
                                  height: 120,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: asset.localImageFile == null ? Colors.grey.shade300 : Colors.teal,
                                      style: BorderStyle.solid,
                                      width: 1,
                                    ),
                                  ),
                                  child: asset.localImageFile == null
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.camera_alt_outlined, color: Colors.grey.shade400, size: 32),
                                            const SizedBox(height: 8),
                                            Text('Tap to take photo of damage', style: TextStyle(color: Colors.grey.shade500)),
                                          ],
                                        )
                                      : Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(11),
                                              child: Image.file(asset.localImageFile!, fit: BoxFit.cover),
                                            ),
                                            Positioned(
                                              top: 8, right: 8,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.black54,
                                                radius: 16,
                                                child: const Icon(Icons.edit, size: 16, color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Notes
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Describe the damage...',
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                maxLines: 2,
                                onChanged: (val) => asset.notes = val,
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitInspection,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Submit Inspection', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
