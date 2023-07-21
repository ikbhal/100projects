import 'package:flutter/material.dart';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import 'add_contact_page.dart';
import 'contact.dart';

void main() {
  runApp(ContactListApp());
}

class ContactListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactListPage(),
    );
  }
}

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    final response = await http.get(Uri.parse('https://contacts.rontohub.com/api/contacts'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      setState(() {
        contacts = jsonData.map((contact) => Contact.fromJson(contact)).toList();
      });
    }
  }

  Future<void> deleteContact(Contact contact) async {
    final response = await http.delete(
      Uri.parse('https://contacts.rontohub.com/api/contacts/${contact.id}'),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Contact deleted successfully'),
        ),
      );
      fetchContacts(); // Fetch updated contact list after deletion
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete contact'),
        ),
      );
    }
  }

  Future<void> confirmDeleteContact(Contact contact) async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${contact.name} (${contact.mobile})?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      deleteContact(contact);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact List'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchContacts,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int index) {
          final contact = contacts[index];
          return ListTile(
            title: Text(contact.name),
            subtitle: Text(contact.mobile),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => confirmDeleteContact(contact),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToAddContactScreen(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> navigateToAddContactScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddContactPage(),
      ),
    );
    fetchContacts(); // Fetch latest contacts after returning from AddContactPage
  }

}
