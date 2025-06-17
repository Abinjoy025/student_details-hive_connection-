import 'package:hive_flutter/adapters.dart';
part 'student_model.g.dart';

@HiveType(typeId: 1)
class StudentModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  String studentName;
  @HiveField(2)
  String studentRollNumber;
  @HiveField(3)
  String studentMarks;

  StudentModel({
    required this.id,
    required this.studentName,
    required this.studentRollNumber,
    required this.studentMarks,
  });
}
