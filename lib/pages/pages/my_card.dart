import 'package:flutter/material.dart';
import 'package:liabrary/helpers/firebase_helper.dart';
import 'package:liabrary/models/card_model.dart';
import 'package:liabrary/pages/pages/drawer.dart';
import 'package:liabrary/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:liabrary/models/user_model.dart';

class MyCard extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const MyCard({Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.darkGreenColor,
        elevation: 0.0,
        title: const Text(
          "My Card",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: FutureBuilder(
          future: FirebaseHelper.getCardModelById(widget.userModel.uid!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              CardModel cardModel = snapshot.data as CardModel;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        border: Border.all(
                          color: MyColors.darkGreenColor,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 130,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: CircleAvatar(
                                    radius: 50,
                                    foregroundImage:
                                        NetworkImage(cardModel.profilePic!),
                                    child: CircularProgressIndicator(
                                      color: MyColors.darkGreenColor,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.60,
                                      child: Text(
                                        cardModel.fullName ?? '',
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: MyColors.darkGreyColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      cardModel.patronId ?? '',
                                      style: TextStyle(
                                          color: MyColors.darkGreyColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: SizedBox(
                              height: 65,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Date of Issue: ",
                                        style: TextStyle(
                                          color: MyColors.darkGreenColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        " " + cardModel.issueDate!,
                                        style: TextStyle(
                                          color: MyColors.darkGreyColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Date of Expiry: ",
                                        style: TextStyle(
                                          color: MyColors.darkGreenColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        cardModel.expiryDate!,
                                        style: TextStyle(
                                          color: MyColors.darkGreyColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: MyColors.darkGreenColor,
                ),
              );
            }
          }),
      drawer: MyDrawer(
        firebaseUser: widget.firebaseUser,
        userModel: widget.userModel,
      ),
    );
  }
}
