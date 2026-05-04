import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_colors.dart';

class PortfolioGuideScreen extends StatelessWidget {
  const PortfolioGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Portfolio Guide", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 30),
            const Text(
              "Where to Build Your Portfolio?",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildPlatformCard(
              context,
              "GitHub",
              "Best for Developers and Programmers to host code.",
              Icons.code,
              Colors.purple,
              "https://github.com",
            ),
            _buildPlatformCard(
              context,
              "Behance",
              "Ideal for Graphic Designers and UI/UX artists.",
              Icons.palette_outlined,
              Colors.blue,
              "https://www.behance.net",
            ),
            _buildPlatformCard(
              context,
              "LinkedIn",
              "Great for all professionals to showcase achievements.",
              Icons.link,
              Colors.indigo,
              "https://www.linkedin.com",
            ),
            _buildPlatformCard(
              context,
              "Personal Web",
              "The most professional way. Build your own site.",
              Icons.language,
              Colors.teal,
              "https://www.google.com/search?q=build+your+portfolio+website",
            ),
            
            const SizedBox(height: 30),
            const Text(
              "How to Add a Project?",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildStepItem("1", "Clear Title", "Give your project a catchy and descriptive name."),
            _buildStepItem("2", "Problem Statement", "Explain what problem your project solves."),
            _buildStepItem("3", "Tech Stack", "List the languages, tools, and frameworks used."),
            _buildStepItem("4", "Visuals", "Add high-quality screenshots or a demo video."),
            _buildStepItem("5", "Your Role", "Clearly state what you contributed to the project."),
            
            const SizedBox(height: 30),
            _buildProTip(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.indigo, Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.folder_special, color: Colors.white, size: 30),
          SizedBox(height: 15),
          Text(
            "Build a Portfolio That\nGets You Hired",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
          ),
          SizedBox(height: 10),
          Text(
            "Showcase your real-world projects and prove your skills to employers beyond just words.",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformCard(
    BuildContext context,
    String name,
    String desc,
    IconData icon,
    Color color,
    String url,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: () => _openExternalLink(context, url),
            style: TextButton.styleFrom(
              foregroundColor: color,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              backgroundColor: color.withValues(alpha: 0.08),
            ),
            child: const Text("Open"),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(String number, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.indigo,
            child: Text(number, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProTip() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.teal.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.tips_and_updates, color: Colors.teal, size: 30),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Pro Tip!", style: TextStyle(color: Colors.teal, fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(
                  "Always focus on the 'Impact' your project had. Did it save time? Did it improve speed? Numbers speak louder than code.",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openExternalLink(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final canOpen = await canLaunchUrl(uri);

    if (!canOpen) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open the link.")),
        );
      }
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
