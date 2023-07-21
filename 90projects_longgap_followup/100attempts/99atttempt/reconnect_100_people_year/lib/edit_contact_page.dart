import 'package:flutter/material.dart';

import 'contact.dart';

class EditContactPage extends StatefulWidget {
  final Contact contact;

  EditContactPage({required this.contact});

  @override
  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.contact.name;
    _mobileNumberController.text = widget.contact.mobileNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Contact'),
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
                _saveChanges(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges(BuildContext context) {
    final String name = _nameController.text;
    final String mobileNumber = _mobileNumberController.text;

    if (name.isNotEmpty && mobileNumber.isNotEmpty) {
      final updatedContact = Contact(
        name: name,
        mobileNumber: mobileNumber,
        // lastContacted: widget.contact.lastContacted,
      );

      Navigator.pop(context, updatedContact);
    }
  }
}
