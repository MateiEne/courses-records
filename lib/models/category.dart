class Category {
  final int id;
  final String title;
  final String? description;
  final int? coursesNumber;
  final int? maxStudentsNumber;
  final String imageUrl;

  Category({
    required this.id,
    required this.title,
    required this.description,
    required this.coursesNumber,
    required this.maxStudentsNumber,
    required this.imageUrl,
  });

  Category.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'],
        coursesNumber = map['coursesNumber'],
        maxStudentsNumber = map['maxStudentsNumber'],
        imageUrl = map['imageUrl'];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "coursesNumber": coursesNumber,
      "maxStudentsNumber": maxStudentsNumber,
      "imageUrl": imageUrl,
    };
  }
}
