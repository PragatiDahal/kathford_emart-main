import 'dart:io';

import 'package:emart/global_variables.dart';
import 'package:emart/local_storage/SharedPref.dart';
import 'package:emart/model/Users.dart';
import 'package:emart/services/Auth.dart';
import 'package:emart/widgets/Esnackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  File? _image;
  void openMedia() async {
    final permissionStatus = await Permission.camera.request();
    if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }

    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  // controllers
  final TextEditingController _firstNameController =
      TextEditingController(text: firstName);
  final TextEditingController _lastNameController =
      TextEditingController(text: lastName);
  final TextEditingController _usernameController =
      TextEditingController(text: username);
  final TextEditingController _phoneNumberController = TextEditingController();

  // update function
  Future _updateFunction() async {
    String? uploadedImage;

    if (_image != null) {
      uploadedImage = await Auth().uploadProfile(_image!);
    }
    String userID = FirebaseAuth.instance.currentUser!.uid;
    final updatedUserData = Users(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      username: _usernameController.text,
      phoneNumber: _phoneNumberController.text,
      profileImage:
          uploadedImage ?? profileImage ?? "https://via.placeholder.com/150",
    );

    try {
      await Auth()
          .updateUser(userID, updatedUserData)
          .then((value) => {
                SharedPref().updateUserData(updatedUserData),
                SharedPref().getUserData(),
                Navigator.pushNamed(context, '/navbar'),
                Esnackbar.show(context, "Profile updated"),
              })
          .catchError((error) => {
                Esnackbar.show(context, "Firebase profile update error"),
              });
    } catch (e) {
      Esnackbar.show(context, "Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                _image == null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profileImage!),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            _image != null ? FileImage(_image!) : null,
                      ),
                Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                            onPressed: () {
                              openMedia();
                            },
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                              size: 30,
                            ))))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "First Name",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                hintText: "Enter your first name",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Last Name",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                hintText: "Enter your last name",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Username",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                hintText: "Enter your username",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Phone Number",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                hintText: "Enter your phone name",
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  _updateFunction();
                },
                child: const Text("Update"))
          ],
        ),
      ),
    );
  }
}