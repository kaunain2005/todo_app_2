class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  final String? bio;
  final String? photoUrl;
  final String? theme; // 'light' | 'dark' | null

  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    this.bio,
    this.photoUrl,
    this.theme,
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      bio: data['bio'],
      photoUrl: data['photoUrl'],
      theme: data['theme'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'bio': bio,
      'photoUrl': photoUrl,
      'theme': theme,
    }..removeWhere((key, value) => value == null);
  }
}
