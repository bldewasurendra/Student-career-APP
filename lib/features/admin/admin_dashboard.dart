import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/models.dart';
import '../../services/firebase_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();

  String _selectedCategory = 'Jobs';
  final List<String> _categories = ['Jobs', 'Internships', 'Masters', 'Study Abroad'];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _companyOrUniController = TextEditingController();
  final TextEditingController _locationOrCountryController = TextEditingController();
  final TextEditingController _salaryOrCostController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _typeOrDurationController = TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;

  void _submitData() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      if (_selectedCategory == 'Jobs' || _selectedCategory == 'Internships') {
        final job = JobModel(
          id: '',
          title: _titleController.text,
          company: _companyOrUniController.text,
          location: _locationOrCountryController.text,
          salary: _salaryOrCostController.text,
          logoUrl: _imageUrlController.text.isNotEmpty ? _imageUrlController.text : 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=150&auto=format&fit=crop&q=60',
          type: _typeOrDurationController.text,
          postedDate: 'Just now',
          description: _descriptionController.text,
        );
        await _firebaseService.addJob(job, _selectedCategory.toLowerCase());
        await _firebaseService.addNotification(
          "New $_selectedCategory Added!",
          "${job.title} is now available at ${job.company}.",
        );
      } else {
        final program = ProgramModel(
          id: '',
          title: _titleController.text,
          university: _companyOrUniController.text,
          country: _locationOrCountryController.text,
          imageUrl: _imageUrlController.text.isNotEmpty ? _imageUrlController.text : 'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=400&auto=format&fit=crop&q=60',
          duration: _typeOrDurationController.text,
          cost: _salaryOrCostController.text,
          requirements: _requirementsController.text,
          description: _descriptionController.text,
        );
        await _firebaseService.addProgram(program, _selectedCategory.toLowerCase().replaceAll(' ', '_'));
        await _firebaseService.addNotification(
          "New $_selectedCategory Opportunity!",
          "${program.title} at ${program.university} is now open for applications.",
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$_selectedCategory Added!')));
      _clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearForm() {
    _titleController.clear();
    _companyOrUniController.clear();
    _locationOrCountryController.clear();
    _salaryOrCostController.clear();
    _imageUrlController.clear();
    _typeOrDurationController.clear();
    _requirementsController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          title: const Text("Admin Panel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.add_circle_outline), text: "Add Content"),
              Tab(icon: Icon(Icons.manage_accounts_outlined), text: "Manage Data"),
            ],
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: TabBarView(
          children: [
            _buildAddContentTab(),
            _buildManageDataTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddContentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Category", style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(15)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  dropdownColor: AppColors.surface,
                  isExpanded: true,
                  style: const TextStyle(color: Colors.white),
                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => _selectedCategory = v!),
                ),
              ),
            ),
            const SizedBox(height: 25),
            _buildField(_titleController, "Title"),
            _buildField(_companyOrUniController, _selectedCategory.contains('Job') ? "Company" : "University"),
            _buildField(_locationOrCountryController, "Location/Country"),
            _buildField(_salaryOrCostController, _selectedCategory.contains('Job') ? "Salary" : "Cost"),
            _buildField(_typeOrDurationController, _selectedCategory.contains('Job') ? "Type" : "Duration"),
            _buildField(_imageUrlController, "Image URL (Optional)"),
            if (!_selectedCategory.contains('Job')) _buildField(_requirementsController, "Requirements", maxLines: 2),
            _buildField(_descriptionController, "Description", maxLines: 4),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitData,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Publish Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildManageDataTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.analytics_outlined, size: 80, color: AppColors.primary),
          const SizedBox(height: 20),
          const Text("Live Management Console", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("Coming Soon: View & Delete functionality.", style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 30),
          _buildStatRow("Jobs", "12"),
          _buildStatRow("Masters", "8"),
          _buildStatRow("Internships", "5"),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
            child: Text(count, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white38),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
        validator: (v) => v!.isEmpty ? "Required" : null,
      ),
    );
  }
}
