import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/cv_builder/cv_pdf_service.dart';
import 'package:printing/printing.dart';
import '../../core/app_colors.dart';
import '../../models/cv_model.dart';


class CVFormScreen extends StatefulWidget {
  const CVFormScreen({super.key});

  @override
  State<CVFormScreen> createState() => _CVFormScreenState();
}

class _CVFormScreenState extends State<CVFormScreen> {
  final CvModel _cvData = CvModel(
    education: [Education()],
    experience: [Experience()],
    skills: [],
  );

  final _skillController = TextEditingController();

  void _checkATSScore() {
    int score = 0;
    List<String> tips = [];

    if (_cvData.fullName.length > 3) {
      score += 10;
    } else {
      tips.add("Add your full name");
    }
    if (_cvData.email.contains("@")) {
      score += 10;
    } else {
      tips.add("Add a valid email");
    }
    if (_cvData.phoneNumber.length > 5) {
      score += 5;
    } else {
      tips.add("Add your phone number");
    }
    if (_cvData.personalStatement.length > 20) {
      score += 15;
    } else {
      tips.add("Write a professional summary (min 20 chars)");
    }
    if (_cvData.education.any((e) => e.degree.isNotEmpty)) {
      score += 20;
    } else {
      tips.add("Add your educational qualifications");
    }
    if (_cvData.experience.any((e) => e.jobTitle.isNotEmpty)) {
      score += 20;
    } else {
      tips.add("Add your work experience");
    }
    if (_cvData.skills.length >= 3) {
      score += 20;
    } else {
      tips.add("Add at least 3 relevant skills");
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text("ATS Friendliness Score", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.white10,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      score > 70 ? Colors.green : (score > 40 ? Colors.orange : Colors.red),
                    ),
                  ),
                ),
                Text("$score%", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            if (tips.isNotEmpty) ...[
              const Text("Improvements needed:", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...tips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange, size: 14),
                    const SizedBox(width: 8),
                    Expanded(child: Text(tip, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                  ],
                ),
              )),
            ] else 
              const Text("Great! Your CV is highly ATS-friendly.", style: TextStyle(color: Colors.green)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }

  void _generateAndPreview() async {
    final pdfFile = await CvPdfService.generateStyledCv(_cvData);
    if (mounted) {
      // This is a simplified way to show the user where the file is.
      // For a real app, you might use a file viewer or share intent.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF saved to ${pdfFile.path}'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("CV Builder"),
        actions: [
          IconButton(
            onPressed: _checkATSScore,
            icon: const Icon(Icons.analytics_outlined, color: Colors.amber),
            tooltip: "Check ATS Score",
          ),
          IconButton(
            onPressed: _generateAndPreview,
            icon: const Icon(Icons.picture_as_pdf, color: AppColors.primary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Personal Information"),
            _buildTextField("Full Name", (v) => _cvData.fullName = v),
            _buildTextField("Email", (v) => _cvData.email = v),
            _buildTextField("Phone", (v) => _cvData.phoneNumber = v),
            _buildTextField("Professional Summary", (v) => _cvData.personalStatement = v, maxLines: 3),
            
            const SizedBox(height: 30),
            _buildSectionHeader("Work Experience"),
            ..._cvData.experience.asMap().entries.map((entry) => _buildExperienceForm(entry.key)),
            TextButton.icon(
              onPressed: () => setState(() => _cvData.experience.add(Experience())),
              icon: const Icon(Icons.add),
              label: const Text("Add Experience"),
            ),

            const SizedBox(height: 30),
            _buildSectionHeader("Education"),
            ..._cvData.education.asMap().entries.map((entry) => _buildEducationForm(entry.key)),
            TextButton.icon(
              onPressed: () => setState(() => _cvData.education.add(Education())),
              icon: const Icon(Icons.add),
              label: const Text("Add Education"),
            ),

            const SizedBox(height: 30),
            _buildSectionHeader("Skills"),
            Row(
              children: [
                Expanded(
                  child: _buildTextField("Add Skill", null, controller: _skillController),
                ),
                IconButton(
                  onPressed: () {
                    if (_skillController.text.isNotEmpty) {
                      setState(() {
                        _cvData.skills.add(_skillController.text);
                        _skillController.clear();
                      });
                    }
                  },
                  icon: const Icon(Icons.add_circle, color: AppColors.primary),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              children: _cvData.skills.map((skill) => Chip(
                label: Text(skill, style: const TextStyle(color: Colors.white)),
                backgroundColor: AppColors.surface,
                onDeleted: () => setState(() => _cvData.skills.remove(skill)),
                deleteIconColor: Colors.red,
              )).toList(),
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generateAndPreview,
        label: const Text("Generate CV"),
        icon: const Icon(Icons.download),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String)? onChanged, {int maxLines = 1, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildExperienceForm(int index) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          _buildTextField("Job Title", (v) => _cvData.experience[index].jobTitle = v),
          _buildTextField("Company", (v) => _cvData.experience[index].company = v),
          _buildTextField("Description", (v) => _cvData.experience[index].description = v, maxLines: 2),
        ],
      ),
    );
  }

  Widget _buildEducationForm(int index) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          _buildTextField("Degree", (v) => _cvData.education[index].degree = v),
          _buildTextField("School/University", (v) => _cvData.education[index].school = v),
          _buildTextField("Year", (v) => _cvData.education[index].year = v),
        ],
      ),
    );
  }
}
