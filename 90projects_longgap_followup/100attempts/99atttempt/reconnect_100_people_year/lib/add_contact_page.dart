import 'package:flutter/material.dart';

import 'contact.dart';

class AddContactPage extends StatefulWidget {
  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: _mobileNumberController,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                _saveContact(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveContact(BuildContext context) {
    final String name = _nameController.text;
    final String mobileNumber = _mobileNumberController.text;

    if (name.isNotEmpty && mobileNumber.isNotEmpty) {
      Navigator.pop(
        context,
        Contact(name: name, mobileNumber: mobileNumber),
      );
    }
  }
}
