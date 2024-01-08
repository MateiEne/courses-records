class Registration {
  final int id;
  final int date;
  final double price;
  final String studentEmail;

  Registration({
    required this.id,
    required this.date,
    required this.price,
    required this.studentEmail,
  });

  Registration.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        date = map['date'],
        price = map['price'],
        studentEmail = map['studentEmail'];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "date": date,
      "price": price,
      "studentEmail": studentEmail,
    };
  }
}
