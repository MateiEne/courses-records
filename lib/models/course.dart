class Course {
  final int id;
  final String title;
  final String? description;
  final int date;
  final double duration;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.duration,
  });

  Course.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'],
        date = map['date'],
        duration = map['duration'];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date,
      "duration": duration,
    };
  }
}
