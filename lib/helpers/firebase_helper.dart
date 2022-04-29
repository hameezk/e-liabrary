import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liabrary/models/book_model.dart';
import 'package:liabrary/models/card_model.dart';
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

  static Future<BookModel?> getBookModelById(String bookId) async {
    BookModel? bookModel;
    DocumentSnapshot docsnap = await FirebaseFirestore.instance
        .collection("inventory")
        .doc(bookId)
        .get();

    if (docsnap.data() != null) {
      bookModel = BookModel.fromMap(docsnap.data() as Map<String, dynamic>);
    }
    return bookModel;
  }

  static Future<CardModel?> getCardModelById(String uid) async {
    CardModel? cardModel;
    DocumentSnapshot docsnap = await FirebaseFirestore.instance
        .collection("cards")
        .doc(uid)
        .get();

    if (docsnap.data() != null) {
      cardModel = CardModel.fromMap(docsnap.data() as Map<String, dynamic>);
    }
    return cardModel;
  }
}
