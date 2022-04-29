import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liabrary/models/book_model.dart';
import 'package:liabrary/models/user_model.dart';
import 'package:liabrary/pages/pages/drawer.dart';
import 'package:liabrary/utils/colors.dart';

class BookUpdate extends StatefulWidget {
  final BookModel bookModel;
  final UserModel userModel;
  final User firebaseUser;
  const BookUpdate(
      {Key? key,
      required this.bookModel,
      required this.userModel,
      required this.firebaseUser})
      : super(key: key);

  @override
  _BookUpdateState createState() => _BookUpdateState();
}

class _BookUpdateState extends State<BookUpdate> {
  BookModel? updatedBook;
  TextEditingController nameController = TextEditingController();
  TextEditingController authorController = TextEditingController();

  void updateBook() async {
    String quantity = nameController.text.trim();
    String author = authorController.text.trim();
    if (quantity != "" || author != "") {
      updatedBook!.bookQty = quantity;
      await FirebaseFirestore.instance
          .collection("inventory")
          .doc(updatedBook!.bookId)
          .set(
            updatedBook!.toMap(),
          )
          .then(
        (value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: MyColors.darkGreenColor,
              duration: const Duration(seconds: 1),
              content: const Text("Book Updated Sucessfully!"),
            ),
          );
        },
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    updatedBook = widget.bookModel;
    nameController.text = updatedBook!.bookQty.toString();
    authorController.text = updatedBook!.bookAuthor.toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: MyColors.darkGreenColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Library",
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Edit Inventory",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Column(
              children: [
                Text(
                  widget.bookModel.bookName!,
                  style: TextStyle(
                    color: MyColors.darkGreenColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Quantity: ",
                      style: TextStyle(
                        color: MyColors.darkGreenColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: MyColors.darkGreyColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        controller: nameController,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Author: ",
                      style: TextStyle(
                        color: MyColors.darkGreenColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        maxLines: 3,
                        minLines: 1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.name,
                        style: TextStyle(
                          color: MyColors.darkGreyColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        controller: authorController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 80,
                ),
                CupertinoButton(
                  color: MyColors.darkGreenColor,
                  onPressed: () {
                    updateBook();
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      drawer: MyDrawer(
          firebaseUser: widget.firebaseUser,
          userModel: widget.userModel,
        ),
    );
  }
}
