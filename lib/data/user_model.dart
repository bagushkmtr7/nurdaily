import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { user, admin, moderator, takmir }

class UserModel {
  final String uid;
  final String email;
  final UserRole role;
  final bool isBanned;
  final DateTime? lastLogin;
  final String? deviceModel;

  UserModel({
    required this.uid,
    required this.email,
    this.role = UserRole.user,
    this.isBanned = false,
    this.lastLogin,
    this.deviceModel,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      role: UserRole.values.firstWhere((e) => e.toString() == 'UserRole.${data['role']}', orElse: () => UserRole.user),
      isBanned: data['isBanned'] ?? false,
      lastLogin: (data['last_login'] as Timestamp?)?.toDate(),
      deviceModel: data['device_model'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role.name,
      'isBanned': isBanned,
      'last_login': lastLogin,
      'device_model': deviceModel,
    };
  }
}
