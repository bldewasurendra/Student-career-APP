import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final List<String> _categories = ['Jobs', 'Internships', 'Masters', 'Study Abroad', 'Internship Guidance'];

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
      final categoryKey = _selectedCategory.toLowerCase().replaceAll(' ', '_');
      
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
        await _firebaseService.addJob(job, categoryKey);
        await _firebaseService.addNotification("New $_selectedCategory!", "${job.title} at ${job.company}.");
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
        await _firebaseService.addProgram(program, categoryKey);
        await _firebaseService.addNotification("New $_selectedCategory!", "${program.title} is now available.");
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
              Tab(icon: Icon(Icons.manage_search), text: "Manage All"),
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
            _buildField(_companyOrUniController, _selectedCategory.contains('Job') || _selectedCategory.contains('Internship') ? "Company" : "University"),
            _buildField(_locationOrCountryController, "Location/Country"),
            _buildField(_salaryOrCostController, _selectedCategory.contains('Job') || _selectedCategory.contains('Internship') ? "Salary" : "Cost"),
            _buildField(_typeOrDurationController, _selectedCategory.contains('Job') || _selectedCategory.contains('Internship') ? "Type" : "Duration"),
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
    final categoryKey = _selectedCategory.toLowerCase().replaceAll(' ', '_');
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              const Text("Managing:", style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: _selectedCategory,
                dropdownColor: AppColors.surface,
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection(categoryKey).orderBy('timestamp', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text("No items found", style: TextStyle(color: Colors.white38)));

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.docs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  
                  return Card(
                    color: AppColors.surface,
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: ListTile(
                      title: Text(data['title'] ?? 'No Title', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(data['company'] ?? data['university'] ?? '', style: const TextStyle(color: Colors.white70)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => _confirmDelete(categoryKey, doc.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _confirmDelete(String collection, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text("Delete Item?", style: TextStyle(color: Colors.white)),
        content: const Text("This action cannot be undone.", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection(collection).doc(id).delete();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Deleted successfully")));
            }, 
            child: const Text("Delete", style: TextStyle(color: Colors.redAccent))
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
