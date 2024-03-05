import 'package:flutter/material.dart';

class CustomTheme {
  static const Color grey = Color.fromARGB(255, 85, 80, 80);
  static const Color yellow = Color.fromARGB(255, 237, 157, 128);
  static const cardShadow = [
    BoxShadow(color: grey, blurRadius: 6, spreadRadius: 4, offset: Offset(0, 2))
  ];
  static const buttonShadow = [
    BoxShadow(color: grey, blurRadius: 3, spreadRadius: 4, offset: Offset(1, 3))
  ];
  static getCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(35),
      boxShadow: cardShadow,
    );
  }

  static ThemeData getTheme() {
    // ignore: unused_local_variable
    Map<String, double> fontSize = {
      "sm": 14,
      "nd": 18,
      "lg": 24,
    };

    return ThemeData(
        primaryColor: yellow,
        fontFamily: 'DMSans',
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            toolbarHeight: 70,
            centerTitle: true,
            titleTextStyle: TextStyle(
                color: Colors.white,
                fontFamily: 'DMSans',
                fontSize: fontSize['lg'],
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        tabBarTheme: const TabBarTheme(
            labelColor: Color.fromARGB(255, 236, 108, 108),
            unselectedLabelColor: Colors.black),
        textTheme: TextTheme(
            headlineLarge: TextStyle(
                color: Colors.black,
                fontSize: fontSize['lg'],
                fontWeight: FontWeight.bold),
            headlineMedium: TextStyle(
                color: Colors.black,
                fontSize: fontSize['md'],
                fontWeight: FontWeight.bold),
            headlineSmall: TextStyle(
                color: Colors.black,
                fontSize: fontSize['sm'],
                fontWeight: FontWeight.bold),
            bodySmall: TextStyle(
                fontSize: fontSize['sm'], fontWeight: FontWeight.normal),
            titleSmall: TextStyle(
                fontSize: fontSize['sm'],
                fontWeight: FontWeight.bold,
                letterSpacing: 1)));
  }
}
