class Teacher {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String password;

  Teacher({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  Teacher.fromMap(Map<String, dynamic> map)
      : firstName = map['firstName'],
        lastName = map['lastName'],
        email = map['email'],
        password = map['password'] ?? '',
        phoneNumber = map['phoneNumber'];

  Map<String, dynamic> toMap() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phoneNumber": phoneNumber,
      "password": password,
    };
  }
}
