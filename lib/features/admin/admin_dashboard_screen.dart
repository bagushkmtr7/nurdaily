import 'package:flutter/material.dart';
import '../../core/admin_service.dart';
import '../../core/api_service.dart';
import '../../core/constants.dart';
import '../../data/user_model.dart';
import 'widgets/stat_card.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _adminService = AdminService();
  final _api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Admin Console', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async => await _api.signOut(),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. OVERVIEW STATS ---
            const Text('Dashboard Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            FutureBuilder<Map<String, dynamic>>(
              future: _adminService.getDashboardStats(),
              builder: (context, snapshot) {
                final stats = snapshot.data ?? {'total_users': 0, 'dau': 0, 'total_announcements': 0};
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      StatCard(title: 'Total Users', value: '${stats['total_users']}', icon: Icons.people_alt, color: Colors.blue),
                      const SizedBox(width: 15),
                      StatCard(title: 'Active Today', value: '${stats['dau']}', icon: Icons.bolt, color: Colors.orange),
                      const SizedBox(width: 15),
                      StatCard(title: 'Announcements', value: '${stats['total_announcements']}', icon: Icons.campaign, color: Colors.teal),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 35),

            // --- 2. USER MANAGEMENT ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('User Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('See All')),
              ],
            ),
            const SizedBox(height: 10),
            StreamBuilder<List<UserModel>>(
              stream: _adminService.streamUsers(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final users = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: user.isBanned ? Colors.red[50] : Colors.teal[50],
                          child: Icon(Icons.person, color: user.isBanned ? Colors.red : Colors.teal),
                        ),
                        title: Text(user.email, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('Role: ${user.role.name.toUpperCase()}'),
                        trailing: PopupMenuButton(
                          onSelected: (value) {
                            if (value == 'ban') _adminService.toggleUserBan(user.uid, user.isBanned);
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'ban',
                              child: Text(user.isBanned ? 'Unban User' : 'Ban User', style: TextStyle(color: user.isBanned ? Colors.green : Colors.red)),
                            ),
                            const PopupMenuItem(value: 'role', child: Text('Change Role')),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
