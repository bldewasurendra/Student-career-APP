import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_colors.dart';
import 'cv_form_screen.dart';

class CvBuilderScreen extends StatefulWidget {
  const CvBuilderScreen({super.key});

  @override
  State<CvBuilderScreen> createState() => _CvBuilderScreenState();
}

class _CvBuilderScreenState extends State<CvBuilderScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _animController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  final String _exampleTemplate = """
John Doe
johndoe@email.com | +1 555 123 4567 | LinkedIn: linkedin.com/in/johndoe

Professional Summary
----------------------
Results‑driven Marketing Analyst with 5+ years of experience optimizing campaigns via data‑driven insights. Skilled in SEO, Google Analytics, and A/B testing.

Work Experience
--------------
Marketing Analyst – XYZ Corp (Jan 2020 – Present)
- Increased organic traffic by 45% YoY through SEO strategy.
- Managed 200000 ad spend, delivering 30% ROI uplift.

Education
---------
B.Sc. Business Administration – University of Example (2015‑2019)

Skills
------
- SEO, Google Analytics, Data Analysis, SQL, Tableau, Content Strategy
""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('CV Builder', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ATS‑Friendly CV Guidance', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 15),
            const Text(
              '• Use standard headings (Professional Summary, Work Experience, Education, Skills).\n'
              '• Keep fonts simple – Arial, Calibri, or Times New Roman, 10‑12pt.\n'
              '• Avoid tables, images, or graphics – ATS reads plain text only.\n'
              '• Include keywords from the job description.\n'
              '• Save as .docx or PDF (text‑based).',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 25),
            const Text('Example ATS‑Friendly Template', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            FadeTransition(
              opacity: _fadeAnim,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 4)),
                  ],
                ),
                child: SelectableText(
                  _exampleTemplate,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 14, color: Colors.white70),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: _exampleTemplate));
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Template copied to clipboard')));
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              icon: const Icon(Icons.copy, color: Colors.white),
              label: const Text('Copy Template', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 30),
            const Text('Save your CV to your profile for later editing.', style: TextStyle(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CVFormScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Build Your CV Now', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
