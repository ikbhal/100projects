class Contact {
  final int id;
  final String mobile;
  final String name;

  Contact({required this.id, required this.mobile, required this.name});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      mobile: json['mobile'],
      name: json['name'],
    );
  }
}
