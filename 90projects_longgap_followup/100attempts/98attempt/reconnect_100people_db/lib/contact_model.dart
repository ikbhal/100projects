
class Contact {
  int id=0;
  String name='';
  String mobileNumber='';
  String notes='';

  Contact({required this.id, required this.name, required this.mobileNumber, this.notes=''});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mobileNumber': mobileNumber,
      'notes': notes,
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      mobileNumber: map['mobileNumber'],
      notes: map['notes'],
    );
  }
}
