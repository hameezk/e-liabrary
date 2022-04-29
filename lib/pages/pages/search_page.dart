import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liabrary/models/user_model.dart';
import 'package:liabrary/pages/pages/viewer_profile.dart';
import 'package:liabrary/utils/colors.dart';


class SearchUserPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchUserPage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.darkGreenColor,
        centerTitle: true,
        elevation: 0.0,
        title: const Text(
          "Search",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListTile(
                title: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    label: Text(
                      "Email Address",
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                    hintText: "Enter Email...",
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
                          .collection("users")
                          .where("email",
                              isGreaterThanOrEqualTo:
                                  searchController.text.trim())
                          .where("email", isNotEqualTo: widget.userModel.email)
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
                                    if (searchedUser.email!.contains(
                                        searchController.text.trim())) {
                                      return ListTile(
                                        onTap: () async {
                                        },
                                        leading: CircleAvatar(
                                          child:
                                              const CircularProgressIndicator(
                                            color: Colors.blueGrey,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          foregroundImage: NetworkImage(
                                              searchedUser.profilePic!),
                                        ),
                                        title: Text(
                                          searchedUser.fullName!,
                                          style: const TextStyle(
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          searchedUser.email!,
                                          style: const TextStyle(
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                        trailing: IconButton(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return ViewProfile(
                                                    userModel: widget.userModel,
                                                    firebaseUser:
                                                        widget.firebaseUser,
                                                    targetUserModel:
                                                        searchedUser,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.person,
                                            size: 40.0,
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
    );
  }
}
