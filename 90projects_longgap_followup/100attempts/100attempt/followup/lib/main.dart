import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(ReconnectApp());
}

class ReconnectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reconnect App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ContactsPage(),
    );
  }
}

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [
    Contact(name: 'John Doe', mobileNumber: '1234567890', priority: Priority.high),
    Contact(name: 'Jane Smith', mobileNumber: '9876543210', priority: Priority.medium),
    Contact(name: 'Alex Johnson', mobileNumber: '5555555555', priority: Priority.low),
  ];

  List<Contact> filteredContacts = [];

  @override
  void initState() {
    super.initState();
    filteredContacts = contacts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Contacts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                _filterContacts(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = filteredContacts[index];
                return ListTile(
                  title: Text(contact.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(contact.mobileNumber),
                      Text('Last Called: ${DateFormat.yMd().add_jm().format(contact.lastCalled)}'),
                    ],
                  ),
                  trailing: Column(
                    children: [
                      IconButton(
                        icon: _getPriorityIcon(contact.priority),
                        onPressed: () {
                          _makeCall(contact);
                        },
                      ),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _navigateToAddContactPage();
        },
      ),
    );
  }

  void _makeCall(Contact contact) async {
    final status = await Permission.phone.request();
    if (status.isGranted) {
      setState(() {
        contact.lastCalled = DateTime.now();
      });

      final phoneNumber = 'tel:${contact.mobileNumber}';

      if (await canLaunch(phoneNumber)) {
        await launch(phoneNumber);
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
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Permission Denied'),
          content: Text('You have denied phone call permission.'),
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
      _filterContacts('');
    });
  }

  void _filterContacts(String query) {
    setState(() {
      filteredContacts = contacts.where((contact) {
        final nameLower = contact.name.toLowerCase();
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
    });
  }

  void _editContact(Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditContactPage(contact: contact)),
    ).then((editedContact) {
      if (editedContact != null) {
        _updateContact(editedContact);
      }
    });
  }

  void _updateContact(Contact editedContact) {
    setState(() {
      final index = contacts.indexWhere((contact) => contact.name == editedContact.name);
      contacts[index] = editedContact;
      _filterContacts('');
    });
  }

  void _confirmDeleteContact(Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this contact?'),
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

  void _deleteContact(Contact contact) {
    setState(() {
      contacts.remove(contact);
      filteredContacts.remove(contact);
    });
  }

  Icon _getPriorityIcon(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Icon(Icons.arrow_upward, color: Colors.red);
      case Priority.medium:
        return Icon(Icons.arrow_forward, color: Colors.orange);
      case Priority.low:
        return Icon(Icons.arrow_downward, color: Colors.green);
    }
  }
}

class Contact {
  final String name;
  final String mobileNumber;
  final Priority priority;
  DateTime lastCalled = DateTime.now();

  Contact({required this.name, required this.mobileNumber, required this.priority}) {
    lastCalled = DateTime.now();
  }
}

enum Priority {
  high,
  medium,
  low,
}

class AddContactPage extends StatefulWidget {
  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  Priority _selectedPriority = Priority.low;

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
            DropdownButtonFormField<Priority>(
              value: _selectedPriority,
              onChanged: (Priority? newValue) {
                setState(() {
                  _selectedPriority = newValue!;
                });
              },
              items: Priority.values.map<DropdownMenuItem<Priority>>((Priority value) {
                return DropdownMenuItem<Priority>(
                  value: value,
                  child: Text(value.toString().split('.').last),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Priority',
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
        Contact(name: name, mobileNumber: mobileNumber, priority: _selectedPriority),
      );
    }
  }
}

class EditContactPage extends StatefulWidget {
  final Contact contact;

  EditContactPage({required this.contact});

  @override
  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  Priority _selectedPriority = Priority.low;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.contact.name;
    _mobileNumberController.text = widget.contact.mobileNumber;
    _selectedPriority = widget.contact.priority;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Contact'),
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
            DropdownButtonFormField<Priority>(
              value: _selectedPriority,
              onChanged: (Priority? newValue) {
                setState(() {
                  _selectedPriority = newValue!;
                });
              },
              items: Priority.values.map<DropdownMenuItem<Priority>>((Priority value) {
                return DropdownMenuItem<Priority>(
                  value: value,
                  child: Text(value.toString().split('.').last),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Priority',
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  child: Text('Save'),
                  onPressed: () {
                    _saveContact(context);
                  },
                ),
                ElevatedButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
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
        Contact(name: name, mobileNumber: mobileNumber, priority: _selectedPriority),
      );
    }
  }
}
