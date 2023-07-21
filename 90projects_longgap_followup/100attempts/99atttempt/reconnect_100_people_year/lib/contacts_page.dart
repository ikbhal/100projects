import 'package:flutter/material.dart';
import 'package:reconnect_100_people_year/view_contact_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_contact_page.dart';
import 'contact.dart';
import 'edit_contact_page.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Contacts'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            title: Text(contact.name),
            subtitle: Text(contact.mobileNumber),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.call),
                  onPressed: () {
                    _makeCall(contact.name);
                  },
                ),
                // IconButton(
                //   icon: Icon(Icons.visibility),
                //   onPressed: () {
                //     _viewContact(contact);
                //   },
                // ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editContact(contact);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _confirmDeleteContact(contact);
                  },
                ),
              ],
            ),
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

  void _makeCall(String contactNumber) async {
    final phoneNumberUrlString = 'tel:$contactNumber';
    final Uri phoneNumberUri = Uri.parse(phoneNumberUrlString);

    if (await canLaunchUrl(phoneNumberUri)) {
      await launchUrl(phoneNumberUri);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to make the call.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _navigateToAddContactPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddContactPage()),
    ).then((newContact) {
      if (newContact != null) {
        _addContact(newContact);
      }
    });
  }

  void _addContact(Contact newContact) {
    setState(() {
      contacts.add(newContact);
    });
  }

  void _viewContact(Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ViewContactPage(contact: contact)),
    );
  }

  void _editContact(Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditContactPage(contact: contact)),
    ).then((updatedContact) {
      if (updatedContact != null) {
        setState(() {
          contact.name = updatedContact.name;
          contact.mobileNumber = updatedContact.mobileNumber;
        });
      }
    });
  }

  void _deleteContact(Contact contact) {
    setState(() {
      contacts.remove(contact);
    });
  }

  void _confirmDeleteContact(Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this contact?' + contact.name),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteContact(contact);
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

}
