class CourseRecord {
  final int id;
  final double grade;
  final int date;
  final String studentEmail;
  final int courseId;

  CourseRecord({
    required this.id,
    required this.grade,
    required this.date,
    required this.studentEmail,
    required this.courseId,
  });

  CourseRecord.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        grade = map['grade'],
        date = map['date'],
        studentEmail = map['studentEmail'],
        courseId = map['courseID'];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "grade": grade,
      "date": date,
      "studentEmail": studentEmail,
      "courseID": courseId,
    };
  }
}