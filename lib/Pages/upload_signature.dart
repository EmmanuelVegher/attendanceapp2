import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

import '../services/database_adapter.dart';
import '../services/hive_service.dart';
import '../services/isar_service.dart';
import '../widgets/drawer.dart';

class UploadSignaturePage extends StatefulWidget {
  const UploadSignaturePage({super.key});

  @override
  _UploadSignaturePageState createState() => _UploadSignaturePageState();
}

class _UploadSignaturePageState extends State<UploadSignaturePage> {
  final SignatureController _signatureController = SignatureController(
    penColor: Colors.black,
    penStrokeWidth: 3,
  );
  Uint8List? _currentSignature;
  late final DatabaseAdapter _adapter;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _adapter = HiveService(); // Initialize your database adapter
    _loadSignatureFromDatabase();
  }

  Future<void> _loadSignatureFromDatabase() async {
    final signatures = await _adapter.getSignatureImages();
    if (signatures.isNotEmpty) {
      setState(() {
        _currentSignature = signatures.first;
      });
    }
  }

  Future<void> _saveSignatureToDatabase(Uint8List signature) async {
    await _clearSignaturesFromDatabase(); // Clear before saving new signature
    await _adapter.storeSignatureImage(signature).then((_){
      IsarService().updateBioSignatureLinktoNull();
    });
    setState(() {
      _currentSignature = signature;
    });
  }

  Future<void> _clearSignaturesFromDatabase() async {
    await _adapter.clearSignatureImages1(); // Clear existing signatures
  }

  Future<void> _pickAndUploadSignature() async {
    // Use image_picker to select an image
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();
      await _saveSignatureToDatabase(imageBytes);
    }
  }

  void _showSignaturePad() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 300,
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: Signature(
                    controller: _signatureController,
                    backgroundColor: Colors.grey[200]!,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => _signatureController.clear(),
                      child: const Text("Clear"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final signature = await _signatureController.toPngBytes();
                        if (signature != null) {
                          await _saveSignatureToDatabase(signature);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context, IsarService()),
      appBar: AppBar(
        title: const Text("Upload Signature"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Signature Preview
            GestureDetector(
              onTap: () => _showSignaturePad(),
              child: Container(
                height: MediaQuery.of(context).size.width * 0.5,
                width: MediaQuery.of(context).size.width * 0.5,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _currentSignature != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    _currentSignature!,
                    fit: BoxFit.contain,
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.upload_file,
                      size: MediaQuery.of(context).size.width * 0.15,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Tap to Upload or Draw Signature",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showSignaturePad(),
                  icon: const Icon(Icons.create),
                  label: const Text("Draw Signature"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickAndUploadSignature(),
                  icon: const Icon(Icons.upload_file, color: Colors.white), // Set icon color to white
                  label: const Text(
                    "Upload Signature",
                    style: TextStyle(color: Colors.white), // Set text color to white
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown, // Button background color
                    foregroundColor: Colors.white, // Text and icon color by default
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_currentSignature != null) {
                  await _saveSignatureToDatabase(_currentSignature!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Signature saved successfully!")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,

              ),
              child: const Text("Save Signature",style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }
}
