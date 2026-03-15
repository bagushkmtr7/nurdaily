import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/user_model.dart';

class AdminService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- STATS DASHBOARD ---
  Future<Map<String, dynamic>> getDashboardStats() async {
    final users = await _db.collection('users').get();
    final announcements = await _db.collection('announcements').get();
    
    final today = DateTime.now();
    final dauCount = users.docs.where((doc) {
      final lastLogin = (doc.data()['last_login'] as Timestamp?)?.toDate();
      return lastLogin != null && 
             lastLogin.day == today.day && 
             lastLogin.month == today.month && 
             lastLogin.year == today.year;
    }).length;

    return {
      'total_users': users.docs.length,
      'dau': dauCount,
      'total_announcements': announcements.docs.length,
    };
  }

  // --- USER MANAGEMENT ---
  Stream<List<UserModel>> streamUsers() {
    return _db.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList());
  }

  Future<void> toggleUserBan(String uid, bool currentStatus) async {
    await _db.collection('users').doc(uid).update({'isBanned': !currentStatus});
  }

  // --- NOTIFICATION BROADCAST ---
  Future<void> sendBroadcastNotification(String title, String body) async {
    await _db.collection('notifications').add({
      'title': title,
      'body': body,
      'sent_at': FieldValue.serverTimestamp(),
      'status': 'sent',
    });
  }
}
