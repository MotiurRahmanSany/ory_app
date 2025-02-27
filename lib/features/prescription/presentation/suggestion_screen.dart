import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ory/core/common/constants/app_secret.dart';

class SuggestionScreen extends StatefulWidget {
  final String prompt;
  final File? image;
  final String? userInput;
  const SuggestionScreen({super.key, required this.prompt, this.image, this.userInput });

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  final _responseController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = true;
  bool _hasError = false;
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _generateResponse();
  }

  Future<void> _generateResponse() async {
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: AppSecret.geminiApiKey,
      );

      final prompt =
          widget.prompt.isEmpty
              ? '''Analyze this medical prescription and provide:
              1. Medication list
              2. Dosage instructions
              3. Possible side effects
              4. Doctor recommendations'''
              : '''Analyze this medical information:
              Patient description: ${widget.prompt}
              ${widget.image != null ? 'Prescription image:' : ''}
              Provide:
              1. Likely diagnosis
              2. Recommended tests
              3. Treatment options
              4. Specialist recommendations''';

      final content = [
        Content.text(prompt),
        if (widget.image != null)
          Content.data('image/jpeg', await widget.image!.readAsBytes()),
      ];

      final response = model.generateContentStream(content);

      _streamSubscription = response.listen(
        (event) {
          final text = event.text;
          if (text != null) {
            setState(() {
              _responseController.text += text;
              _isLoading = false;
            });
            // Auto-scroll to bottom
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });
          }
        },
        onError: (error) => _handleError(error.toString()),
        onDone: () => setState(() => _isLoading = false),
      );
    } catch (e) {
      _handleError(e.toString());
    }
  }

  void _handleError(String message) {
    setState(() {
      _responseController.text = 'Error: $message\n\nTap to retry';
      _isLoading = false;
      _hasError = true;
    });
  }

  void _retry() {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _responseController.clear();
    });
    _generateResponse();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Analysis'),
        actions: [
          if (_hasError)
            IconButton(icon: const Icon(Icons.refresh), onPressed: _retry),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Input Section
              if (widget.userInput != null && widget.userInput!.isNotEmpty) ...[
                _buildSectionHeader('Your Query'),
                _buildUserInputCard(widget.userInput!),
                const SizedBox(height: 20),
              ],
        
              // Uploaded Image Preview
              if (widget.image != null) ...[
                _buildSectionHeader('Prescription Image'),
                _buildImagePreview(),
                const SizedBox(height: 20),
              ],
        
              // Analysis Section
              _buildSectionHeader('AI Analysis'),
              const SizedBox(height: 16),
        
              // Response Area
              SizedBox(
                height: 600,
                child: _isLoading ? _buildShimmerLoader() : _buildResponseArea(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildUserInputCard(String text) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(widget.image!, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView(
        padding: EdgeInsets.zero,
        children: List.generate(
          5,
          (index) => Container(
            height: 20 + (index * 24.0),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponseArea() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Markdown(
          controller: _scrollController,
          data: _responseController.text,
          styleSheet: MarkdownStyleSheet(
            h1: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
            h2: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.blueAccent,
            ),
            h3: const TextStyle(fontSize: 18, color: Colors.grey),
            p: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
            strong: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
            listBullet: const TextStyle(color: Colors.orange, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
