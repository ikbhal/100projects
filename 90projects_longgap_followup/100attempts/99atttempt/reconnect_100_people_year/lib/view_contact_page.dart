import 'package:flutter/material.dart';

import 'contact.dart';

class ViewContactPage extends StatefulWidget {
  final Contact contact;

  ViewContactPage({required this.contact});

  @override
  _ViewContactState createState() => _ViewContactState();
}
class _ViewContactState extends State<ViewContactPage> {

  @override
  Widget build(BuildContext context) {
    final Contact contact = widget.contact;

    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${contact.name}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Mobile Number: ${contact.mobileNumber}'),
            // SizedBox(height: 8.0),
            // Text('Last Contacted: ${contact.lastContacted.toString()}'),
          ],
        ),
      ),
    );
  }
}
