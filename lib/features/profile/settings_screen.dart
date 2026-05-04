import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/theme_provider.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_card.dart';
import 'support_chat_screen.dart';

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
            _buildSettingItem(Icons.notifications_outlined, "Push Notifications", true, value: true, onChanged: (v) {}),
            Consumer<ThemeProvider>(
              builder: (context, theme, _) => _buildSettingItem(
                Icons.dark_mode_outlined, 
                "Dark Mode", 
                true, 
                value: theme.isDarkMode,
                onChanged: (v) => theme.toggleTheme(),
              ),
            ),
            _buildSettingItem(
              Icons.language,
              "Language",
              false,
              trailing: "English",
              onTap: () => _showLanguageDialog(context),
            ),

            const SizedBox(height: 30),
            _buildSectionTitle("Privacy & Security"),
            _buildSettingItem(
              Icons.lock_outline,
              "Privacy Policy",
              false,
              onTap: () => _showInfoDialog(
                context,
                title: "Privacy Policy",
                message: "We only collect the data needed to run your account, save your activity, and improve app features.",
              ),
            ),
            _buildSettingItem(
              Icons.description,
              "Terms of Service",
              false,
              onTap: () => _showInfoDialog(
                context,
                title: "Terms of Service",
                message: "By using UniPath, you agree to use the app responsibly and follow the rules of the platform.",
              ),
            ),

            const SizedBox(height: 30),
            _buildSectionTitle("Support"),
            _buildSettingItem(
              Icons.help_outline,
              "Help Center",
              false,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportChatScreen())),
            ),
            _buildSettingItem(
              Icons.bug_report,
              "Report a Bug",
              false,
              onTap: () => _showInfoDialog(
                context,
                title: "Report a Bug",
                message: "If something is broken, send a message through Support Chat with the screen name and what happened.",
              ),
            ),

            const SizedBox(height: 40),
            const Center(
              child: Text(
                "UniPath Version 1.0.0",
                style: TextStyle(color: Colors.white24, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 15),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String title,
    bool isSwitch, {
    String? trailing,
    bool value = false,
    Function(bool)? onChanged,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 22),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            if (isSwitch)
              Switch(
                value: value,
                onChanged: onChanged,
                activeTrackColor: AppColors.primary,
              )
            else if (trailing != null)
              Text(
                trailing,
                style: const TextStyle(color: Colors.white38, fontSize: 14),
              )
            else
              const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text("Language", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Language selection is not configured yet. English is currently the default.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
