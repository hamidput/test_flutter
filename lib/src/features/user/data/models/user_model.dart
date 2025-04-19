class UserModel {
  final String login;
  final int id;
  final String avatarUrl;
  final String htmlUrl;

  UserModel(
      {required this.login,
      required this.id,
      required this.avatarUrl,
      required this.htmlUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      login: json['login'],
      id: json['id'],
      avatarUrl: json['avatar_url'],
      htmlUrl: json['html_url'],
    );
  }
}
