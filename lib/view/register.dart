import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:prerequisite_hackathon_app/view/login.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  late String imagePath;

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      imagePath = image.path;
    });
  }

  void register() async {
    String imageName = path.basename(imagePath);
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('/$imageName');

    File file = File(imagePath);
    await ref.putFile(file);
    String downloadURL = await ref.getDownloadURL();
    final String username = usernameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String address = addressController.text;
    final String phone = phoneController.text;
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      final UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await db.collection("users").doc(user.user.uid).set({
        "email": email,
        "username": username,
        "address": address,
        "phone": phone,
        "url": downloadURL
      });
      print("User is registered");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        margin: EdgeInsets.only(left: 10, top: 50, right: 10, bottom: 50),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        // child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Registration",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Upload Image'),
              ),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your name',
                ),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your email',
                ),
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your password',
                ),
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your address',
                ),
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your phone',
                ),
              ),
              ElevatedButton(
                onPressed: register,
                child: Text('Register'),
              ),
              GestureDetector(
                  child: Text("Login",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue)),
                  onTap: () {
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (context) => Login()));
                  })
            ],
          ),
        ),
        // ),
      ),
    );
  }
}
