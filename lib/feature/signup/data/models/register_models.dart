import 'package:cloud_firestore/cloud_firestore.dart';

class Register {
  final String fullName;
  final String phoneNumber;
  final String gender;
  final String age;
  final String password; // Note: In practice, password should be hashed and handled securely

  Register({
    required this.fullName,
    required this.phoneNumber,
    required this.gender,
    required this.age,
    required this.password,
  });

  // Convert a Register instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'age': age,
      'password': password, // Ensure password is hashed before storing
    };
  }

  // Create a Register instance from a Firestore document
  factory Register.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Register(
      fullName: data['fullName'],
      phoneNumber: data['phoneNumber'],
      gender: data['gender'],
      age: data['age'],
      password: data['password'],
    );
  }

  // Convert a Register instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'age': age,
      'password': password,
    };
  }

  // Create a Register instance from JSON
  factory Register.fromJson(Map<String, dynamic> json) {
    return Register(
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      age: json['age'],
      password: json['password'],
    );
  }
}
