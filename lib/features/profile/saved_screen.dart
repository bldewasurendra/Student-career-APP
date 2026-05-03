import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/app_colors.dart';
import '../../models/models.dart';
import '../../services/firebase_service.dart';
import '../jobs/job_details_screen.dart';
import '../study_abroad/program_details_screen.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Saved Items", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseService().getSavedItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 60, color: Colors.white24),
                  SizedBox(height: 15),
                  Text("No saved items yet", style: TextStyle(color: Colors.white38)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final category = data['category'] ?? 'job';

              return Card(
                color: AppColors.surface,
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: category == 'job' 
                      ? const Icon(Icons.work_outline, color: AppColors.primary)
                      : const Icon(Icons.school_outlined, color: Colors.purpleAccent),
                  title: Text(data['title'] ?? 'Title', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    category == 'job' 
                        ? "${data['company']} • ${data['location']}"
                        : "${data['university']} • ${data['country']}",
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.error),
                    onPressed: () => FirebaseService().toggleBookmark(doc.id, {}),
                  ),
                  onTap: () {
                    if (category == 'job') {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => JobDetailsScreen(
                        job: JobModel(
                          id: doc.id,
                          title: data['title'] ?? '',
                          company: data['company'] ?? '',
                          location: data['location'] ?? '',
                          salary: data['salary'] ?? '',
                          logoUrl: data['logoUrl'] ?? '',
                          type: data['type'] ?? '',
                          postedDate: 'Recently',
                          description: data['description'] ?? '',
                        ),
                      )));
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProgramDetailsScreen(
                        program: ProgramModel(
                          id: doc.id,
                          title: data['title'] ?? '',
                          university: data['university'] ?? '',
                          country: data['country'] ?? '',
                          imageUrl: data['imageUrl'] ?? '',
                          duration: data['duration'] ?? '',
                          cost: data['cost'] ?? '',
                          requirements: data['requirements'] ?? '',
                          description: data['description'] ?? '',
                        ),
                      )));
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
