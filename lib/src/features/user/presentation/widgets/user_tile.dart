import 'package:flutter/material.dart';
import 'package:test_flutter/src/features/user/data/models/user_model.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;

  const UserTile({required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl)),
      title: Text(user.login),
      subtitle: Text(user.htmlUrl),
      onTap: onTap,
    );
  }
}
