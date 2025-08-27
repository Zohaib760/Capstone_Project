class User {
  final int id;
  final String email;
  final String username;
  final String createdAt;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      username: map['username'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'created_at': createdAt,
    };
  }
}