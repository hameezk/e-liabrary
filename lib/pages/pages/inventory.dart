import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liabrary/models/book_model.dart';
import 'package:liabrary/models/user_model.dart';
import 'package:liabrary/pages/pages/add_book.dart';
import 'package:liabrary/pages/pages/book_issue.dart';
import 'package:liabrary/pages/pages/drawer.dart';
import 'package:liabrary/pages/pages/edit_inventory.dart';
import 'package:liabrary/pages/pages/book_update.dart';
import 'package:liabrary/pages/pages/search_book.dart';
import 'package:liabrary/utils/colors.dart';

class InventoryPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const InventoryPage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  Size? size;

  Future<BookModel?> getBookModel(BookModel bookModel) async {
    BookModel? bookModel;

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("inventory").get();

    if (snapshot.docs.isNotEmpty) {
      var docData = snapshot.docs[0].data();
      BookModel existingBook =
          BookModel.fromMap(docData as Map<String, dynamic>);
      bookModel = existingBook;
    } else {
      const Text("Add some books!");
    }
    return bookModel;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.darkGreenColor,
          elevation: 0,
        ),
        extendBodyBehindAppBar: false,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: MyColors.darkGreenColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
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
                    "Inventory",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("inventory")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;
                      if (dataSnapshot.docs.isNotEmpty) {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: dataSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> userMap =
                                dataSnapshot.docs[index].data()
                                    as Map<String, dynamic>;
                            BookModel bookModel = BookModel.fromMap(userMap);
                            if (bookModel.bookName!.isNotEmpty) {
                              return Card(
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 04, horizontal: 10),
                                  child: ListTile(
                                    onTap: () {
                                      (widget.userModel.role == "librarian")
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return BookUpdate(
                                                    userModel: widget.userModel,
                                                    firebaseUser:
                                                        widget.firebaseUser,
                                                    bookModel: bookModel,
                                                  );
                                                },
                                              ),
                                            )
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return BookIssue(
                                                    userModel: widget.userModel,
                                                    firebaseUser:
                                                        widget.firebaseUser,
                                                    book: bookModel,
                                                  );
                                                },
                                              ),
                                            );
                                    },
                                    leading: Text(
                                      "${index + 1}.",
                                      style: TextStyle(
                                        color: MyColors.darkGreenColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    title: Text(
                                      bookModel.bookName!,
                                      style: TextStyle(
                                        color: MyColors.darkGreenColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Text(
                                      bookModel.bookAuthor!,
                                      style: TextStyle(
                                        color: MyColors.darkGreenColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: Text(
                                      "${bookModel.bookQty!}   ",
                                      style: TextStyle(
                                        color: MyColors.darkGreenColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
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
            )
          ],
        ),
        bottomNavigationBar: (widget.userModel.role == "librarian")
            ? SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: size!.width * 0.4,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              MyColors.darkGreenColor),
                        ),
                        child: const Text("Add Book"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return AddBook(
                                    userModel: widget.userModel,
                                    firebaseUser: widget.firebaseUser);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: size!.width * 0.4,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              MyColors.darkGreenColor),
                        ),
                        child: const Text("Edit Inventory"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return EditINventory(
                                    userModel: widget.userModel,
                                    firebaseUser: widget.firebaseUser);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              )
            : const SizedBox(
                height: 0,
              ),
        drawer: MyDrawer(
          firebaseUser: widget.firebaseUser,
          userModel: widget.userModel,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: MyColors.darkGreenColor,
          foregroundColor: Colors.white,
          child: const Center(child: Icon(Icons.search)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SearchBookPage(
                      userModel: widget.userModel,
                      firebaseUser: widget.firebaseUser);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
