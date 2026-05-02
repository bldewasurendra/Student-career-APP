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

  // Form Fields
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
          logoUrl: _imageUrlController.text.isNotEmpty 
              ? _imageUrlController.text 
              : 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=150&auto=format&fit=crop&q=60',
          type: _typeOrDurationController.text,
          postedDate: 'Just now',
          description: _descriptionController.text,
        );
        await _firebaseService.addJob(job, _selectedCategory.toLowerCase());
      } else {
        final program = ProgramModel(
          id: '',
          title: _titleController.text,
          university: _companyOrUniController.text,
          country: _locationOrCountryController.text,
          imageUrl: _imageUrlController.text.isNotEmpty 
              ? _imageUrlController.text 
              : 'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=400&auto=format&fit=crop&q=60',
          duration: _typeOrDurationController.text,
          cost: _salaryOrCostController.text,
          requirements: _requirementsController.text,
          description: _descriptionController.text,
        );
        await _firebaseService.addProgram(program, _selectedCategory.toLowerCase().replaceAll(' ', '_'));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$_selectedCategory Added Successfully!')),
      );
      _clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Admin Dashboard", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Select Category", style: TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    dropdownColor: AppColors.surface,
                    style: const TextStyle(color: AppColors.textPrimary),
                    items: _categories.map((String category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 25),
              _buildTextField(_titleController, "Title (e.g. Software Engineer)"),
              _buildTextField(_companyOrUniController, _selectedCategory.contains('Job') || _selectedCategory.contains('Intern') ? "Company Name" : "University Name"),
              _buildTextField(_locationOrCountryController, _selectedCategory.contains('Job') || _selectedCategory.contains('Intern') ? "Location" : "Country"),
              _buildTextField(_salaryOrCostController, _selectedCategory.contains('Job') || _selectedCategory.contains('Intern') ? "Salary" : "Course Cost"),
              _buildTextField(_typeOrDurationController, _selectedCategory.contains('Job') || _selectedCategory.contains('Intern') ? "Job Type (Full-time/Remote)" : "Duration (e.g. 2 Years)"),
              _buildTextField(_imageUrlController, "Image/Logo URL (Optional)"),
              if (!_selectedCategory.contains('Job') && !_selectedCategory.contains('Intern'))
                _buildTextField(_requirementsController, "Entry Requirements", maxLines: 3),
              _buildTextField(_descriptionController, "Full Description", maxLines: 5),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Add to App", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter $label";
          }
          return null;
        },
      ),
    );
  }
}
