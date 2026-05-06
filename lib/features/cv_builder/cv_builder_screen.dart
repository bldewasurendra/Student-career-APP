import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_colors.dart';
import '../../widgets/custom_card.dart';
import 'ats_cv_editor_screen.dart';
import 'cv_form_screen.dart';

class CvBuilderScreen extends StatefulWidget {
  const CvBuilderScreen({super.key});

  @override
  State<CvBuilderScreen> createState() => _CvBuilderScreenState();
}

class _CvBuilderScreenState extends State<CvBuilderScreen> {
  final String _exampleTemplate = """
John Doe
johndoe@email.com | +1 555 123 4567 | LinkedIn: linkedin.com/in/johndoe

Professional Summary
----------------------
Results-driven Marketing Analyst with 5+ years of experience optimizing campaigns via data-driven insights. Skilled in SEO, Google Analytics, and A/B testing.

Work Experience
--------------
Marketing Analyst – XYZ Corp (Jan 2020 – Present)
- Increased organic traffic by 45% YoY through SEO strategy.
- Managed \$200,000 ad spend, delivering 30% ROI uplift.

Education
---------
B.Sc. Business Administration – University of Example (2015-2019)

Skills
------
- SEO, Google Analytics, Data Analysis, SQL, Tableau, Content Strategy
""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('CV Builder', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBuilderOption(
              context,
              icon: Icons.article_outlined,
              title: "Standard CV Builder",
              subtitle: "Create a professional CV with our guided form. Fill in your details and we'll generate a clean, formatted document for you.",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CVFormScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildBuilderOption(
              context,
              icon: Icons.text_fields_outlined,
              title: "ATS-Friendly CV Editor",
              subtitle: "Use a plain-text editor to create a CV optimized for Applicant Tracking Systems. Start with our template and customize it.",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AtsCvEditorScreen(initialText: _exampleTemplate),
                  ),
                );
              },
            ),
            const SizedBox(height: 25),
            _buildAtsGuidance(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBuilderOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return CustomCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white38, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAtsGuidance(BuildContext context) {
    return ExpansionTile(
      title: const Text(
        'ATS-Friendly CV Guide',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      subtitle: const Text(
        'Learn how to beat the bots.',
        style: TextStyle(color: Colors.white70),
      ),
      iconColor: AppColors.primary,
      collapsedIconColor: Colors.white54,
      children: [
        const SizedBox(height: 15),
        const Text(
          'Applicant Tracking Systems (ATS) are used by most companies to scan CVs. To ensure your CV gets seen by a human, follow these rules:\n\n'
          '• Use standard headings (e.g., "Work Experience").\n'
          '• Use simple fonts like Arial or Calibri.\n'
          '• Avoid tables, columns, images, or graphics.\n'
          '• Include keywords from the job description.\n'
          '• Save your final CV as a text-based PDF or .docx file.',
          style: TextStyle(fontSize: 15, color: Colors.white70),
        ),
        const SizedBox(height: 25),
        const Text(
          'Example ATS-Friendly Template',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: SelectableText(
            _exampleTemplate,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13, color: Colors.white70),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: _exampleTemplate));
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ATS template copied to clipboard')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary.withOpacity(0.8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.copy, color: Colors.white, size: 18),
          label: const Text('Copy Template', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
