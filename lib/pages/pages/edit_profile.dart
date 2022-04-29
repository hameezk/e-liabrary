import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liabrary/models/user_model.dart';
import 'package:liabrary/pages/pages/inventory.dart';
import 'package:liabrary/utils/colors.dart';

class EditProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const EditProfile(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var temp = 0;
  List<String> roles = ["patron", "librarian"];
  File? imageFile;
  String? role;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController roleController = TextEditingController();

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

  void checkValues() {
    String fullName = fullNameController.text.trim();

    if (fullName.isEmpty || imageFile == override || role == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: MyColors.darkGreenColor,
          duration: const Duration(seconds: 1),
          content: const Text("Please fill all the fields!"),
        ),
      );
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    if (temp == 1) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("profilepictures")
          .child(widget.userModel.uid.toString())
          .putFile(imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      widget.userModel.profilePic = imageUrl;
    }

    String fullname = fullNameController.text.trim();
    widget.userModel.fullName = fullname;

    widget.userModel.role = role;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: MyColors.darkGreenColor,
            duration: const Duration(seconds: 1),
            content: const Text("Profile Updated"),
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
  }

  @override
  Widget build(BuildContext context) {
    (role == "") ? role = widget.userModel.role : null;
    fullNameController.text = widget.userModel.fullName.toString();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.darkGreenColor,
        centerTitle: true,
        title: const Text(
          "Edit Profile",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            CupertinoButton(
              onPressed: () {
                temp = 1;
                showImageOptions();
              },
              child: CircleAvatar(
                backgroundColor: MyColors.darkGreenColor,
                foregroundColor: Colors.white,
                radius: 60,
                backgroundImage:
                    (imageFile != null) ? FileImage(imageFile!) : null,
                foregroundImage: (imageFile == null)
                    ? NetworkImage(widget.userModel.profilePic!)
                    : null,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
              child: Flexible(
                child: Column(
                  children: [
                    TextField(
                      controller: fullNameController,
                      decoration: const InputDecoration(
                          labelText: "Full name:", hintText: "Enter full name"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    (widget.userModel.role != "patron")
                        ? Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: false,
                                  hint: const Text("Select Role"),
                                  value: role,
                                  items: roles.map(buildMenuItem).toList(),
                                  onChanged: (value) => setState(
                                    () {
                                      role = value;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: 0,
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
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
                ),
              ),
            ),
          ],
        ),
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
