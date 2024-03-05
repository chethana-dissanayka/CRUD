import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({Key? key}) : super(key: key);

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 157, 128),
      appBar: AppBar(
        title: Text(
          'New Orders',
          style: TextStyle(fontSize: 25),
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

          Padding(
            padding: const EdgeInsets.all(8.0),
                child: Column(
               
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
                // Search Bar
                Container(
                  margin: EdgeInsets.all(5),
                  child: TextField(
                    
                    controller: searchController,
                    
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      hintText: 'Search by customer Name',
                      fillColor: Color.fromARGB(255, 255, 160, 160),
                      filled: true,
                      border: OutlineInputBorder(
                        
                        borderRadius: BorderRadius.circular(20),
                        
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collectionGroup("FinalorderItems")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
            
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
            
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No orders available.'));
                }
                   var filteredProducts = snapshot.data!.docs
                          .where((doc) =>
                              doc['customername']
                                  .toString()
                                  .contains(searchController.text) 
                              // doc['name']
                              //     .toString()
                              //     .toLowerCase()
                              //     .contains(searchController.text.toLowerCase())
                              )
                          .toList();
            
                // return ListView.builder(
                //   itemCount: snapshot.data!.docs.length,
                //   itemBuilder: (context, index) {
                //     DocumentSnapshot orderDocument = snapshot.data!.docs[index];
                //     Map<String, dynamic> orderData =
                //         orderDocument.data() as Map<String, dynamic>;

                           return ListView.builder(
                                                itemCount: filteredProducts.length,
                                   itemBuilder: (context, index) {
                          DocumentSnapshot orderDocument = filteredProducts[index];
                          Map<String, dynamic> orderData =
                              orderDocument.data() as Map<String, dynamic>;
                          orderData['key'] = orderDocument.id;
            
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
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address: ${orderData['address']}',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Order Date: ${orderData['orderdate']}',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Delivery Method: ${orderData['delivermethod']}',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Receiver\'s Phone: ${orderData['receiversphone']}',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Customer Name: ${orderData['customername']}',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Total Payment: ${orderData['totalCost']}',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text('Cart Items:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Column(
                              children:
                                  (orderData['cartItems'] as List).map((item) {
                                return ListTile(
                                  title: Text('Name: ${item['name']}'),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Price: ${item['price']}'),
                                      // Retrieve the image of the cart item
                                      Image.network(
                                        item[
                                            'url'], // Assuming 'url' is the field containing the image URL
                                        width: 100, // Adjust the width as needed
                                        height:
                                            100, // Adjust the height as needed
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
                                          content:
                                              Text('Order deleted successfully!'),
                                        ),
                                      );
                                    } catch (error) {
                                      // Handle any errors that might occur during deletion
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Error deleting order: ${error.toString()}'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.assignment_turned_in_rounded,
                                      color: Colors.red[900]),
                                  onPressed: () async {
                                    try {
                                      final orderDocument =
                                          snapshot.data!.docs[index];
            
                                      await FirebaseFirestore.instance
                                          .collection('CompletedOrders')
                                          .doc(orderDocument.id)
                                          .set(orderDocument.data() as Map<String,
                                              dynamic>); // Cast data to Map<String, dynamic>
            
                                      await orderDocument.reference.delete();
            
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.green,
                                            content: Text(
                                                'Order moved to Completed Orders!')),
                                                 
                                      );
                                    } catch (error) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.green,
                                            content: Text(
                                                'Error moving order: ${error.toString()}')),
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
              },
            ),
          ),
              ]
          ),
          )
        ],
      ),
    );
    
  }
}

