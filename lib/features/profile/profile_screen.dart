import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/app_colors.dart';
import '../../widgets/custom_card.dart';
import '../admin/admin_dashboard.dart';

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

  bool _isStudentView = false; // Toggle for Admin to see as Student

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isActuallyAdmin = user != null && adminEmails.contains(user.email);
    
    // Show Admin features only if user is Admin AND not in Student View
    final showAdminFeatures = isActuallyAdmin && !_isStudentView;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          if (isActuallyAdmin)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const Text("Student View", style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  Switch(
                    value: _isStudentView,
                    onChanged: (value) {
                      setState(() {
                        _isStudentView = value;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isStudentView ? "Switched to Student View" : "Switched to Admin View"),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                user?.email?[0].toUpperCase() ?? "S",
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              showAdminFeatures ? "Administrator" : "Future Graduate",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.email ?? "student@unipath.edu",
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 30),
            
            if (showAdminFeatures)
              _buildProfileItem(
                context,
                Icons.admin_panel_settings_outlined,
                "Admin Dashboard",
                Colors.amber,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminDashboard()),
                  );
                },
              ),
              
            _buildProfileItem(
              context,
              Icons.bookmark_outline,
              "Saved Guides",
              AppColors.primary,
              () {},
            ),
            _buildProfileItem(
              context,
              Icons.history,
              "Watch History",
              AppColors.primary,
              () {},
            ),
            _buildProfileItem(
              context,
              Icons.help_outline,
              "Help & Support",
              AppColors.primary,
              () {},
            ),
            
            const SizedBox(height: 20),
            CustomCard(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: AppColors.error),
                  SizedBox(width: 10),
                  Text("Logout", style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, IconData icon, String title, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: CustomCard(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(width: 15),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const Spacer(),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
