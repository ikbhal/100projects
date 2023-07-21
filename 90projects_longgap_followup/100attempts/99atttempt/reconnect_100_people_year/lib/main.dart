import 'package:flutter/material.dart';
import 'contacts_page.dart';

void main() {
  runApp(ReconnectApp());
}

class ReconnectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reconnect App',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
        ),
      ),
      home: ContactsPage(),
    );
  }
}


