import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/models.dart';
import '../../services/firebase_service.dart';
import '../jobs/job_details_screen.dart';
import '../study_abroad/program_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final List<JobModel> jobs = await _firebaseService.searchJobs(query, 'jobs');
      final List<JobModel> internships = await _firebaseService.searchJobs(query, 'internships');
      final List<ProgramModel> masters = await _firebaseService.searchPrograms(query, 'masters');
      final List<ProgramModel> abroad = await _firebaseService.searchPrograms(query, 'study_abroad');

      setState(() {
        _searchResults = [...jobs, ...internships, ...masters, ...abroad];
      });
    } catch (e) {
      debugPrint("Search error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Search for jobs, masters, etc...",
            hintStyle: TextStyle(color: Colors.white38),
            border: InputBorder.none,
          ),
          onChanged: _performSearch,
        ),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty 
              ? const Center(child: Text("No results found", style: TextStyle(color: Colors.white38)))
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final item = _searchResults[index];
                    if (item is JobModel) {
                      return _buildJobResult(item);
                    } else if (item is ProgramModel) {
                      return _buildProgramResult(item);
                    }
                    return const SizedBox.shrink();
                  },
                ),
    );
  }

  Widget _buildJobResult(JobModel job) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.work_outline, color: AppColors.primary),
        title: Text(job.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text("${job.company} • ${job.location}", style: const TextStyle(color: Colors.white54)),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => JobDetailsScreen(job: job))),
      ),
    );
  }

  Widget _buildProgramResult(ProgramModel program) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.school_outlined, color: Colors.purpleAccent),
        title: Text(program.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text("${program.university} • ${program.country}", style: const TextStyle(color: Colors.white54)),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProgramDetailsScreen(program: program))),
      ),
    );
  }
}
