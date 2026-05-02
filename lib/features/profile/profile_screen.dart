import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/app_colors.dart';
import '../../widgets/custom_card.dart';
import '../admin/admin_dashboard.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const List<String> adminEmails = [
    'admin@unipath.com',
    'oktech@gmail.com',
    'lenminibhagya@gmail.com',
  ];

  bool _isStudentView = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isActuallyAdmin = user != null && adminEmails.contains(user.email);
    final showAdminFeatures = isActuallyAdmin && !_isStudentView;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("My Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
          ),
          if (isActuallyAdmin)
            Row(
              children: [
                const Text("Student View", style: TextStyle(fontSize: 12, color: Colors.white70)),
                Switch(
                  value: _isStudentView,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _isStudentView = v),
                ),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      user?.email?[0].toUpperCase() ?? "U",
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    user?.displayName ?? (showAdminFeatures ? "System Administrator" : "Future Graduate"),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user?.email ?? "Not logged in",
                    style: const TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 25),
            
            // Activity Stats
            Row(
              children: [
                _buildStatCard("Saved", "12", Icons.bookmark_outline),
                const SizedBox(width: 15),
                _buildStatCard("Applied", "05", Icons.send_outlined),
                const SizedBox(width: 15),
                _buildStatCard("Points", "250", Icons.star_outline),
              ],
            ),

            const SizedBox(height: 30),
            
            // Main Options
            _buildSectionTitle("Account Settings"),
            if (showAdminFeatures)
              _buildOption(
                context,
                Icons.admin_panel_settings_outlined,
                "Admin Dashboard",
                subtitle: "Manage jobs, programs & notifications",
                color: Colors.amber,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminDashboard())),
              ),
            
            _buildOption(
              context, 
              Icons.person_outline, 
              "Personal Information", 
              subtitle: "Update your name",
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen())),
            ),
            _buildOption(context, Icons.security_outlined, "Security", subtitle: "Change password & 2FA"),
            
            const SizedBox(height: 20),
            _buildSectionTitle("General"),
            _buildOption(context, Icons.help_outline, "Help & Support"),
            _buildOption(context, Icons.info_outline, "About UniPath"),
            
            const SizedBox(height: 30),
            
            // Logout
            CustomCard(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: AppColors.error),
                  SizedBox(width: 10),
                  Text("Logout Account", style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.white54)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 15),
        child: Text(title, style: const TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
      ),
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String title, {String? subtitle, Color? color, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        onTap: onTap ?? () {},
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (color ?? AppColors.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color ?? AppColors.primary, size: 22),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  if (subtitle != null) Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.white54)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
          ],
        ),
      ),
    );
  }
}
