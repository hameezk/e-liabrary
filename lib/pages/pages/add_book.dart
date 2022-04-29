import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liabrary/models/book_model.dart';
import 'package:liabrary/models/user_model.dart';
import 'package:liabrary/pages/pages/inventory.dart';
import 'package:liabrary/utils/colors.dart';

import '../../main.dart';

class AddBook extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const AddBook({Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddBook> {
  TextEditingController nameController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController authorController = TextEditingController();

  void checkValues(String name, String qty, String author) {
    if (name == "" || qty == "" || author == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: MyColors.darkGreenColor,
          duration: const Duration(seconds: 1),
          content: const Text("Please fill all the fields!"),
        ),
      );
    } else {
      add(name, qty, author);
    }
  }

  void add(String name, String qty, String author) {
    BookModel newBook = BookModel(
      bookId: uuid.v1(),
      bookName: name,
      bookQty: qty,
      bookAuthor: author,
    );

    FirebaseFirestore.instance
        .collection("inventory")
        .doc(newBook.bookId)
        .set(
          newBook.toMap(),
        )
        .then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: MyColors.darkGreenColor,
            duration: const Duration(seconds: 1),
            content: const Text("Book Added Sucessfully!"),
          ),
        );
      },
    );
    navigate();
  }

  void navigate() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return InventoryPage(
              userModel: widget.userModel, firebaseUser: widget.firebaseUser);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.darkGreenColor,
        centerTitle: true,
        title: const Text(
          "Add Book",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: "Book name:", hintText: "Enter Book name"),
            ),
            TextField(
              controller: qtyController,
              decoration: const InputDecoration(
                  labelText: "Book Quantity:", hintText: "Enter Book quantity"),
            ),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(
                  labelText: "Book Author:", hintText: "Enter Book Author"),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(MyColors.darkGreenColor),
              ),
              child: const Text("Add Book"),
              onPressed: () {
                checkValues(
                    nameController.text.trim(), qtyController.text.trim(),authorController.text.trim(),);
              },
            ),
          ],
        ),
      ),
    );
  }
}
