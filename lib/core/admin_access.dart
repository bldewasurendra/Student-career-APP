import 'package:firebase_auth/firebase_auth.dart';

class AdminAccess {
  static const List<String> allowedEmails = [
    'admin@unipath.com',
    'oktech@gmail.com',
    'lenminibhagya@gmail.com',
  ];

  static bool isAllowedEmail(String? email) {
    if (email == null) return false;
    return allowedEmails.contains(email);
  }

  static bool isAllowedUser(User? user) {
    return user != null && isAllowedEmail(user.email);
  }
}