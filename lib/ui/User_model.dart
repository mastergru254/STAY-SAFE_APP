// ignore_for_file: file_names

class UserModel {
  String? uid;
  String? email;
  String? name;

  UserModel({this.uid, this.email, this.name});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }
}
