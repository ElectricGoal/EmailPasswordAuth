/// Review: properties of a model should all final.
/// Every change you make will create a copy of current variable
/// That's better for debugging since we don't have problem with reference
class UserModel {
  final String? uid;
  final String? firstName;
  final String? lastName;
  final String? email;

  const UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
