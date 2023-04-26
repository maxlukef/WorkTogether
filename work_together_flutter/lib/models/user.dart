class User {
  final int id;
  final String name;
  final String email;
  final String bio;
  final String employmentStatus;
  final String studentStatus;
  final List<String> interests;
  final String major;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.employmentStatus,
    required this.studentStatus,
    required this.interests,
    required this.major,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] as int,
      name: json["name"] as String,
      email: json["email"] as String,
      bio: json["bio"] as String,
      employmentStatus: json["employmentStatus"] as String,
      studentStatus: json["studentStatus"],
      interests: json["interests"].split(','),
      major: json["major"] as String,
    );
  }

  String toJson() {
    return '{"id": ${id.toString()},'
        '"name": "$name",'
        '"email": "$email",'
        '"bio": "$bio",'
        '"major": "$major",'
        '"employmentStatus": "$employmentStatus",'
        '"studentStatus": "$studentStatus",'
        '"interests": "${interests.join(",")}"}';
  }
}
