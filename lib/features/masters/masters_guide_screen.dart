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
            _buildInfoCard(
              context,
              title: "Main Institutes",
              desc: "UoM, UoC, SLIIT, NSBM, and Open University offer recognized Masters & PhDs.",
              icon: Icons.account_balance_outlined,
              color: Colors.blue,
              details: const [
                "Universities and institutes offer coursework and research degrees.",
                "Some programs are full-time while others support part-time study.",
                "Always check the university faculty page for current intake dates.",
              ],
            ),
            _buildInfoCard(
              context,
              title: "Requirements",
              desc: "Usually a 4-year degree or a 3-year degree with work experience.",
              icon: Icons.assignment_turned_in_outlined,
              color: Colors.green,
              details: const [
                "A relevant bachelor’s degree is the most common requirement.",
                "Some universities accept a shorter degree with recognized work experience.",
                "A research proposal may be needed for thesis-based programs.",
              ],
            ),
            
            const SizedBox(height: 30),
            const Text(
              "Study Abroad (International)",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildInfoCard(
              context,
              title: "Preparation",
              desc: "Start 1 year early. Prepare for IELTS/PTE and GRE/GMAT if required.",
              icon: Icons.timer_outlined,
              color: Colors.orange,
              details: const [
                "Shortlist countries and universities first.",
                "Prepare language tests early because result validity matters.",
                "Plan finances, application deadlines, and visa timelines together.",
              ],
            ),
            _buildInfoCard(
              context,
              title: "Documents Needed",
              desc: "SOP (Statement of Purpose), LOR (Letters of Recommendation), and Transcripts.",
              icon: Icons.description_outlined,
              color: Colors.purple,
              details: const [
                "Statement of Purpose should explain your goals clearly.",
                "Letters of Recommendation should come from lecturers or supervisors.",
                "Certified transcripts and passport copies are commonly required.",
              ],
            ),
            _buildInfoCard(
              context,
              title: "Scholarships",
              desc: "Look for Commonwealth, Fulbright, or University-specific funding.",
              icon: Icons.card_membership_outlined,
              color: Colors.teal,
              details: const [
                "Check government scholarships and university merit awards.",
                "Some scholarships require strong academic results and a research plan.",
                "Apply early because funding deadlines can close before admissions.",
              ],
            ),
            
            const SizedBox(height: 30),
            const Text(
              "How to Prepare? (Checklist)",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildStepItem(
              context,
              number: "1",
              title: "Choose Your Research Area",
              desc: "Find what you are passionate about exploring deeper.",
              details: const [
                "Pick a topic that matches your background and long-term career goals.",
                "Read recent papers so your idea is current and relevant.",
                "Think about available supervisors and lab resources too.",
              ],
            ),
            _buildStepItem(
              context,
              number: "2",
              title: "Language Proficiency",
              desc: "Take IELTS or PTE and score at least 6.5 - 7.0 for top universities.",
              details: const [
                "Choose the exam required by your target university.",
                "Practice all four skills: speaking, listening, reading, and writing.",
                "Retake the test early if your score is below the requirement.",
              ],
            ),
            _buildStepItem(
              context,
              number: "3",
              title: "Find a Supervisor",
              desc: "For PhDs, you often need to find a professor who matches your research.",
              details: const [
                "Send a short, professional email with your research interest.",
                "Attach your CV, transcript, and a brief proposal if needed.",
                "Look for supervisors whose published work matches your idea.",
              ],
            ),
            _buildStepItem(
              context,
              number: "4",
              title: "Financial Planning",
              desc: "Check costs, visa requirements, and proof of funds.",
              details: const [
                "Include tuition, living costs, insurance, and travel expenses.",
                "Compare scholarship options before making final decisions.",
                "Keep enough time for visa paperwork and bank statements.",
              ],
            ),
            
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

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required List<String> details,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GuideDetailScreen(
              title: title,
              description: desc,
              icon: icon,
              color: color,
              details: details,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
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
                  const SizedBox(height: 6),
                  const Text(
                    "Tap to view more details",
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(
    BuildContext context, {
    required String number,
    required String title,
    required String desc,
    required List<String> details,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GuideDetailScreen(
              title: title,
              description: desc,
              icon: Icons.check_circle_outline,
              color: Colors.purple,
              details: details,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
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
                  const SizedBox(height: 4),
                  const Text(
                    "Tap to open details",
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GuideDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> details;

  const GuideDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.75)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 34),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          description,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Details",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...details.map(
              (detail) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: color.withValues(alpha: 0.25)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.arrow_right, color: color, size: 22),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        detail,
                        style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
