import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
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
      if (kIsWeb) {
        return await _auth.signInWithPopup(GoogleAuthProvider());
      }

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

  // Update Display Name
  Future<void> updateDisplayName(String name) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
    }
  }

  // Upload Profile Image
  Future<String> uploadProfileImage(File file) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final ref = FirebaseStorage.instance.ref().child('profile_images').child('${user.uid}.jpg');
    await ref.putFile(file);
    final url = await ref.getDownloadURL();
    
    await user.updatePhotoURL(url);
    return url;
  }

  Future<String> uploadFile(File file, {String folder = 'content_uploads'}) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance.ref().child(folder).child(fileName);

      final uploadTask = await ref.putFile(file);
      final url = await uploadTask.ref.getDownloadURL();
      return url;
    } catch (e) {
      print("Upload Error: $e");
      throw Exception("Storage Error. Please enable Firebase Storage in Firebase Console.");
    }
  }

  // --- Search Functionality ---

  // Search Jobs
  Future<List<JobModel>> searchJobs(String query, String collection) async {
    final snapshot = await _db.collection(collection).get();
    return snapshot.docs
        .map((doc) => JobModel(
              id: doc.id,
              title: doc.get('title') ?? '',
              company: doc.get('company') ?? '',
              location: doc.get('location') ?? '',
              salary: doc.get('salary') ?? '',
              logoUrl: doc.get('logoUrl') ?? '',
              type: doc.get('type') ?? '',
              postedDate: 'Recently',
              description: doc.get('description') ?? '',
            ))
        .where((job) => job.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Search Programs
  Future<List<ProgramModel>> searchPrograms(String query, String collection) async {
    final snapshot = await _db.collection(collection).get();
    return snapshot.docs
        .map((doc) => ProgramModel(
              id: doc.id,
              title: doc.get('title') ?? '',
              university: doc.get('university') ?? '',
              country: doc.get('country') ?? '',
              imageUrl: doc.get('imageUrl') ?? '',
              duration: doc.get('duration') ?? '',
              cost: doc.get('cost') ?? '',
              requirements: doc.get('requirements') ?? '',
              description: doc.get('description') ?? '',
            ))
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // --- Bookmarking System ---

  // Toggle Bookmark
  Future<void> toggleBookmark(String itemId, Map<String, dynamic> itemData) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _db.collection('users').doc(user.uid).collection('bookmarks').doc(itemId);
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({
        ...itemData,
        'savedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Check if bookmarked
  Stream<bool> isBookmarked(String itemId) {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(false);

    return _db.collection('users').doc(user.uid).collection('bookmarks').doc(itemId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  // Get Saved Items
  Stream<QuerySnapshot> getSavedItems() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _db.collection('users').doc(user.uid).collection('bookmarks')
        .orderBy('savedAt', descending: true)
        .snapshots();
  }

  // --- Chat System ---

  // Send Message
  Future<void> sendMessage(String message) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('chats').doc(user.uid).collection('messages').add({
      'text': message,
      'senderId': user.uid,
      'senderName': user.displayName ?? 'Student',
      'timestamp': FieldValue.serverTimestamp(),
      'isAdmin': false,
    });

    // Notify admin in a global 'active_chats' collection
    await _db.collection('active_chats').doc(user.uid).set({
      'lastMessage': message,
      'timestamp': FieldValue.serverTimestamp(),
      'userName': user.displayName ?? 'Student',
      'userEmail': user.email,
      'unread': true,
    });
  }

  // Get Messages
  Stream<QuerySnapshot> getMessages(String userId) {
    return _db.collection('chats').doc(userId).collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Admin Send Reply
  Future<void> sendAdminReply(String userId, String message) async {
    await _db.collection('chats').doc(userId).collection('messages').add({
      'text': message,
      'senderId': 'admin',
      'senderName': 'Admin',
      'timestamp': FieldValue.serverTimestamp(),
      'isAdmin': true,
    });

    await _db.collection('active_chats').doc(userId).update({
      'lastMessage': message,
      'timestamp': FieldValue.serverTimestamp(),
      'unread': false,
    });
  }

  // --- Video Learning ---
  Future<void> addVideo(String title, String youtubeId, String author, String duration, {String? thumbnailUrl}) async {
    await _db.collection('videos').add({
      'title': title,
      'id': youtubeId,
      'author': author,
      'duration': duration,
      'thumbnailUrl': thumbnailUrl ?? 'https://img.youtube.com/vi/$youtubeId/0.jpg',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // --- Job Applications ---
  Future<void> applyForJob(String jobId, Map<String, dynamic> jobData) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('users').doc(user.uid).collection('applications').doc(jobId).set({
      ...jobData,
      'appliedAt': FieldValue.serverTimestamp(),
      'status': 'Pending',
    });
  }

  Stream<QuerySnapshot> getAppliedJobs() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _db.collection('users').doc(user.uid).collection('applications')
        .orderBy('appliedAt', descending: true)
        .snapshots();
  }
}
