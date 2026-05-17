import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../features/home/home_screen.dart';
import '../features/learning/video_learning_screen.dart';
import '../features/guides/guide_list_screen.dart';
import '../features/profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const GuideListScreen(category: 'Internships'),
    const VideoLearningScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 10),
        decoration: BoxDecoration(
          color: AppColors.background,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: AppColors.primary.withValues(alpha: 0.1),
              labelTextStyle: WidgetStateProperty.all(
                const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              backgroundColor: AppColors.surface,
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined, size: 24),
                  selectedIcon: Icon(Icons.home, size: 24, color: AppColors.primary),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.explore_outlined, size: 24),
                  selectedIcon: Icon(Icons.explore, size: 24, color: AppColors.primary),
                  label: 'Guides',
                ),
                NavigationDestination(
                  icon: Icon(Icons.play_circle_outline, size: 24),
                  selectedIcon: Icon(Icons.play_circle, size: 24, color: AppColors.primary),
                  label: 'Learning',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline, size: 24),
                  selectedIcon: Icon(Icons.person, size: 24, color: AppColors.primary),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
