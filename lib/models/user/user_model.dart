// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? sender;
  // final String? recipient;
  final String? fcmToken;
  final String signinPlatform;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      // this.recipient,
      this.sender,
      this.fcmToken,
      this.signinPlatform = 'google'});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['user_name'],
      email: map['email'],
      sender: map['sender'],
      // recipient: map['recipient'],
      fcmToken: map['fcm_token'],
      signinPlatform: map['signin_platform'],
    );
  }
}

class DesignationModel {
  int userId;
  int recipientId;
  DesignationModel({
    required this.userId,
    required this.recipientId,
  });
}

class UserUpdateModel {
  final int userId;
  final String? name;
  final int? sender;
  final String? email;



  UserUpdateModel({required this.userId, this.name,  this.sender, this.email}); 

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id' : userId};
    if (name != null) map['name'] = name;
    if (sender != null) map['sender'] = sender;
    if (email != null) map['email'] = email;
    return map;
  }
}
