class CourseRecord {
  final int id;
  final double grade;
  final String studentEmail;
  final int courseId;

  CourseRecord({
    required this.id,
    required this.grade,
    required this.studentEmail,
    required this.courseId,
  });

  CourseRecord.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        grade = map['grade'],
        studentEmail = map['studentEmail'],
        courseId = map['courseId'];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "grade": grade,
      "studentEmail": studentEmail,
      "courseId": courseId,
    };
  }
}