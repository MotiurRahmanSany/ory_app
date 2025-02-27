import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ory/features/prescription/presentation/suggestion_screen.dart';

import '../../../core/utils/utils.dart';

class PrescriptionScreen extends ConsumerStatefulWidget {
  const PrescriptionScreen({super.key});

  @override
  ConsumerState<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends ConsumerState<PrescriptionScreen> {
  final _textController = TextEditingController();
  File? _prescriptionImage;
  

  void _pickImage(bool fromCamera) async {
    final selectedImage = fromCamera 
        ? await takeImageWithCamera()
        : await pickImageFromGallery();

    if (selectedImage != null) {
      final compressedPath = await compressImageFile(selectedImage.path);
      setState(() => _prescriptionImage = File(compressedPath));
    }
  }

  void _submitData() async {
    if (_textController.text.isEmpty && _prescriptionImage == null) {
      ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(
        const SnackBar(content: Text('Please provide text or image')),
      );
      return;
    }

    final prompt = _buildPrompt();
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => SuggestionScreen(
        prompt: prompt,
        image: _prescriptionImage,
        userInput: _textController.text,
      ),
    ));
  }

  String _buildPrompt() {
    String prompt = '''
    Act as a medical expert. Analyze the provided ${_prescriptionImage != null ? 'prescription image and ' : ''}
    ${_textController.text.isNotEmpty ? 'patient description: "${_textController.text}"' : ''}
    
    Provide detailed response with:
    1. Prescription Overview (if image provided)
    2. Likely Diagnosis
    3. Treatment Suggestions
    4. Recommended Specialist from: $doctorsList
    5. Reason for Specialist Choice
    
    Structure response in Markdown with clear headers. 
    Highlight critical information in **bold**. 
    Use bullet points for lists.
    ''';

    if (_prescriptionImage != null) {
      prompt += '''
      \nFor image analysis focus on:
      - Medication names
      - Dosage instructions
      - Doctor notes
      - Potential conflicts
      ''';
    }

    return prompt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Health Assistant')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Get AI-Powered Health Insights',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildImageUploadSection(),
            const SizedBox(height: 20),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Describe symptoms or upload prescription...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.medical_services),
              label: const Text('Analyze Now'),
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Upload Prescription'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(true);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(false);
                },
              ),
            ],
          ),
        ),
      ),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade300),
          color: Colors.blue.shade50,
        ),
        child: _prescriptionImage == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file, size: 40, color: Colors.blue.shade700),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('Upload Prescription (Optional)',
                        style: TextStyle(color: Colors.blue.shade700),
                        textAlign: TextAlign.center,
                        ),
                  ),
                ],
              )
            : Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(_prescriptionImage!, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => setState(() => _prescriptionImage = null),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
