import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/custom_card.dart';
import 'guide_details_screen.dart';

class GuideListScreen extends StatelessWidget {
  final String category;

  const GuideListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Mock data based on category
    final List<Map<String, String>> guides = _getGuidesForCategory(category);

    return Scaffold(
      appBar: AppBar(
        title: Text("$category Guidance"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: guides.length,
        itemBuilder: (context, index) {
          final guide = guides[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: CustomCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GuideDetailsScreen(
                      title: guide['title']!,
                      content: guide['content']!,
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.description, color: AppColors.primary),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          guide['title']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          guide['subtitle']!,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Map<String, String>> _getGuidesForCategory(String category) {
    switch (category) {
      case 'Internships':
        return [
          {'title': 'Finding Your First Internship', 'subtitle': 'A step-by-step guide for beginners', 'content': '...'},
          {'title': 'Nailing the Interview', 'subtitle': 'Common questions and best answers', 'content': '...'},
          {'title': 'LinkedIn Optimization', 'subtitle': 'How to get noticed by recruiters', 'content': '...'},
        ];
      case 'Jobs':
        return [
          {'title': 'Full-time vs Freelance', 'subtitle': 'Which path is right for you?', 'content': '...'},
          {'title': 'Negotiating Your Salary', 'subtitle': 'Don\'t leave money on the table', 'content': '...'},
          {'title': 'Corporate Culture 101', 'subtitle': 'What to expect in your first job', 'content': '...'},
        ];
      case 'Masters':
        return [
          {'title': 'Choosing a Specialization', 'subtitle': 'Aligning your MS with your goals', 'content': '...'},
          {'title': 'Writing a Killer SOP', 'subtitle': 'The secret to getting admitted', 'content': '...'},
          {'title': 'Scholarship Search', 'subtitle': 'How to fund your further education', 'content': '...'},
        ];
      case 'Study Abroad':
        return [
          {'title': 'Top Countries for Students', 'subtitle': 'Cost vs Quality of Education', 'content': '...'},
          {'title': 'Visa Application Process', 'subtitle': 'Everything you need to know', 'content': '...'},
          {'title': 'Lifestyle as an International Student', 'subtitle': 'Adapting to a new culture', 'content': '...'},
        ];
      default:
        return [];
    }
  }
}
