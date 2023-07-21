import 'package:flutter/material.dart';

import 'contact_list_page.dart';
import 'add_contact_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact App',
      theme: ThemeData(
        primarySwatch: Colors.green, // Set primary swatch to green
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // textTheme: TextTheme(
        //   fore
        //   // Set foreground color to white for text
        //   bodyText1: TextStyle(color: Colors.white),
        //   bodyText2: TextStyle(color: Colors.white),
        // ),
      ),
      home: ContactListPage(),
      routes: {

        '/add_contact': (context) => AddContactPage(),
      },
    );
  }
}
