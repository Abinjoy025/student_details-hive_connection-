import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_management_hive/Core/core.dart';
import 'package:student_management_hive/Model/student_model.dart';

void addStudent(StudentModel s) async {
  final result = await Hive.openBox<StudentModel>("student_db");
  int id = await result.add(s);
  s.id = id.toString();
  await result.put(id, s);
  getAllStudents();
}

void getAllStudents() async {
  final result = await Hive.openBox<StudentModel>("student_db");
  studentsList.value.clear();
  studentsList.value.addAll(result.values);
  studentsList.notifyListeners();
}

Future<void> deleteStudent(String id) async {
  final box = await Hive.openBox<StudentModel>('student_db');
  int n = int.parse(id);
  await box.delete(n);
  getAllStudents();
}

void clearStudents() async {
  final box = await Hive.openBox<StudentModel>('student_db');
  await box.clear();
  getAllStudents();
}

void updateStudent(StudentModel s) async {
  final box = await Hive.openBox<StudentModel>('student_db');
  int id = int.parse(s.id);
  await box.put(id, s);
  getAllStudents();
}
