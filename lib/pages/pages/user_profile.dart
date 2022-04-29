import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liabrary/pages/pages/inventory.dart';
import 'package:liabrary/utils/colors.dart';
import 'package:liabrary/models/user_model.dart';
import 'package:liabrary/pages/pages/edit_profile.dart';

class UserProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const UserProfile({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  double avg(List<dynamic>? list) {
    double res = 0;
    double sum = 0;
    if (list == null) {
      return 0;
    } else {
      for (var i = 0; i < list.length; i++) {
        sum = sum + list[i];
      }
      res = sum / (list.length - 1);
      return res;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
            alignment: Alignment.bottomLeft,
            height: 190,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: MyColors.darkGreenColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            elevation: 1,
                            backgroundColor: Colors.white,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 120,
                                  child: CircularProgressIndicator(
                                    color: MyColors.darkGreyColor,
                                  ),
                                  backgroundColor: Colors.transparent,
                                  foregroundImage: NetworkImage(
                                      widget.userModel.profilePic.toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                      child: const Text(
                                        "Change profile",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return EditProfile(
                                                  userModel: widget.userModel,
                                                  firebaseUser:
                                                      widget.firebaseUser);
                                            },
                                          ),
                                        );
                                      }),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 35,
                      child: const CircularProgressIndicator(
                        color: Colors.blueGrey,
                      ),
                      backgroundColor: Colors.transparent,
                      foregroundImage:
                          NetworkImage(widget.userModel.profilePic.toString()),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return InventoryPage(
                                    userModel: widget.userModel,
                                    firebaseUser: widget.firebaseUser);
                              },
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return EditProfile(
                                    userModel: widget.userModel,
                                    firebaseUser: widget.firebaseUser);
                              },
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.userModel.fullName.toString(),
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: MyColors.darkGreenColor,
                            ),
                          ),
                        ],
                      ),
                      Row(children: [
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          widget.userModel.email.toString(),
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18,
                            color: MyColors.darkGreyColor,
                          ),
                        ),
                      ]),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: MyColors.darkGreenColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Designation: ${widget.userModel.role}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        (widget.userModel.role == "Staff Person")
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  height: 30,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.amberAccent),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [],
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
