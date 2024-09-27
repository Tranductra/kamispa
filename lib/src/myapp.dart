import 'package:flutter/material.dart';
import 'package:kamispa/src/screens/addservicescreen.dart';
import 'package:kamispa/src/screens/admin_quanly_screen.dart';
import 'package:kamispa/src/screens/detailservicescreen.dart';
import 'package:kamispa/src/screens/loginscreen.dart';
import 'package:kamispa/src/screens/myhomepage.dart';
import 'package:kamispa/src/screens/updateservicescreen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/screens/admin' : (context) => Admin_QuanLy_Screen(),
        '/screens/login': (context) => LoginScreen(),
        '/screens/home': (context) => Home(),
        '/serviceDetail': (context) => ServiceDetailScreen(documentId: '',),
        '/updateService': (context) => UpdateServiceScreen(documentId: '',),
      },
      debugShowCheckedModeBanner: false,
      home:  LoginScreen(),
    );
  }
}