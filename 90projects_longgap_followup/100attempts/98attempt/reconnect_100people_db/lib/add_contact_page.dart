import 'package:flutter/material.dart';

import 'contact_model.dart';
import 'contact_provider.dart';

class AddContactPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
              onPressed: () {
                _saveContact(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveContact(BuildContext context) async {
    final name = _nameController.text;
    final mobileNumber = _mobileNumberController.text;

    if (name.isNotEmpty && mobileNumber.isNotEmpty) {
      final newContact = Contact(name: name, mobileNumber: mobileNumber, id: 0);
      final provider = ContactProvider();
      await provider.addContact(newContact);

      Navigator.pop(context, true); // Return success status to previous page
    }
  }
}
