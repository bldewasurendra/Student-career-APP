import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/app_colors.dart';
import '../../widgets/custom_card.dart';

import '../admin/admin_dashboard.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<String> adminEmails = [
    'admin@unipath.com',
    'oktech@gmail.com',
    'lenminibhagya@gmail.com',
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isAdmin = user != null && adminEmails.contains(user.email);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage("https://ui-avatars.com/api/?name=Student+User&background=6366F1&color=fff"),
            ),
            const SizedBox(height: 15),
            const Text(
              "Future Graduate",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.email ?? "student@unipath.edu",
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 30),
            _buildProfileItem(
              context,
              Icons.bookmark_outline,
              "Saved Guides",
              () {},
            ),
            if (isAdmin)
              _buildProfileItem(
                context,
                Icons.admin_panel_settings_outlined,
                "Admin Dashboard",
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminDashboard()),
                  );
                },
              ),
            _buildProfileItem(
              context,
              Icons.history,
              "Watch History",
              () {},
            ),
            const SizedBox(height: 20),
            CustomCard(
              onTap: () {},
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

  Widget _buildProfileItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: CustomCard(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 15),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const Spacer(),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

