import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/models/models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with the same config as the app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final db = FirebaseFirestore.instance;

  // Sample Internship Data
  final sampleInternship = JobModel(
    id: '',
    title: 'Software Engineering Internship (Summer 2026)',
    company: 'TechWave Solutions',
    location: 'Colombo, Sri Lanka (Remote possible)',
    salary: 'Unpaid / Stipend LKR 20,000',
    logoUrl: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=150&auto=format&fit=crop&q=60',
    type: 'Internship (Part-time)',
    postedDate: 'Today',
    description: '3-month internship focused on mobile app development with Flutter. Gain hands-on experience, mentorship, and a certificate upon completion.',
  );

  try {
    // Add to internship_guidance collection
    await db.collection('internship_guidance').add({
      'title': sampleInternship.title,
      'company': sampleInternship.company,
      'location': sampleInternship.location,
      'salary': sampleInternship.salary,
      'logoUrl': sampleInternship.logoUrl,
      'type': sampleInternship.type,
      'postedDate': sampleInternship.postedDate,
      'description': sampleInternship.description,
      'timestamp': FieldValue.serverTimestamp(),
    });

    print('✓ Sample internship published successfully!');
  } catch (e) {
    print('✗ Error publishing: $e');
  }
}
