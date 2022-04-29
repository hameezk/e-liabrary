import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liabrary/models/book_model.dart';
import 'package:liabrary/models/user_model.dart';

class FirebaseHelper {
  static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? userModel;
    DocumentSnapshot docsnap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (docsnap.data() != null) {
      userModel = UserModel.fromMap(docsnap.data() as Map<String, dynamic>);
    }
    return userModel;
  }
  static Future<BookModel?> getBookModelById(String uid) async {
    BookModel? bookModel;
    DocumentSnapshot docsnap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (docsnap.data() != null) {
      bookModel = BookModel.fromMap(docsnap.data() as Map<String, dynamic>);
    }
    return bookModel;
  }
}
