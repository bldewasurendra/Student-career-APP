import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/app_colors.dart';
import '../jobs/job_details_screen.dart';
import '../masters/masters_guide_screen.dart';
import '../../models/models.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;
  const SearchResultsScreen({super.key, required this.query});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Search: ${widget.query}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Searching in multiple collections is complex in Firestore, 
        // so we'll search in 'jobs' as a primary example.
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .where('title', isGreaterThanOrEqualTo: widget.query)
            .where('title', isLessThanOrEqualTo: widget.query + '\uf8ff')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text("No results found", style: TextStyle(color: Colors.white70)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final job = JobModel(
                id: docs[index].id,
                title: data['title'] ?? '',
                company: data['company'] ?? '',
                location: data['location'] ?? '',
                salary: data['salary'] ?? '',
                logoUrl: data['logoUrl'] ?? '',
                type: data['type'] ?? '',
                postedDate: 'Recent',
                description: data['description'] ?? '',
              );

              return Card(
                color: AppColors.surface,
                margin: const EdgeInsets.only(bottom: 15),
                child: ListTile(
                  title: Text(job.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(job.company, style: const TextStyle(color: AppColors.primary)),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => JobDetailsScreen(job: job))),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
