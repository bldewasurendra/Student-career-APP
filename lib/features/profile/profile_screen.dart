import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/admin_access.dart';
import '../../core/app_colors.dart';
import '../../widgets/custom_card.dart';
import '../../services/firebase_service.dart';
import '../admin/admin_dashboard.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';
import 'saved_screen.dart';
import 'support_chat_screen.dart';
import 'applied_jobs_screen.dart';
import 'about_uni_path_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isStudentView = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadStudentViewPreference();
  }

  String _studentViewPreferenceKey(String uid) => 'profile_student_view_$uid';

  Future<void> _loadStudentViewPreference() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || !AdminAccess.isAllowedUser(user)) return;

    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getBool(_studentViewPreferenceKey(user.uid)) ?? false;

    if (mounted) {
      setState(() {
        _isStudentView = savedValue;
      });
    }
  }

  Future<void> _setStudentView(bool value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _isStudentView = value;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_studentViewPreferenceKey(user.uid), value);
  }

  Future<void> _pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Show a loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Uploading profile picture...")),
      );

      // Upload to Firebase Storage
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_profiles')
          .child('${user.uid}.jpg');
      await ref.putFile(File(image.path));

      // Get download URL
      final url = await ref.getDownloadURL();

      // Update user profile
      await user.updatePhotoURL(url);

      // Update Firestore if you store user data there
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'photoURL': url}, SetOptions(merge: true));

      // Refresh the UI
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile picture updated!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload image: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isActuallyAdmin = AdminAccess.isAllowedUser(user);
    final showAdminFeatures = isActuallyAdmin && !_isStudentView;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
          if (isActuallyAdmin)
            Row(
              children: [
                const Text(
                  "Student View",
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
                Switch(
                  value: _isStudentView,
                  activeThumbColor: AppColors.primary,
                  onChanged: _setStudentView,
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
                  GestureDetector(
                    onTap: _pickAndUploadImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          backgroundImage: user?.photoURL != null
                              ? NetworkImage(user!.photoURL!)
                              : null,
                          child: user?.photoURL == null
                              ? Text(
                                  user?.email?[0].toUpperCase() ?? "U",
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                )
                              : null,
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    user?.displayName ??
                        (showAdminFeatures
                            ? "System Administrator"
                            : "Future Graduate"),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
                _buildStatCard(
                  "Saved",
                  "View",
                  Icons.bookmark_outline,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SavedScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 15),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseService().getAppliedJobs(),
                  builder: (context, snapshot) {
                    final count = snapshot.hasData
                        ? snapshot.data!.docs.length.toString().padLeft(2, '0')
                        : "00";
                    return _buildStatCard(
                      "Applied",
                      count,
                      Icons.send_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppliedJobsScreen(),
                          ),
                        );
                      },
                    );
                  },
                ),
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
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminDashboard(),
                  ),
                ),
              ),

            _buildOption(
              context,
              Icons.person_outline,
              "Personal Information",
              subtitle: "Update your name",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              ),
            ),
            _buildOption(
              context,
              Icons.security_outlined,
              "Security",
              subtitle: "Change password & 2FA",
              onTap: () => _showSecurityDialog(context),
            ),

            const SizedBox(height: 20),
            _buildSectionTitle("General"),
            _buildOption(
              context,
              Icons.help_outline,
              "Help & Support",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SupportChatScreen(),
                ),
              ),
            ),
            _buildOption(
              context,
              Icons.info_outline,
              "About UniPath",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutUniPathScreen(),
                ),
              ),
            ),

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
                  Text(
                    "Logout Account",
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
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
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.white54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 15),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  void _showSecurityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          "Security Settings",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Would you like to reset your password? We will send a reset link to your email.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null && user.email != null) {
                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: user.email!,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Password reset email sent!")),
                );
              }
            },
            child: const Text(
              "Send Email",
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    IconData icon,
    String title, {
    String? subtitle,
    Color? color,
    VoidCallback? onTap,
  }) {
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
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
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
