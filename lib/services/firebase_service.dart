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
  Future<UserCredential> signUp(String email, String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  // Sign In
  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Sign Out
  Future<void> signOut() {
    return _auth.signOut();
  }

  // Get Guides
  Stream<List<GuideItem>> getGuides(String category) {
    return _db
        .collection('guides')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GuideItem(
                  id: doc.id,
                  title: doc['title'],
                  description: doc['description'],
                  icon: doc['icon'],
                  category: doc['category'],
                  content: doc['content'],
                ))
            .toList());
  }

  // Get Learning Resources
  Stream<List<LearningResource>> getLearningResources() {
    return _db.collection('learning').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => LearningResource(
              id: doc.id,
              title: doc['title'],
              videoUrl: doc['videoUrl'],
              thumbnailUrl: doc['thumbnailUrl'],
              duration: doc['duration'],
            ))
        .toList());
  }

  // Jobs methods
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
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<JobModel>> getJobs(String collection) {
    return _db.collection(collection).orderBy('createdAt', descending: true).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => JobModel(
                  id: doc.id,
                  title: doc['title'],
                  company: doc['company'],
                  location: doc['location'],
                  salary: doc['salary'],
                  logoUrl: doc['logoUrl'],
                  type: doc['type'],
                  postedDate: doc['postedDate'],
                  description: doc['description'],
                ))
            .toList());
  }

  // Programs methods (Masters / Study Abroad)
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
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<ProgramModel>> getPrograms(String collection) {
    return _db.collection(collection).orderBy('createdAt', descending: true).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => ProgramModel(
                  id: doc.id,
                  title: doc['title'],
                  university: doc['university'],
                  country: doc['country'],
                  imageUrl: doc['imageUrl'],
                  duration: doc['duration'],
                  cost: doc['cost'],
                  requirements: doc['requirements'],
                  description: doc['description'],
                ))
            .toList());
  }
}

