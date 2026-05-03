import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/app_colors.dart';
import '../../widgets/custom_card.dart';
import '../guides/guide_list_screen.dart';
import '../jobs/jobs_screen.dart';
import '../study_abroad/programs_screen.dart';
import '../masters/masters_screen.dart';
import '../internships/internships_screen.dart';
import '../cv_builder/cv_form_screen.dart';
import '../portfolio_guide/portfolio_guide_screen.dart';
import '../notifications/notifications_screen.dart';
import '../search/search_screen.dart';
import '../../services/firebase_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(context),
              const SizedBox(height: 30),
              _buildSearchBar(context),
              const SizedBox(height: 35),
              _buildSectionTitle("Explore Paths"),
              const SizedBox(height: 20),
              _buildCategoryGrid(context),
              const SizedBox(height: 35),
              _buildSectionTitle("Recently Added Videos"),
              const SizedBox(height: 20),
              _buildVideoSlides(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset("assets/images/logo.png", height: 50),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, ${FirebaseAuth.instance.currentUser?.displayName ?? 'Student'}!",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  "Find Your Path",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsScreen()),
            );
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: const Icon(Icons.notifications_outlined, size: 22, color: Colors.white),
              ),
              StreamBuilder<int>(
                stream: FirebaseService().getUnreadNotificationCount(),
                builder: (context, snapshot) {
                  final count = snapshot.data ?? 0;
                  if (count == 0) return const SizedBox.shrink();
                  
                  return Positioned(
                    right: -5,
                    top: -5,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                      child: Text(
                        count > 9 ? "9+" : count.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(Icons.search, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 10),
            Text(
              "Search for guidance...",
              style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text("See All", style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    final categories = [
      {'title': 'Internships', 'icon': Icons.work_outline, 'color': Colors.blue},
      {'title': 'Jobs', 'icon': Icons.business_center_outlined, 'color': Colors.green},
      {'title': 'Masters', 'icon': Icons.school_outlined, 'color': Colors.purple},
      {'title': 'Study Abroad', 'icon': Icons.public, 'color': Colors.orange},
      {'title': 'CV Builder', 'icon': Icons.history_edu, 'color': Colors.teal},
      {'title': 'Portfolio', 'icon': Icons.folder_shared_outlined, 'color': Colors.indigo},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return CustomCard(
          onTap: () {
            final title = cat['title'] as String;
            if (title == 'Jobs') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const JobsScreen()),
              );
            } else if (title == 'Masters') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MastersScreen()),
              );
            } else if (title == 'Study Abroad') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProgramsScreen(category: 'Study Abroad')),
              );
            } else if (title == 'Internships') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InternshipsScreen()),
              );
            } else if (title == 'CV Builder') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CVFormScreen()),
              );
            } else if (title == 'Portfolio') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PortfolioGuideScreen()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GuideListScreen(category: title),
                ),
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (cat['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(cat['icon'] as IconData, color: cat['color'] as Color),
              ),
              const SizedBox(height: 12),
              Text(
                cat['title'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVideoSlides() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: NetworkImage("https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&auto=format&fit=crop&q=60"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Resume Building 101",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "12:45",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
