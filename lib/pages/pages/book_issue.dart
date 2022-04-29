import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liabrary/models/book_model.dart';
import 'package:liabrary/models/user_model.dart';
import 'package:liabrary/pages/issued_books.dart';
import 'package:liabrary/pages/pages/drawer.dart';
import 'package:liabrary/utils/colors.dart';

class BookIssue extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final BookModel book;
  const BookIssue(
      {Key? key,
      required this.userModel,
      required this.firebaseUser,
      required this.book})
      : super(key: key);

  @override
  State<BookIssue> createState() => _BookIssueState();
}

class _BookIssueState extends State<BookIssue> {
  TextEditingController idController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime? finalDate;
  int quantity = 0;

  @override
  void initState() {
    finalDate = DateTime.now();
    idController.text = widget.userModel.patronId ?? "";
    emailController.text = widget.userModel.email ?? "";
    nameController.text = widget.userModel.fullName ?? "";
    dateController.text = DateFormat('EEE, M/d/y').format(finalDate!);
    super.initState();
  }

  void datePicker() async {
    var date = await getDate();
    setState(() {
      if (date != null) {
        finalDate = date;
        dateController.text = DateFormat('EEE, M/d/y').format(finalDate!);
      }
    });
  }

  Future<DateTime?> getDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.darkGreenColor,
        elevation: 0.0,
        title: const Text(
          "Issue Book",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${widget.book.bookName}",
                      style: TextStyle(
                          fontSize: 40,
                          color: MyColors.darkGreenColor,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "Author: ${widget.book.bookAuthor}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: MyColors.darkGreenColor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Available Quantity: ${widget.book.bookQty}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: MyColors.darkGreenColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    const Text(
                      "Confirm Details: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: idController,
                      textAlignVertical: TextAlignVertical.center,
                      onSaved: (val) {},
                      onChanged: (value) {},
                      enableInteractiveSelection: true,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      minLines: 1,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 18),
                        labelText: 'ID',
                        fillColor: Colors.grey.shade200,
                        focusColor: MyColors.darkGreenColor,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Colors.black38, width: 0.3),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Colors.black38, width: 0.3),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: nameController,
                      textAlignVertical: TextAlignVertical.center,
                      onSaved: (val) {},
                      onChanged: (value) {},
                      enableInteractiveSelection: true,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      minLines: 1,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 18),
                        labelText: 'Name',
                        fillColor: Colors.grey.shade200,
                        focusColor: MyColors.darkGreenColor,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Colors.black38, width: 0.3),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Colors.black38, width: 0.3),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: emailController,
                      textAlignVertical: TextAlignVertical.center,
                      onSaved: (val) {},
                      onChanged: (value) {},
                      enableInteractiveSelection: true,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      minLines: 1,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 18),
                        labelText: 'Email',
                        fillColor: Colors.grey.shade200,
                        focusColor: MyColors.darkGreenColor,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Colors.black38, width: 0.3),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Colors.black38, width: 0.3),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: TextFormField(
                            readOnly: true,
                            controller: dateController,
                            textAlignVertical: TextAlignVertical.center,
                            onSaved: (val) {},
                            onChanged: (value) {},
                            enableInteractiveSelection: true,
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            maxLines: 4,
                            minLines: 1,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 18),
                              labelText: 'Date',
                              fillColor: Colors.grey.shade200,
                              focusColor: MyColors.darkGreenColor,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                    color: Colors.black38, width: 0.3),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                    color: Colors.black38, width: 0.3),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            datePicker();
                          },
                          icon: Icon(
                            Icons.calendar_today,
                            color: MyColors.darkGreenColor,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                CupertinoButton(
                  color: MyColors.darkGreenColor,
                  onPressed: () {
                    checkValues();
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: MyDrawer(
          firebaseUser: widget.firebaseUser,
          userModel: widget.userModel,
        ),
    );
  }

  void checkValues() {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String id = idController.text.trim();
    String date = dateController.text.trim();

    if (email.isEmpty || name.isEmpty || id.isEmpty || date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: MyColors.darkGreenColor,
          duration: const Duration(seconds: 1),
          content: const Text("Please fill all the fields!"),
        ),
      );
    } else {
      issueBook(
        email,
        name,
        id,
        date,
      );
    }
  }

  void issueBook(String email, String name, String id, String date) async {
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userModel.uid)
        .get();
    UserModel userModel =
        UserModel.fromMap(userData.data() as Map<String, dynamic>);

    List<dynamic> borrowedBooks = [];
    if (userModel.borrowedBooks != null) {
      borrowedBooks = userModel.borrowedBooks!;
    }

    Map<String, String> book = {
      'bookId': '${widget.book.bookId}',
      'bookName': '${widget.book.bookName}',
      'bookAuthor': '${widget.book.bookAuthor}',
      'date': finalDate.toString(),
    };
    borrowedBooks.add(book);
    userModel.borrowedBooks = borrowedBooks;
    quantity = int.parse(widget.book.bookQty ?? '');

    BookModel updatedBook = BookModel(
      bookId: widget.book.bookId,
      bookName: widget.book.bookName,
      bookAuthor: widget.book.bookAuthor,
      bookQty: "${--quantity}",
    );

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(userModel.toMap())
        .then(
      (value) async {
        await FirebaseFirestore.instance
            .collection("inventory")
            .doc(widget.book.bookId)
            .set(updatedBook.toMap())
            .then(
          (value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return IssuedBooks(
                      userModel: widget.userModel,
                      firebaseUser: widget.firebaseUser);
                },
              ),
            );
          },
        );
      },
    );
  }
}
