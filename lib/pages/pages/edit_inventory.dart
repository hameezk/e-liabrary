import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liabrary/models/book_model.dart';
import 'package:liabrary/models/user_model.dart';
import 'package:liabrary/pages/pages/drawer.dart';
import 'package:liabrary/pages/pages/book_update.dart';
import 'package:liabrary/utils/colors.dart';

class EditINventory extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const EditINventory(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _EditINventoryState createState() => _EditINventoryState();
}

class _EditINventoryState extends State<EditINventory> {
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
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
            height: 5,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
                color: MyColors.darkGreenColor,
                borderRadius: const BorderRadius.all(Radius.circular(40),),),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: TextField(
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Enter Book name...",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),
          ),
          (nameController.text.trim() != "")
              ? Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("inventory")
                        .where("bookName",
                            isGreaterThanOrEqualTo: nameController.text.trim())
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
                                  Map<String, dynamic> bookMap =
                                      dataSnapshot.docs[index].data()
                                          as Map<String, dynamic>;

                                  BookModel searchedBook =
                                      BookModel.fromMap(bookMap);
                                  if (searchedBook.bookName!
                                      .contains(nameController.text.trim())) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: MyColors.darkGreenColor,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: ListTile(
                                          leading: Text(
                                            searchedBook.bookQty!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          title: Text(
                                            searchedBook.bookName!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return BookUpdate(
                                                      userModel:
                                                          widget.userModel,
                                                      firebaseUser:
                                                          widget.firebaseUser,
                                                      bookModel: searchedBook,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                });
                          } else {
                            return const Center(
                              child: Text(
                                "No results found!",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                ),
                              ),
                            );
                          }
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                              "An error occoured!",
                              style: TextStyle(
                                color: Colors.blueGrey,
                              ),
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text(
                              "No results found!",
                              style: TextStyle(
                                color: Colors.blueGrey,
                              ),
                            ),
                          );
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                )
              : const Center(
                  child: Text(
                    "No results found!",
                    style: TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
        ],
      ),
      drawer: MyDrawer(
        firebaseUser: widget.firebaseUser,
        userModel: widget.userModel,
      ),
    );
  }
}
