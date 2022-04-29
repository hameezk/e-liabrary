import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liabrary/helpers/firebase_helper.dart';
import 'package:liabrary/models/book_model.dart';
import 'package:liabrary/models/user_model.dart';
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
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("role", isGreaterThanOrEqualTo: 'patron')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
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

                                    return FutureBuilder(
                                        future: getbookmodel(book['bookId']),
                                        builder: (context, snapshot) {
                                          BookModel bookModel =
                                              snapshot.data as BookModel;

                                          return GestureDetector(
                                            onTap: (() => _showRenewDialouge(
                                                searchedUser,
                                                bookModel,
                                                book['date'])),
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
                                        });
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
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
    );
  }

  _showRenewDialouge(UserModel user, BookModel book, DateTime date) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Issued Book Details",
            style: TextStyle(
              color: MyColors.darkGreenColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            children: [
              Text(
                '${book.bookName}',
                style: TextStyle(
                  color: MyColors.darkGreenColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '${user.fullName}',
                style: TextStyle(
                  color: MyColors.darkGreenColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Due until: ' + DateFormat('EEE, M/d/y').format(date),
                style: TextStyle(
                  color: MyColors.darkGreyColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<BookModel> getbookmodel(book) async {
    BookModel? bookModel;
    bookModel = await FirebaseHelper.getBookModelById(book);
    return bookModel!;
  }
}
