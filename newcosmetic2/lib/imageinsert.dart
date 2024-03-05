import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newcosmetic2/homeimage.dart';

class iccreate extends StatefulWidget {
  @override
  State<iccreate> createState() => iccreateState();
}

class iccreateState extends State<iccreate> {
  TextEditingController name = TextEditingController();

  File? file;
  ImagePicker iimage = ImagePicker();
  var image;

  CollectionReference carousel =
      FirebaseFirestore.instance.collection('carousel-slider');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 179, 48),
      appBar: AppBar(
        title: Text(
          'Add New Image ',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 141, 142),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 200,
                width: 200,
                child: file == null
                    ? IconButton(
                        icon: Icon(
                          Icons.add_a_photo,
                          size: 90,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        onPressed: () {
                          getImage();
                        },
                      )
                    : MaterialButton(
                        height: 100,
                        child: Image.file(
                          file!,
                          fit: BoxFit.fill,
                        ),
                        onPressed: () {
                          getImage();
                        },
                      ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: name,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Product Name',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              height: 40,
              onPressed: () {
                if (file != null) {
                  uploadFile();
                }
              },
              child: Text(
                "Add",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20,
                ),
              ),
              color: Color.fromARGB(255, 13, 13, 13),
            ),
          ],
        ),
      ),
    );
  }

  getImage() async {
    var img = await iimage.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  uploadFile() async {
    try {
      var imagefile =
          FirebaseStorage.instance.ref().child("Iproduct_photo").child(".jpg");
      UploadTask task = imagefile.putFile(file!);
      TaskSnapshot snapshot = await task;
      image = await snapshot.ref.getDownloadURL();
      setState(() {
        image = image;
      });
      if (image != null) {
        await carousel.add({
          'name': name.text,
          'image': image,
        });

        // Show success message
        showSuccessSnackBar("Product added successfully");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeImageScreen(),
          ),
        );
      }
    } on Exception catch (e) {
      print(e);

      // Show failure message
      showFailureSnackBar("Failed to add product");
    }
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showFailureSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }
}
