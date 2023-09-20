// Didn't use the fancy JSON Serialization since the interests are expected
// to be in this specific format.

class NewUser {
  final String name;
  final String password;
  final String email;
  final String bio;
  final String employmentStatus;
  final String studentStatus;
  final List<String> interests;
  final String major;

  NewUser({
    required this.name,
    required this.password,
    required this.email,
    required this.bio,
    required this.employmentStatus,
    required this.studentStatus,
    required this.interests,
    required this.major,
  });

  factory NewUser.fromJson(Map<String, dynamic> json) {
    return NewUser(
      password: json["password"] as String,
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
    return '{'
        '"name": "$name",'
        '"password": "$password",'
        '"email": "$email",'
        '"bio": "$bio",'
        '"major": "$major",'
        '"employmentStatus": "$employmentStatus",'
        '"studentStatus": "$studentStatus",'
        '"interests": "${interests.join(",")}"}';
  }
}
