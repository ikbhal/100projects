import 'package:flutter/material.dart';

import 'contact_model.dart';
import 'contact_provider.dart';

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    final provider = ContactProvider();
    final retrievedContacts = await provider.getContacts();
    setState(() {
      contacts = retrievedContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact List'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            title: Text(contact.name),
            subtitle: Text(contact.mobileNumber),
            onTap: () {
              _viewContact(contact);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _navigateToAddContactPage();
        },
      ),
    );
  }

  void _viewContact(Contact contact) {
    // Implement the logic to view contact details here
  }

  void _navigateToAddContactPage() {
    // Implement the navigation to the add contact page here
  }
}
