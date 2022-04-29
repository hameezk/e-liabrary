import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liabrary/models/book_model.dart';
import 'package:liabrary/models/user_model.dart';
import 'package:liabrary/pages/pages/book_issue.dart';
import 'package:liabrary/pages/pages/book_update.dart';
import 'package:liabrary/pages/pages/drawer.dart';
import 'package:liabrary/utils/colors.dart';

class SearchBookPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchBookPage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _SearchBookPageState createState() => _SearchBookPageState();
}

class _SearchBookPageState extends State<SearchBookPage> {
  TextEditingController searchController = TextEditingController();
  List<String> roles = ["Search by Name", "Search by Author"];
  String? role = "Search by Name";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.darkGreenColor,
        elevation: 0.0,
        title: const Text(
          "Search Book",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        actions: [
          SizedBox(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: false,
                icon: const Icon(
                  Icons.align_horizontal_left,
                  color: Colors.white,
                ),
                // value: role,
                items: roles.map(buildMenuItem).toList(),
                onChanged: (value) => setState(
                  () {
                    role = value;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: SafeArea(
        child: (role == "Search by Name")
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          label: Text(
                            "Book Name",
                            style: TextStyle(
                              color: Colors.blueGrey,
                            ),
                          ),
                          hintText: "Enter Book Name...",
                        ),
                        onChanged: (value) => setState(() {}),
                      ),
                      // trailing: IconButton(
                      //   icon: const Icon(Icons.search),
                      //   onPressed: () {
                      //     setState(() {});
                      //   },
                      // ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  (searchController.text.trim() != "")
                      ? Expanded(
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("inventory")
                                .where("bookName")
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

                                          BookModel searchedBook =
                                              BookModel.fromMap(userMap);
                                          String bookName = searchedBook
                                              .bookName!
                                              .trim()
                                              .toUpperCase();
                                          String searchKey = searchController
                                              .text
                                              .trim()
                                              .toUpperCase();

                                          if (bookName.contains(searchKey)) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ListTile(
                                                onTap: () async {
                                                  (widget.userModel.role ==
                                                          "librarian")
                                                      ? Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return BookUpdate(
                                                                userModel: widget
                                                                    .userModel,
                                                                firebaseUser: widget
                                                                    .firebaseUser,
                                                                bookModel:
                                                                    searchedBook,
                                                              );
                                                            },
                                                          ),
                                                        )
                                                      : Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return BookIssue(
                                                                userModel: widget
                                                                    .userModel,
                                                                firebaseUser: widget
                                                                    .firebaseUser,
                                                                book:
                                                                    searchedBook,
                                                              );
                                                            },
                                                          ),
                                                        );
                                                },
                                                // leading: CircleAvatar(
                                                //   child:
                                                //       const CircularProgressIndicator(
                                                //     color: Colors.blueGrey,
                                                //   ),
                                                //   backgroundColor: Colors.transparent,
                                                //   foregroundImage: NetworkImage(
                                                //       searchedBook.profilePic!),
                                                // ),
                                                title: Text(
                                                  searchedBook.bookName!,
                                                  style: const TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  searchedBook.bookAuthor!,
                                                  style: const TextStyle(
                                                    color: Colors.blueGrey,
                                                  ),
                                                ),
                                                trailing: Text(
                                                  searchedBook.bookQty!,
                                                  style: const TextStyle(
                                                    color: Colors.blueGrey,
                                                  ),
                                                ),
                                              ),
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
                        )
                      : const Text(
                          "No results found!",
                          style: TextStyle(
                            color: Colors.blueGrey,
                          ),
                        ),
                ],
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          label: Text(
                            "Book Author",
                            style: TextStyle(
                              color: Colors.blueGrey,
                            ),
                          ),
                          hintText: "Enter Book Author...",
                        ),
                        onChanged: (value) => setState(() {}),
                      ),
                      // trailing: IconButton(
                      //   icon: const Icon(Icons.search),
                      //   onPressed: () {
                      //     setState(() {});
                      //   },
                      // ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  (searchController.text.trim() != "")
                      ? Expanded(
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("inventory")
                                .where("bookAuthor")
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

                                          BookModel searchedBook =
                                              BookModel.fromMap(userMap);
                                          String bookAuthor = searchedBook
                                              .bookAuthor!
                                              .trim()
                                              .toUpperCase();
                                          String searchKey = searchController
                                              .text
                                              .trim()
                                              .toUpperCase();

                                          if (bookAuthor.contains(searchKey)) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ListTile(
                                                onTap: () async {},
                                                // leading: CircleAvatar(
                                                //   child:
                                                //       const CircularProgressIndicator(
                                                //     color: Colors.blueGrey,
                                                //   ),
                                                //   backgroundColor: Colors.transparent,
                                                //   foregroundImage: NetworkImage(
                                                //       searchedBook.profilePic!),
                                                // ),
                                                title: Text(
                                                  searchedBook.bookName!,
                                                  style: const TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  searchedBook.bookAuthor!,
                                                  style: const TextStyle(
                                                    color: Colors.blueGrey,
                                                  ),
                                                ),
                                                trailing: Text(
                                                  searchedBook.bookQty!,
                                                  style: const TextStyle(
                                                    color: Colors.blueGrey,
                                                  ),
                                                ),
                                              ),
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
                        )
                      : const Text(
                          "No results found!",
                          style: TextStyle(
                            color: Colors.blueGrey,
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

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
}
