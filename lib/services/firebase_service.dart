import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/models.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Auth stream
  Stream<User?> get user => _auth.authStateChanges();

  // Google Sign In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  // Sign Up
  Future<UserCredential> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  // Sign In
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Add Job
  Future<void> addJob(JobModel job, String collection) async {
    await _db.collection(collection).add({
      'title': job.title,
      'company': job.company,
      'location': job.location,
      'salary': job.salary,
      'logoUrl': job.logoUrl,
      'type': job.type,
      'postedDate': job.postedDate,
      'description': job.description,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get Jobs
  Stream<List<JobModel>> getJobs(String collection) {
    return _db.collection(collection).orderBy('timestamp', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return JobModel(
          id: doc.id,
          title: doc.get('title') ?? '',
          company: doc.get('company') ?? '',
          location: doc.get('location') ?? '',
          salary: doc.get('salary') ?? '',
          logoUrl: doc.get('logoUrl') ?? '',
          type: doc.get('type') ?? '',
          postedDate: doc.get('postedDate') ?? '',
          description: doc.get('description') ?? '',
        );
      }).toList();
    });
  }

  // Add Program (Masters/PhD/Study Abroad)
  Future<void> addProgram(ProgramModel program, String collection) async {
    await _db.collection(collection).add({
      'title': program.title,
      'university': program.university,
      'country': program.country,
      'imageUrl': program.imageUrl,
      'duration': program.duration,
      'cost': program.cost,
      'requirements': program.requirements,
      'description': program.description,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get Programs
  Stream<List<ProgramModel>> getPrograms(String collection) {
    return _db.collection(collection).orderBy('timestamp', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProgramModel(
          id: doc.id,
          title: doc.get('title') ?? '',
          university: doc.get('university') ?? '',
          country: doc.get('country') ?? '',
          imageUrl: doc.get('imageUrl') ?? '',
          duration: doc.get('duration') ?? '',
          cost: doc.get('cost') ?? '',
          requirements: doc.get('requirements') ?? '',
          description: doc.get('description') ?? '',
        );
      }).toList();
    });
  }

  // --- Notification System ---

  // Add Notification
  Future<void> addNotification(String title, String body) async {
    await _db.collection('notifications').add({
      'title': title,
      'body': body,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });
  }

  // Get Notifications Stream
  Stream<QuerySnapshot> getNotificationsStream() {
    return _db.collection('notifications').orderBy('timestamp', descending: true).snapshots();
  }

  // Get Unread Count Stream
  Stream<int> getUnreadNotificationCount() {
    return _db.collection('notifications')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Mark all as read
  Future<void> markNotificationsAsRead() async {
    final snapshot = await _db.collection('notifications').where('isRead', isEqualTo: false).get();
    final batch = _db.batch();
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  // --- CRUD Operations for Admin ---

  // Update Job
  Future<void> updateJob(String collection, String id, JobModel job) async {
    await _db.collection(collection).doc(id).update({
      'title': job.title,
      'company': job.company,
      'location': job.location,
      'salary': job.salary,
      'logoUrl': job.logoUrl,
      'type': job.type,
      'description': job.description,
    });
  }

  // Delete Job
  Future<void> deleteJob(String collection, String id) async {
    await _db.collection(collection).doc(id).delete();
  }

  // Update Program
  Future<void> updateProgram(String collection, String id, ProgramModel program) async {
    await _db.collection(collection).doc(id).update({
      'title': program.title,
      'university': program.university,
      'country': program.country,
      'imageUrl': program.imageUrl,
      'duration': program.duration,
      'cost': program.cost,
      'requirements': program.requirements,
      'description': program.description,
    });
  }

  // Delete Program
  Future<void> deleteProgram(String collection, String id) async {
    await _db.collection(collection).doc(id).delete();
  }
}
