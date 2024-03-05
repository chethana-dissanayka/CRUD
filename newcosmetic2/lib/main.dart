
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:newcosmetic2/firebase_options.dart';
import 'package:newcosmetic2/homeimage.dart';
import 'package:newcosmetic2/insert.dart';
import 'package:newcosmetic2/order.dart';
import 'package:newcosmetic2/profile.dart';
import 'package:newcosmetic2/screens/login.dart';
import 'package:newcosmetic2/search.dart';
import 'package:newcosmetic2/update.dart';
import 'package:newcosmetic2/utils/application_state.dart';
import 'package:newcosmetic2/utils/custom_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Stripe setup
  final String response =
      await rootBundle.loadString("assets/config/stripe.json");
  final data = await json.decode(response);
  Stripe.publishableKey = data["publishablekey"];
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: (context, _) => Consumer<ApplicationState>(
      builder: (context, applicationState, _) {
        Widget child;
        switch (applicationState.loginState) {
          case ApplicationLoginState.loggedOut:
            child = LoginScreen();
            break;
          case ApplicationLoginState.loggedIn:
            child = MyApp();
            break;
          default:
            child = LoginScreen();
        }
        return MaterialApp(
          theme: CustomTheme.getTheme(),
          home: child,
        );
      },
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/t.jpg'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: CustomTheme.cardShadow,
              ),
              child: const TabBar(
                padding: EdgeInsets.symmetric(vertical: 10),
                indicatorColor: Colors.transparent,
                tabs: [
                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(Icons.image)),
                  Tab(icon: Icon(Icons.search)),
                  Tab(icon: Icon(Icons.shopping_bag)),
                  Tab(icon: Icon(Icons.person)),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Home(),
                HomeImageScreen(),
                SearchScreen(),
                AdminOrderScreen(),
                ProfileScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference bproducts =
        FirebaseFirestore.instance.collection('bproducts');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cosmetics Shop',
          style: TextStyle(fontSize: 25),
        ),
        backgroundColor: Color.fromARGB(255, 255, 141, 142),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 55.0),
        child: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 8, 8, 8),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ccreate(),
              ),
            );
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/t.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
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
                      hintText: 'Search by PID or Product Name',
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
                    stream: bproducts.snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      // Filter products based on the entered pid
                      var filteredProducts = snapshot.data!.docs
                          .where((doc) =>
                              doc['pid']
                                  .toString()
                                  .contains(searchController.text) ||
                              doc['name']
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchController.text.toLowerCase()))
                          .toList();

                      return ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = filteredProducts[index];
                          Map<String, dynamic> Bproduct =
                              document.data() as Map<String, dynamic>;
                          Bproduct['key'] = document.id;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UpdateRecord(
                                    Bproduct_Key: Bproduct['key'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 247, 218, 218),
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                          Bproduct['url'],
                                        ),
                                      ),
                                      title: Text(
                                        Bproduct['name'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text('Product Code: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text('${Bproduct['pid']}'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('Category: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text('${Bproduct['category']}'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('Price: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text('${Bproduct['price']}'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('Brand: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text('${Bproduct['brand']}'),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red[900],
                                                ),
                                                onPressed: () async {
                                                  try {
                                                    await bproducts
                                                        .doc(Bproduct['key'])
                                                        .delete();
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Product deleted successfully!'),
                                                        backgroundColor:
                                                            Colors.green,
                                                      ),
                                                    );
                                                  } catch (error) {
                                                    // Handle any errors
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Error deleting product: ${error.toString()}'),
                                                        backgroundColor:
                                                            Colors.red,
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
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
