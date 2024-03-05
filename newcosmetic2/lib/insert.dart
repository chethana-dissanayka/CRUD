import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newcosmetic2/main.dart';

class ccreate extends StatefulWidget {
  @override
  State<ccreate> createState() => ccreateState();
}

class ccreateState extends State<ccreate> {
  TextEditingController pid = TextEditingController();
  TextEditingController producttype = TextEditingController();
  TextEditingController usertype = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController brand = TextEditingController();

  File? file;
  ImagePicker image = ImagePicker();
  var url;

  CollectionReference bproducts =
      FirebaseFirestore.instance.collection('bproducts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 179, 48),
      appBar: AppBar(
        title: Text(
          'Add New Product ',
          style: TextStyle(
            fontSize: 25,
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
              controller: pid,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Product Id',
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
              height: 10,
            ),
            TextFormField(
              controller: producttype,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Common product name',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: usertype,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'For whome',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: category,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Product Category',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: price,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'New Price',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: description,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Description',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: brand,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Brand',
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
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  uploadFile() async {
    try {
      var imagefile = FirebaseStorage.instance
          .ref()
          .child("Bproduct_photo")
          .child("/${name.text}.jpg");
      UploadTask task = imagefile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      setState(() {
        url = url;
      });
      if (url != null) {
        await bproducts.add({
          'pid': pid.text,
          'producttype': producttype.text,
          'usertype': usertype.text,
          'name': name.text,
          'price': price.text,
          'brand': brand.text,
          'category': category.text,
          'description': description.text,
          'url': url,
        });

        // Show success message
        showSuccessSnackBar();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MyApp(),
          ),
        );
      }
    } on Exception catch (e) {
      print(e);

      // Show failure message
      showFailureSnackBar("Failed to add product");
    }
  }

  void showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product inserted successfully'),
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
