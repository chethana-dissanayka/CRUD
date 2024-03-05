import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompletedOrdersScreen extends StatefulWidget {
  const CompletedOrdersScreen({Key? key});

  @override
  State<CompletedOrdersScreen> createState() => _CompletedOrdersScreenState();
}

class _CompletedOrdersScreenState extends State<CompletedOrdersScreen> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 157, 128),
      appBar: AppBar(
        title: Text(
          'Past Orders',
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: Color.fromARGB(255, 255, 141, 142),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/t.jpg'), // Replace with your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('CompletedOrders').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error loading orders: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot orderDocument = snapshot.data!.docs[index];
                    Map<String, dynamic> orderData = orderDocument.data() as Map<String, dynamic>;

                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 247, 218, 218),
                        border: Border.all(
                          color: Colors.black, // Set the border color
                          width: 2.0, // Set the border width
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(
                          'Order for ${orderData['customername']}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Address: ${orderData['address']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                            Text('Order Date: ${orderData['orderdate']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                            Text('Delivery Method: ${orderData['delivermethod']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                            Text('Receiver\'s Phone: ${orderData['receiversphone']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                            Text('Customer Name: ${orderData['customername']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                            Text('Total Payment: ${orderData['totalCost']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                            SizedBox(height: 10),
                            Text('Cart Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Column(
                              children: (orderData['cartItems'] as List).map((item) {
                                return ListTile(
                                  title: Text('Name: ${item['name']}'),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Price: ${item['price']}'),
                                      Image.network(
                                        item['url'],
                                        width: 100,
                                        height: 100,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red[900],
                                  ),
                                  onPressed: () async {
                                    try {
                                      await orderDocument.reference.delete();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Order deleted successfully!'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    } catch (error) {
                                      // Handle any errors that might occur during deletion
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Error deleting order: ${error.toString()}'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text('No completed orders found'));
              }
            },
          ),
        ],
      ),
    );
  }
}

