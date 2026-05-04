import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class AboutUniPathScreen extends StatelessWidget {
  const AboutUniPathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('About UniPath', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Student Career Guide App – UniPath',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 15),
            Text(
              'UniPath is a comprehensive platform designed for students to explore career opportunities, manage their learning resources, and connect with mentors.\n\nFeatures include:'
              '\n• Dark/Light mode with persistent settings\n• Admin dashboard for managing jobs, programs, and learning videos\n• Personalized profile and settings\n• Real‑time chat support\n• Bookmark and save resources\n\nOur mission is to empower students with the tools they need to navigate their academic and professional journeys successfully.',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 20),
            Text(
              'Contact us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              'Email: support@unipathapp.com\nWebsite: https://unipathapp.example.com',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
