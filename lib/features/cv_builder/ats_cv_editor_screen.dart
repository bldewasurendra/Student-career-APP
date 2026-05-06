import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/cv_builder/cv_pdf_service.dart';
import '../../core/app_colors.dart';
import '../../models/cv_model.dart';

class AtsCvEditorScreen extends StatefulWidget {
  final String initialText;

  const AtsCvEditorScreen({super.key, required this.initialText});

  @override
  State<AtsCvEditorScreen> createState() => _AtsCvEditorScreenState();
}

class _AtsCvEditorScreenState extends State<AtsCvEditorScreen> {
  late final TextEditingController _textController;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _generateAndSavePdf() async {
    if (_isGenerating) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      // Use a simplified CVModel just for the plain text content
      final cvData = CvModel(
        fullName: "ATS CV", // Placeholder name
        personalStatement: _textController.text,
        email: '', // Not needed for this template
        phoneNumber: '', // Not needed
      );

      final pdfFile = await CvPdfService.createAtsCv(cvData);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF saved to ${pdfFile.path}'),
          duration: const Duration(seconds: 5),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate PDF: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit ATS CV', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: _isGenerating
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : IconButton(
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    onPressed: _generateAndSavePdf,
                    tooltip: 'Generate PDF',
                  ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Edit the template below with your own information. When you're done, tap the PDF icon to save.",
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(fontFamily: 'monospace', color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
