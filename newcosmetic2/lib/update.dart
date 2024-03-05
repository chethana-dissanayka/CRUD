import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateRecord extends StatefulWidget {
  String Bproduct_Key;

  UpdateRecord({required this.Bproduct_Key});

  @override
  State<UpdateRecord> createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UpdateRecord> {
  TextEditingController productId = TextEditingController();
  TextEditingController productType = TextEditingController();
  TextEditingController userType = TextEditingController();
  TextEditingController productName = TextEditingController();
  TextEditingController productCategory = TextEditingController();
  TextEditingController productNewprice = TextEditingController();
  TextEditingController productDescription = TextEditingController();
  TextEditingController productBrand = TextEditingController();
  var url;
  File? file;
  ImagePicker image = ImagePicker();
  CollectionReference bproducts =
      FirebaseFirestore.instance.collection('bproducts');

  @override
  void initState() {
    super.initState();
    BproductData();
  }

  void BproductData() async {
    DocumentSnapshot snapshot = await bproducts.doc(widget.Bproduct_Key).get();

    Map<String, dynamic> Bproduct = snapshot.data() as Map<String, dynamic>;

    setState(() {
      productId.text = Bproduct['pid'];
      productName.text = Bproduct['name'];
      productType.text = Bproduct['producttype'];
      userType.text = Bproduct['usertype'];
      productCategory.text = Bproduct['category'];
      productNewprice.text = Bproduct['price'];
      productDescription.text = Bproduct['description'];
      productBrand.text = Bproduct['brand'];
      url = Bproduct['url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 179, 48),
      appBar: AppBar(
        title: Text('Update Record'),
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
                    ? MaterialButton(
                        height: 100,
                        child: url == null
                            ? Text('Choose Image')
                            : CircleAvatar(
                                foregroundColor: Colors.black,
                                maxRadius: 100,
                                backgroundImage: NetworkImage(url),
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
              controller: productName,
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
              controller: productCategory,
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
              controller: productId,
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
              controller: productType,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Common Product Name',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: userType,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'For Whom',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: productNewprice,
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
              controller: productDescription,
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
              controller: productBrand,
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
                } else {
                  directUpdate();
                }
              },
              child: Text(
                "Update",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20,
                ),
              ),
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        file = File(img.path);
      });
    }
  }

  uploadFile() async {
    try {
      var imagefile = FirebaseStorage.instance
          .ref()
          .child("Bproduct_photo")
          .child("/${productName.text}.jpg");
      UploadTask task = imagefile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      setState(() {
        url = url;
      });
      if (url != null) {
        Map<String, dynamic> Bproduct = {
          'pid': productId.text,
          'producttype': productType.text,
          'usertype': userType.text,
          'name': productName.text,
          'price': productNewprice.text,
          'brand': productBrand.text,
          'category': productCategory.text,
          'description': productDescription.text,
          'url': url,
        };

        await bproducts.doc(widget.Bproduct_Key).update(Bproduct).whenComplete(() {
          showSuccessSnackBar();
        });
      }
    } on Exception catch (e) {
      print(e);

      // Show failure message
      showFailureSnackBar("Failed to update product details");
    }
  }

  directUpdate() async {
    if (url != null) {
      Map<String, dynamic> Bproduct = {
        'pid': productId.text,
        'producttype': productType.text,
        'usertype': userType.text,
        'name': productName.text,
        'price': productNewprice.text,
        'brand': productBrand.text,
        'category': productCategory.text,
        'description': productDescription.text,
        'url': url,
      };

      await bproducts.doc(widget.Bproduct_Key).update(Bproduct).whenComplete(() {
        showSuccessSnackBar();
      });
    }
  }

  void showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product details updated successfully'),
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
