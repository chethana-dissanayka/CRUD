import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newcosmetic2/update.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var inputText = " Search product code";

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/t.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              'Search  ',
            ),
            backgroundColor: Color.fromARGB(255, 255, 141, 142),
            foregroundColor: Colors.white,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (val) {
                      setState(() {
                        inputText = val;
                        print(inputText);
                      });
                    },
                  ),
                  Expanded(
                    child: Container(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("bproducts")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("Something went wrong"),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Text("Loading"),
                            );
                          }

                          List<DocumentSnapshot> filteredProducts = snapshot
                              .data!.docs
                              .where((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            return data['pid'].contains(inputText)||  data['name'].contains(inputText);
                          }).toList();

                          if (inputText.isNotEmpty &&
                              filteredProducts.isEmpty) {
                            return Center(
                              child: Text("Product not found"),
                            );
                          }

                          return ListView(
                            children: (inputText.isEmpty ||
                                    filteredProducts.isEmpty)
                                ? snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data =
                                        document.data() as Map<String, dynamic>;
                                    return Card(
                                      elevation: 5,
                                      child: ListTile(
                                        title: Text(data['name']),
                                        leading: Image.network(data['url']),
                                        subtitle: Text(data['pid']),
                                      ),
                                    );
                                  }).toList()
                                : filteredProducts
                                    .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data =
                                        document.data() as Map<String, dynamic>;
                                    return Card(
                                      elevation: 5,
                                      child: ListTile(
                                          title: Text(data['name']),
                                          leading: Image.network(data['url']),
                                          subtitle: Text(data['pid']),

                      //                      onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (_) => UpdateRecord(
                      //         Bproduct_Key: Product['key'],
                      //        // Bproduct_Key: Bproduct['key'],
                      //       ),
                      //     ),
                      //   );
                      // },
                                          // onTap: () {
                                          //   Navigater.push(
                                          //     context,
                                          //     MaterialApp.router(
                                          //       builder: (_) =>
                                          //           ProductDetails(data),
                                          //     ),
                                          //   );
                                          // },
                                          ),
                                    );
                                  }).toList(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
