import 'package:flutter/material.dart';
import 'package:newcosmetic2/components/custom_button.dart';
import 'package:newcosmetic2/components/custom_text_input.dart';
import 'package:newcosmetic2/utils/application_state.dart';
import 'package:newcosmetic2/utils/custom_theme.dart';
import 'package:newcosmetic2/utils/login_data.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loadingButton = false;

  Map<String, String> data = LoginData.SignIn;

  void switchLogin() {
    setState(() {
      if (data == LoginData.SignUp) {
        data = LoginData.SignIn;
      } else {
        data = LoginData.SignUp;
      }
    });
  }

  void loginError(FirebaseAuthException e) {
    setState(() {
      _loadingButton = false;
    });

    // Show failure message
    showFailureSnackBar("Login failed: ${e.message}");
  }

  void loginSuccess() {
    setState(() {
      _loadingButton = false;
    });

    // Show success message
    showSuccessSnackBar("Login successful");


  }

  void signupError(FirebaseAuthException e) {
    setState(() {
      _loadingButton = false;
    });

    showFailureSnackBar("Sign up failed: ${e.message}");
  }

  void signupSuccess() {
    setState(() {
      _loadingButton = false;
    });

 
    showSuccessSnackBar("Sign up successful");

    
  }

  void loginButtonPressed() {
    setState(() {
      _loadingButton = true;
    });

    ApplicationState applicationState =
        Provider.of<ApplicationState>(context, listen: false);
    if (data == LoginData.SignUp) {
      applicationState.signUp(
          _emailController.text, _passwordController.text, signupError,signupSuccess);
    } else {
      applicationState.signIn(
          _emailController.text, _passwordController.text, loginError, loginSuccess);
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    body: SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/t.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40.0, bottom: 30, top: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        data["heading"]!,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    Text(
                      data["subHeading"]!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              model(data, _emailController, _passwordController),
              Padding(
                padding: const EdgeInsets.only(top:20, bottom: 110),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: switchLogin,
                      child: SizedBox(
                        height: 50,
                        child: Text(
                          data["footer"]!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


  Widget model(Map<String, String> data, TextEditingController emailController,
      TextEditingController passwordController) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(right: 20, left: 20, top: 30, bottom: 60),
      decoration: CustomTheme.getCardDecoration(),
      child: Column(
        children: [
          CustomTextInput(
            label: "Your email address",
            placeholder: "email@address.com",
            icon: Icons.person_outline,
            textEditingController: _emailController,
          ),
          CustomTextInput(
            label: "Password",
            placeholder: "password",
            icon: Icons.lock_outlined,
            password: true,
            textEditingController: _passwordController,
          ),
          CustomButton(
            text: data["label"]!,
            onPress: loginButtonPressed,
            loading: _loadingButton,
          ),
        ],
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

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }
}


