import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/custom_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("App Settings"),
            _buildSettingItem(Icons.notifications_outlined, "Push Notifications", true),
            _buildSettingItem(Icons.dark_mode_outlined, "Dark Mode", true),
            _buildSettingItem(Icons.language, "Language", false, trailing: "English"),
            
            const SizedBox(height: 30),
            _buildSectionTitle("Privacy & Security"),
            _buildSettingItem(Icons.lock_outline, "Privacy Policy", false),
            _buildSettingItem(Icons.description_outline, "Terms of Service", false),
            
            const SizedBox(height: 30),
            _buildSectionTitle("Support"),
            _buildSettingItem(Icons.help_outline, "Help Center", false),
            _buildSettingItem(Icons.bug_report_outline, "Report a Bug", false),
            
            const SizedBox(height: 40),
            const Center(
              child: Text("UniPath Version 1.0.0", style: TextStyle(color: Colors.white24, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 15),
      child: Text(title, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, bool isSwitch, {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        onTap: () {},
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 22),
            const SizedBox(width: 15),
            Expanded(
              child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
            ),
            if (isSwitch)
              Switch(value: true, onChanged: (v) {}, activeColor: AppColors.primary)
            else if (trailing != null)
              Text(trailing, style: const TextStyle(color: Colors.white38, fontSize: 14))
            else
              const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
          ],
        ),
      ),
    );
  }
}
