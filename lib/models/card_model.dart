class CardModel {
  String? uid;
  String? fullName;
  String? patronId;
  String? email;
  String? profilePic;
  String? issueDate;
  String? expiryDate;

  CardModel({
    this.uid,
    this.fullName,
    this.email,
    this.profilePic,
    this.patronId,
    this.issueDate,
    this.expiryDate,
  });

  CardModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullName = map["fullName"];
    email = map["email"];
    profilePic = map["profilePic"];
    patronId = map["patronId"];
    issueDate = map["issueDate"];
    expiryDate = map["expiryDate"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullName": fullName,
      "email": email,
      "profilePic": profilePic,
      "patronId": patronId,
      "issueDate": issueDate,
      "expiryDate": expiryDate,
    };
  }
}
