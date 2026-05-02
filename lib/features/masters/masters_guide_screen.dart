import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class MastersGuideScreen extends StatelessWidget {
  const MastersGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Higher Studies Guide", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDecisionCard(),
            const SizedBox(height: 30),
            const Text(
              "Study in Sri Lanka (Local)",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildInfoCard("Main Institutes", "UoM, UoC, SLIIT, NSBM, and Open University offer recognized Masters & PhDs.", Icons.account_balance_outlined, Colors.blue),
            _buildInfoCard("Requirements", "Usually a 4-year degree or a 3-year degree with work experience.", Icons.assignment_turned_in_outlined, Colors.green),
            
            const SizedBox(height: 30),
            const Text(
              "Study Abroad (International)",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildInfoCard("Preparation", "Start 1 year early. Prepare for IELTS/PTE and GRE/GMAT if required.", Icons.timer_outlined, Colors.orange),
            _buildInfoCard("Documents Needed", "SOP (Statement of Purpose), LOR (Letters of Recommendation), and Transcripts.", Icons.description_outlined, Colors.purple),
            _buildInfoCard("Scholarships", "Look for Commonwealth, Fulbright, or University-specific funding.", Icons.card_membership_outlined, Colors.teal),
            
            const SizedBox(height: 30),
            const Text(
              "How to Prepare? (Checklist)",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildStepItem("1", "Choose Your Research Area", "Find what you are passionate about exploring deeper."),
            _buildStepItem("2", "Language Proficiency", "Take IELTS or PTE and score at least 6.5 - 7.0 for top universities."),
            _buildStepItem("3", "Find a Supervisor", "For PhDs, you often need to find a professor who matches your research."),
            _buildStepItem("4", "Financial Planning", "Check costs, visa requirements, and proof of funds."),
            
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildDecisionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purple, Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.school, color: Colors.white, size: 30),
          SizedBox(height: 15),
          Text(
            "Local or Global?\nYour Path to PhD",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
          ),
          SizedBox(height: 10),
          Text(
            "Deciding where to do your Masters or PhD depends on your career goals and research interests.",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String desc, IconData icon, Color color) {
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
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text(desc, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(String number, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.purple,
            child: Text(number, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                Text(desc, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
