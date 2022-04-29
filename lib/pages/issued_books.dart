import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liabrary/helpers/email_helper.dart';
import 'package:liabrary/helpers/firebase_helper.dart';
import 'package:liabrary/models/book_model.dart';
import 'package:liabrary/models/user_model.dart';
import 'package:liabrary/pages/pages/drawer.dart';
import 'package:liabrary/utils/colors.dart';

class IssuedBooks extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const IssuedBooks(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<IssuedBooks> createState() => _IssuedBooksState();
}

class _IssuedBooksState extends State<IssuedBooks> {
  DateTime newdate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.darkGreenColor,
        elevation: 0.0,
        title: const Text(
          "",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: (widget.userModel.role == 'patron')
          ? SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 150,
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
                        children: const [
                          Text(
                            "E-Liabrary",
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Issued Books",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future:
                        FirebaseHelper.getUserModelById(widget.userModel.uid!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          UserModel userModel = snapshot.data as UserModel;
                          List borrowedBooks = userModel.borrowedBooks ?? [];
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: borrowedBooks.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> book = borrowedBooks[index];
                              DateTime currentDate = DateTime.now();
                              DateTime dueDate = DateTime.parse(book['date']);
                              bool _isOverDue =
                                  (currentDate.difference(dueDate) >
                                          const Duration(days: 1))
                                      ? true
                                      : false;

                              return Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${book['bookName']}',
                                            style: TextStyle(
                                              color: MyColors.darkGreenColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            'Due until: ' +
                                                DateFormat('EEE, M/d/y')
                                                    .format(dueDate),
                                            style: TextStyle(
                                              color: MyColors.darkGreyColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      (_isOverDue)
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Container(
                                                height: 40,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.red[800],
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "Overdue",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Container(
                                                height: 40,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.yellow[800],
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Text(
                                                      "Due",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            // separatorBuilder:
                            //     (BuildContext context, int index) {
                            //   return Padding(
                            //     padding:
                            //         const EdgeInsets.symmetric(horizontal: 8.0),
                            //     child: Divider(
                            //       color: MyColors.darkGreyColor,
                            //       height: 0.5,
                            //       thickness: 1,
                            //     ),
                            //   );
                            // },
                          );
                        } else {
                          return const Center(child: Text("No Data found"));
                        }
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            color: MyColors.darkGreenColor,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            )
          : SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 150,
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
                        children: const [
                          Text(
                            "E-Liabrary",
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Issued Books",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .where("role", isGreaterThanOrEqualTo: 'patron')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.hasData) {
                            QuerySnapshot dataSnapshot =
                                snapshot.data as QuerySnapshot;

                            if (dataSnapshot.docs.isNotEmpty) {
                              return ListView.builder(
                                  itemCount: dataSnapshot.docs.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> userMap =
                                        dataSnapshot.docs[index].data()
                                            as Map<String, dynamic>;

                                    UserModel searchedUser =
                                        UserModel.fromMap(userMap);
                                    List borrowedBooks =
                                        searchedUser.borrowedBooks ?? [];
                                    if (searchedUser.borrowedBooks != null) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: borrowedBooks.length,
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic> book =
                                              borrowedBooks[index];
                                          DateTime currentDate = DateTime.now();
                                          DateTime dueDate =
                                              DateTime.parse(book['date']);
                                          bool _isOverDue =
                                              (currentDate.difference(dueDate) >
                                                      const Duration(days: 1))
                                                  ? true
                                                  : false;

                                          return GestureDetector(
                                            onTap: (() => _showDetailsDialouge(
                                                  searchedUser,
                                                  book['bookId'],
                                                  book['date'],
                                                  _isOverDue,
                                                )),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 80,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${book['bookName']}',
                                                          style: TextStyle(
                                                            color: MyColors
                                                                .darkGreenColor,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          '(${searchedUser.fullName})',
                                                          style: TextStyle(
                                                            color: MyColors
                                                                .darkGreenColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          'Due until: ' +
                                                              DateFormat(
                                                                      'EEE, M/d/y')
                                                                  .format(
                                                                      dueDate),
                                                          style: TextStyle(
                                                            color: MyColors
                                                                .darkGreyColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    (_isOverDue)
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child: Container(
                                                              height: 40,
                                                              width: 80,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: Colors
                                                                    .red[800],
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: const [
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                      "Overdue",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child: Container(
                                                              height: 40,
                                                              width: 80,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: Colors
                                                                        .yellow[
                                                                    800],
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: const [
                                                                  Text(
                                                                    "Due",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        // separatorBuilder:
                                        //     (BuildContext context, int index) {
                                        //   return Padding(
                                        //     padding:
                                        //         const EdgeInsets.symmetric(horizontal: 8.0),
                                        //     child: Divider(
                                        //       color: MyColors.darkGreyColor,
                                        //       height: 0.5,
                                        //       thickness: 1,
                                        //     ),
                                        //   );
                                        // },
                                      );
                                    } else {
                                      return Container();
                                    }
                                  });
                            } else {
                              return const Text(
                                "No results found!",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                ),
                              );
                            }
                          } else if (snapshot.hasError) {
                            return const Text(
                              "An error occoured!",
                              style: TextStyle(
                                color: Colors.blueGrey,
                              ),
                            );
                          } else {
                            return const Text(
                              "No results found!",
                              style: TextStyle(
                                color: Colors.blueGrey,
                              ),
                            );
                          }
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
      drawer: MyDrawer(
        firebaseUser: widget.firebaseUser,
        userModel: widget.userModel,
      ),
    );
  }

  _showDetailsDialouge(
      UserModel user, String bookId, String dateString, bool isOverDue) async {
    DateTime date = DateTime.parse(dateString);
    BookModel? book = await FirebaseHelper.getBookModelById(bookId);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Issued Book Details",
            style: TextStyle(
              color: MyColors.darkGreenColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Book Name: ${book!.bookName}',
                style: TextStyle(
                  color: MyColors.darkGreyColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Issued By: ${user.fullName}',
                style: TextStyle(
                  color: MyColors.darkGreyColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Due until: ' + DateFormat('EEE, M/d/y').format(date),
                style: TextStyle(
                  color: (isOverDue) ? Colors.red[800] : Colors.yellow[800],
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: () async {
                await EmailHelper.sendEmail(
                        book.bookName!, user.email!, context)
                    .then(
                  (value) => Navigator.pop(context),
                );
              },
              child: Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                  color: MyColors.darkGreenColor,
                ),
                child: const Center(
                  child: Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                collectBook(
                  book,
                  user,
                );
              },
              child: Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                  color: MyColors.darkGreenColor,
                ),
                child: const Center(
                  child: Text(
                    'Collect',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                _showRenewDialouge(
                  user,
                  book,
                  date,
                  isOverDue,
                );
              },
              child: Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                  color: MyColors.darkGreenColor,
                ),
                child: const Center(
                  child: Text(
                    'Renew',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _showRenewDialouge(
      UserModel userModel, BookModel bookModel, DateTime date, bool isOverDue) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setstate) {
            return AlertDialog(
              title: Text(
                "Renew Book",
                style: TextStyle(
                  color: MyColors.darkGreenColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Book Name: ${bookModel.bookName}',
                    style: TextStyle(
                      color: MyColors.darkGreyColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Issued By: ${userModel.fullName}',
                    style: TextStyle(
                      color: MyColors.darkGreyColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Current Due until: ' +
                        DateFormat('EEE, M/d/y').format(date),
                    style: TextStyle(
                      color: (isOverDue) ? Colors.red[800] : Colors.yellow[800],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'New Due until: ' +
                            DateFormat('EEE, M/d/y').format(newdate),
                        style: TextStyle(
                          color: Colors.yellow[800],
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await datePicker();
                          setstate(() {});
                        },
                        child: Icon(
                          Icons.calendar_today,
                          color: MyColors.darkGreenColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                InkWell(
                  onTap: () {
                    reneewBook(bookModel, userModel, newdate.toString());
                  },
                  child: Container(
                    height: 40,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30),
                      ),
                      color: MyColors.darkGreenColor,
                    ),
                    child: const Center(
                      child: Text(
                        'Renew',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
        });
  }

  Future<void> datePicker() async {
    var date = await getDate();
    setState(() {
      if (date != null) {
        newdate = date;
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

  void reneewBook(BookModel issuedBook, UserModel isssuer, String date) async {
    List<dynamic> borrowedBooks = [];
    if (isssuer.borrowedBooks != null) {
      borrowedBooks = isssuer.borrowedBooks!;
    }

    Map<String, String> book = {
      'bookId': '${issuedBook.bookId}',
      'bookName': '${issuedBook.bookName}',
      'bookAuthor': '${issuedBook.bookAuthor}',
      'date': date.toString(),
    };
    for (var i = 0; i < borrowedBooks.length; i++) {
      Map<String, dynamic> oldBook = borrowedBooks[i];
      if (oldBook.containsValue(issuedBook.bookId)) {
        borrowedBooks.removeAt(i);
      }
    }
    borrowedBooks.add(book);
    isssuer.borrowedBooks = borrowedBooks;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(isssuer.uid)
        .set(isssuer.toMap())
        .then(
      (value) async {
        Navigator.pop(context);
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
  }

  void collectBook(BookModel issuedBook, UserModel isssuer) async {
    List<dynamic> borrowedBooks = [];
    if (isssuer.borrowedBooks != null) {
      borrowedBooks = isssuer.borrowedBooks!;
    }

    for (var i = 0; i < borrowedBooks.length; i++) {
      Map<String, dynamic> oldBook = borrowedBooks[i];
      if (oldBook.containsValue(issuedBook.bookId)) {
        borrowedBooks.removeAt(i);
      }
    }
    int quantity = int.parse(issuedBook.bookQty ?? '0');
    issuedBook.bookQty = "${++quantity}";

    await FirebaseFirestore.instance
        .collection("users")
        .doc(isssuer.uid)
        .set(isssuer.toMap())
        .then(
      (value) async {
        await FirebaseFirestore.instance
            .collection("inventory")
            .doc(issuedBook.bookId)
            .set(issuedBook.toMap())
            .then(
          (value) async {
            Navigator.pop(context);
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
