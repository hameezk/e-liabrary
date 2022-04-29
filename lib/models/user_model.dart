class UserModel {
  String? uid;
  String? fullName;
  String? patronId;
  String? email;
  String? profilePic;
  String? role;
  List<dynamic>? borrowedBooks;

  UserModel({
    this.uid,
    this.fullName,
    this.email,
    this.profilePic,
    this.role,
    this.patronId,
  });

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullName = map["fullName"];
    email = map["email"];
    profilePic = map["profilePic"];
    borrowedBooks = map["borrowedBooks"]  ;
    role = map["role"];
    patronId = map["patronId"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullName": fullName,
      "email": email,
      "profilePic": profilePic,
      "borrowedBooks": borrowedBooks,
      "role": role,
      "patronId": patronId,
    };
  }
}
