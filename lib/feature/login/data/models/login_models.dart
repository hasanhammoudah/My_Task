class CustomUser {
  String uid;
  String phone;
  String password;
  String fullName;

  CustomUser({
    required this.uid,
    required this.phone,
    required this.password,
    required this.fullName,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phone': phone,
      'password': password,
      'fullName': fullName,
    };
  }

  factory CustomUser.fromMap(Map<String, dynamic> map) {
    return CustomUser(
      uid: map['uid'],
      phone: map['phone'],
      password: map['password'],
      fullName: map['fullName'],
    );
  }

  CustomUser copyWith({
    String? uid,
    String? phone,
    String? password,
    String? fullName,
  }) {
    return CustomUser(
      uid: uid ?? this.uid,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
    );
  }
}
