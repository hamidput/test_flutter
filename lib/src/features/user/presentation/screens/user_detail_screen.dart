import 'package:flutter/material.dart';
import 'package:test_flutter/src/features/user/data/models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetailScreen extends StatelessWidget {
  final UserModel user;

  const UserDetailScreen({super.key, required this.user});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.login),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: user.id,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.avatarUrl),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    user.login,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoCard(
                    icon: Icons.link,
                    title: 'GitHub Profile',
                    subtitle: user.htmlUrl,
                    onTap: () => _launchUrl(user.htmlUrl),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.people,
                    title: 'Type',
                    subtitle: user.avatarUrl,
                  ),
                  if (user.login != null) ...[
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      icon: Icons.person,
                      title: 'Name',
                      subtitle: user.login,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Colors.blue),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 18,
                        color: onTap != null ? Colors.blue : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null) const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
