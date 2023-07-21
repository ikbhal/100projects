import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddContactPage extends StatefulWidget {
  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();

  Future<void> addContact() async {
    final contact = {
      'name': _nameController.text,
      'mobile': _mobileController.text,
    };

    final response = await http.post(Uri.parse(
      'https://contacts.rontohub.com/api/contacts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(contact),
    );

    if (response.statusCode == 200) {
      // Show snackbar on success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Contact added successfully'),
        ),
      );
    } else {
      // Show snackbar on failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add contact'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(labelText: 'Mobile'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a mobile number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addContact();
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
