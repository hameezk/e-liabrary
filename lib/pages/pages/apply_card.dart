import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:liabrary/models/card_model.dart';
import 'package:liabrary/models/user_model.dart';
import 'package:liabrary/pages/pages/drawer.dart';
import 'package:liabrary/pages/pages/inventory.dart';
import 'package:liabrary/utils/colors.dart';

class ApplyForCard extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const ApplyForCard(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<ApplyForCard> createState() => _ApplyForCardState();
}

class _ApplyForCardState extends State<ApplyForCard> {
  String? fullame;
  String? picture;
  String? patronID;
  DateTime? issuedDate;
  DateTime? expiryDate;
  File? imageFile;

  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    fullame = widget.userModel.fullName;
    picture = widget.userModel.profilePic;
    patronID = widget.userModel.patronId;
    issuedDate = DateTime.now();
    expiryDate = DateTime.now().add(const Duration(days: 90));
    idController.text = patronID ?? '';
    nameController.text = fullame ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.darkGreenColor,
        elevation: 0.0,
        title: const Text(
          "Apply For Card",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: (imageFile == null)
                                ? CircleAvatar(
                                    radius: 50,
                                    foregroundImage: NetworkImage(picture!),
                                    child: CircularProgressIndicator(
                                      color: MyColors.darkGreenColor,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 50,
                                    foregroundImage: FileImage(imageFile!),
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
                                width: MediaQuery.of(context).size.width * 0.60,
                                child: Text(
                                  fullame ?? '',
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
                                patronID ?? '',
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
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                                  " " +
                                      DateFormat("dd-mm-yyyy")
                                          .format(issuedDate!),
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
                                  DateFormat("dd-mm-yyyy").format(expiryDate!),
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Text(
                "Confirm Details:",
                style: TextStyle(
                  color: MyColors.darkGreyColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    textAlignVertical: TextAlignVertical.center,
                    onSaved: (val) {},
                    onChanged: (value) {
                      setState(() {
                        fullame = value;
                      });
                    },
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
                        borderSide:
                            const BorderSide(color: Colors.black38, width: 0.3),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                            const BorderSide(color: Colors.black38, width: 0.3),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: idController,
                    textAlignVertical: TextAlignVertical.center,
                    onSaved: (val) {},
                    onChanged: (value) {
                      setState(() {
                        patronID = value;
                      });
                    },
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
                        borderSide:
                            const BorderSide(color: Colors.black38, width: 0.3),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                            const BorderSide(color: Colors.black38, width: 0.3),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextFormField(
                          enabled: false,
                          textAlignVertical: TextAlignVertical.center,
                          onSaved: (val) {},
                          onChanged: (value) {
                            setState(() {
                              patronID = value;
                            });
                          },
                          enableInteractiveSelection: true,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          minLines: 1,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 18),
                            labelText: 'Change Picture',
                            labelStyle:
                                TextStyle(color: MyColors.darkGreyColor),
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.18,
                        child: InkWell(
                          onTap: (() {
                            showImageOptions();
                          }),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CupertinoButton(
                    color: MyColors.darkGreenColor,
                    onPressed: () {
                      showConfirmDialouge();
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
          ],
        ),
      ),
      drawer: MyDrawer(
        firebaseUser: widget.firebaseUser,
        userModel: widget.userModel,
      ),
    );
  }

  void selectImage(ImageSource source) async {
    XFile? selectedImage = await ImagePicker().pickImage(source: source);
    if (selectedImage != null) {
      cropImage(selectedImage);
    }
  }

  void cropImage(XFile file) async {
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 15,
    );
    if (croppedImage != null) {
      setState(() {
        imageFile = croppedImage;
      });
    }
  }

  void showImageOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Upload profile picture",
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                leading: const Icon(Icons.photo_album_rounded),
                title: const Text(
                  "Select from Gallery",
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
                leading: const Icon(CupertinoIcons.photo_camera),
                title: const Text(
                  "Take new photo",
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  showConfirmDialouge() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Confirm Details.",
              style: TextStyle(
                color: MyColors.darkGreenColor,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            content: Text(
              "Are you sureyou want to submit.\nThis cannot be reversed!",
              style: TextStyle(
                color: MyColors.darkGreyColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
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
                      'Cancel',
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
                  applyCard();
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
                      'Confirm',
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
  }

  void applyCard() async {
    try {
      if (imageFile != null) {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref("profilepictures")
            .child(widget.userModel.uid.toString())
            .putFile(imageFile!);

        TaskSnapshot snapshot = await uploadTask;
        picture = await snapshot.ref.getDownloadURL();
      }

      CardModel cardModel = CardModel(
        uid: widget.userModel.uid,
        fullName: fullame,
        patronId: patronID,
        profilePic: picture,
        email: widget.userModel.email,
        issueDate: DateFormat("dd-mm-yyyy").format(issuedDate!),
        expiryDate: DateFormat("dd-mm-yyyy").format(expiryDate!),
      );

      await FirebaseFirestore.instance
          .collection("cards")
          .doc(widget.userModel.uid)
          .set(cardModel.toMap())
          .then(
        (value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: MyColors.darkGreenColor,
              duration: const Duration(seconds: 1),
              content: const Text("Card Issued"),
            ),
          );
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
      );
    } catch (e) {
      return null;
    }
  }
}
