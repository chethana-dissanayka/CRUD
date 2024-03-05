import 'package:flutter/material.dart';
import 'package:newcosmetic2/components/custom_button.dart';
import 'package:newcosmetic2/orderhistory.dart';
import 'package:newcosmetic2/utils/application_state.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loadingButton = false;

  void signOutButtonPressed() async {
    setState(() {
      _loadingButton = true;
    });

    try {
      Provider.of<ApplicationState>(context, listen: false).signOut();
      // Show success message
      showSuccessSnackBar("Sign out successful");
    } catch (error) {
      // Show failure message
      showFailureSnackBar("Failed to sign out");
    } finally {
      setState(() {
        _loadingButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBackground(
        context,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "Hi There",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            CustomButton(
              text: "SIGN OUT",
              onPress: signOutButtonPressed,
              loading: _loadingButton,
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 500),
        child: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 8, 8, 8),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CompletedOrdersScreen(),
              ),
            );
          },
          child: Icon(
            Icons.assignment_turned_in_rounded,
            color: Colors.white,
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Profile',
        ),
        backgroundColor: Color.fromARGB(255, 255, 141, 142),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget buildBackground(BuildContext context, Widget child) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/t.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: child,
      ),
    );
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
