import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class GuideDetailsScreen extends StatelessWidget {
  final String title;
  final String content;

  const GuideDetailsScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guide Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Article",
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white10),
            const SizedBox(height: 20),
            Text(
              content == "..." ? _getSampleContent() : content,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: AppColors.textPrimary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSampleContent() {
    return "Finding the right path after graduation can be overwhelming. This guide is designed to help you navigate the complexities of the professional world or further academia. \n\n"
        "Key Takeaways:\n"
        "1. Start early: Most successful students begin their search 6 months before graduation.\n"
        "2. Network: 70% of jobs are never posted on job boards.\n"
        "3. Customize: Your resume should be tailored to each specific application.\n\n"
        "In this article, we will deep dive into the specific strategies that top-tier students use to secure their dream positions. Whether you are looking for an internship at a Fortune 500 company or applying for a PhD program in Europe, the fundamentals remain the same: Preparation, Persistence, and Presentation.";
  }
}
