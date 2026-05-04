import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/admin_access.dart';
import '../../core/app_colors.dart';
import '../../models/models.dart';
import '../../services/firebase_service.dart';
import 'chat_reply_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();

  String _selectedCategory = 'Jobs';
  final List<String> _categories = ['Jobs', 'Internships', 'Masters', 'Study Abroad', 'Internship Guidance', 'Learning Videos'];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _companyOrUniController = TextEditingController();
  final TextEditingController _locationOrCountryController = TextEditingController();
  final TextEditingController _salaryOrCostController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _typeOrDurationController = TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  bool get _isVideoCategory => _selectedCategory == 'Learning Videos';

  void _changeCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _clearForm();
    });
  }

  void _submitData() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      String imageUrl = _imageUrlController.text;
      
      // Upload image if selected
      if (_selectedImage != null) {
        imageUrl = await _firebaseService.uploadProfileImage(_selectedImage!); // We can reuse the profile upload or create a specific one
      }

      final categoryKey = _selectedCategory.toLowerCase().replaceAll(' ', '_');
      
      if (_selectedCategory == 'Jobs' || _selectedCategory == 'Internships') {
        final job = JobModel(
          id: '',
          title: _titleController.text,
          company: _companyOrUniController.text,
          location: _locationOrCountryController.text,
          salary: _salaryOrCostController.text,
          logoUrl: imageUrl.isNotEmpty ? imageUrl : 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=150&auto=format&fit=crop&q=60',
          type: _typeOrDurationController.text,
          postedDate: 'Just now',
          description: _descriptionController.text,
        );
        await _firebaseService.addJob(job, categoryKey);
        await _firebaseService.addNotification("New $_selectedCategory!", "${job.title} at ${job.company}.");
      } else if (_selectedCategory == 'Learning Videos') {
        await _firebaseService.addVideo(
          _titleController.text,
          _imageUrlController.text, // YouTube Video ID
          _companyOrUniController.text, // Author
          _typeOrDurationController.text, // Duration
        );
        await _firebaseService.addNotification("New Video!", "New learning resource: ${_titleController.text}");
      } else {
        final program = ProgramModel(
          id: '',
          title: _titleController.text,
          university: _companyOrUniController.text,
          country: _locationOrCountryController.text,
          imageUrl: imageUrl.isNotEmpty ? imageUrl : 'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=400&auto=format&fit=crop&q=60',
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
    setState(() => _selectedImage = null);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isAllowedAdmin = AdminAccess.isAllowedUser(user);

    if (!isAllowedAdmin) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          title: const Text(
            "Admin Panel",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              "You do not have permission to access the admin panel.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          title: const Text("Admin Panel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.add_circle_outline), text: "Add Content"),
              Tab(icon: Icon(Icons.manage_search), text: "Manage All"),
              Tab(icon: Icon(Icons.message_outlined), text: "Inbox"),
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
            _buildInboxTab(),
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
                  onChanged: (v) => _changeCategory(v!),
                ),
              ),
            ),
            const SizedBox(height: 25),
            _buildField(_titleController, "Title"),
            if (_isVideoCategory) ...[
              _buildField(_companyOrUniController, "Author Name"),
              _buildField(_typeOrDurationController, "Duration"),
              _buildField(_imageUrlController, "YouTube Video ID"),
            ] else ...[
              _buildField(_companyOrUniController, _selectedCategory.contains('Job') || _selectedCategory.contains('Internship') ? "Company" : "University"),
              _buildField(_locationOrCountryController, "Location/Country"),
              _buildField(_salaryOrCostController, _selectedCategory.contains('Job') || _selectedCategory.contains('Internship') ? "Salary" : "Cost"),
              _buildField(_typeOrDurationController, _selectedCategory.contains('Job') || _selectedCategory.contains('Internship') ? "Type" : "Duration"),
              _buildField(_imageUrlController, "Image URL (Optional)", isRequired: false),
              const Text("Or Select from Gallery", style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(_selectedImage!, fit: BoxFit.cover),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, color: AppColors.primary, size: 40),
                            SizedBox(height: 10),
                            Text("Select Image", style: TextStyle(color: Colors.white54)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
              if (!_selectedCategory.contains('Job')) _buildField(_requirementsController, "Requirements", maxLines: 2),
              _buildField(_descriptionController, "Description", maxLines: 4),
            ],
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitData,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(_isVideoCategory ? "Publish Video" : "Publish Now", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildManageDataTab() {
    String categoryKey = _selectedCategory.toLowerCase().replaceAll(' ', '_');
    if (_selectedCategory == 'Learning Videos') categoryKey = 'videos';
    
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

  Widget _buildInboxTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('active_chats').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        if (snapshot.data!.docs.isEmpty) return const Center(child: Text("No messages yet", style: TextStyle(color: Colors.white38)));

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final bool isUnread = data['unread'] ?? false;

            return ListTile(
              leading: const CircleAvatar(backgroundColor: AppColors.primary, child: Icon(Icons.person, color: Colors.white)),
              title: Text(data['userName'] ?? 'User', style: TextStyle(color: Colors.white, fontWeight: isUnread ? FontWeight.bold : FontWeight.normal)),
              subtitle: Text(data['lastMessage'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: isUnread ? Colors.white : Colors.white54)),
              trailing: isUnread ? const CircleAvatar(radius: 5, backgroundColor: AppColors.primary) : null,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatReplyScreen(userId: doc.id, userName: data['userName'] ?? 'User'))),
            );
          },
        );
      },
    );
  }

  Widget _buildField(TextEditingController controller, String label, {int maxLines = 1, bool isRequired = true}) {
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
        validator: (v) {
          if (isRequired && (v == null || v.isEmpty)) return "Required";
          return null;
        },
      ),
    );
  }
}
