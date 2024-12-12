import 'package:fintech_dashboard_clone/styles/styles.dart';
import 'package:fintech_dashboard_clone/screens/home_page.dart';
import 'package:fintech_dashboard_clone/screens/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FintechDasboardApp());
}

class FintechDasboardApp extends StatelessWidget {
  const FintechDasboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Styles.scaffoldBackgroundColor,
        scrollbarTheme: Styles.scrollbarTheme,
      ),
        home: LoginPage(),  // Remove the 'const' keyword here.
    );
  }
}
