import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/api/api_client.dart';

class AssetFormState {
  final int assetId;
  final String assetName;
  String condition;
  String notes;
  Uint8List? imageBytes;
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
  late final List<AssetFormState> _assets;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _assets = [
      AssetFormState(assetId: 1, assetName: 'Ceiling Fan'),
      AssetFormState(assetId: 2, assetName: 'Study Table'),
      AssetFormState(assetId: 3, assetName: 'Light Fixture'),
      AssetFormState(assetId: 4, assetName: 'Door Lock'),
    ];
  }

  Future<void> _takePicture(int index) async {
    try {
      final photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (photo != null) {
        final bytes = await photo.readAsBytes();
        setState(() => _assets[index].imageBytes = bytes);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open camera: $e')),
        );
      }
    }
  }

  Future<void> _submitInspection() async {
    setState(() => _isLoading = true);

    try {
      final damagedAssets =
          _assets.where((asset) => asset.condition == 'damaged').toList();

      if (damagedAssets.isEmpty) {
        await ApiClient.instance.post('/api/storage-items', {
          'roomId': int.tryParse(widget.roomId) ?? widget.roomId,
          'description': 'Inspection completed: no damaged assets found',
          'belongsTo': 'inspection',
        });
      }

      for (final asset in damagedAssets) {
        final photoUrl = asset.imageBytes == null
            ? null
            : 'data:image/jpeg;base64,${base64Encode(asset.imageBytes!)}';

        await ApiClient.instance.post('/api/storage-items', {
          'roomId': int.tryParse(widget.roomId) ?? widget.roomId,
          'description':
              '${asset.assetName}: ${asset.notes.trim().isEmpty ? 'Damaged' : asset.notes.trim()}',
          'belongsTo': 'inspection',
          'photoUrl': photoUrl,
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inspection submitted')),
        );
        context.pop(true);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F9),
        title: Text(
          'Inspect Room ${widget.roomId}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          asset.assetName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                              value: 'working',
                              icon: Icon(Icons.check_circle_outline)),
                          ButtonSegment(
                              value: 'damaged',
                              icon: Icon(Icons.error_outline)),
                        ],
                        selected: {asset.condition},
                        onSelectionChanged: (selection) {
                          setState(() {
                            asset.condition = selection.first;
                            if (asset.condition == 'working') {
                              asset.notes = '';
                              asset.imageBytes = null;
                              asset.maintenanceType = null;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: isDamaged
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(height: 32),
                              GestureDetector(
                                onTap: () => _takePicture(index),
                                child: Container(
                                  height: 120,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: asset.imageBytes == null
                                          ? Colors.grey.shade300
                                          : Colors.teal,
                                    ),
                                  ),
                                  child: asset.imageBytes == null
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.camera_alt_outlined,
                                                color: Colors.grey.shade400,
                                                size: 32),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Tap to take photo of damage',
                                              style: TextStyle(
                                                  color: Colors.grey.shade500),
                                            ),
                                          ],
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(11),
                                          child: Image.memory(asset.imageBytes!,
                                              fit: BoxFit.cover),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 16),
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
                                onChanged: (value) => asset.notes = value,
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
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitInspection,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : const Text(
                    'Submit Inspection',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    );
  }
}
