import 'package:flutter/material.dart';
import 'package:student_management_hive/Core/core.dart';
import 'package:student_management_hive/Infrasturcture/db_functions.dart';
import 'package:student_management_hive/Model/student_model.dart';

class ScreenStudentHome extends StatelessWidget {
  ScreenStudentHome({super.key});
  final studentNameController = TextEditingController();
  final studentRollNoController = TextEditingController();
  final studentMarksController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<StudentModel?> editingStudent = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    getAllStudents();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Students Management',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .45,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 8),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: studentNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Student Name Required';
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Student Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: studentRollNoController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Student Roll Number Required';
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Student Roll Number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: studentMarksController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Student Marks Required';
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Student Marks',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ValueListenableBuilder<StudentModel?>(
                            valueListenable: editingStudent,
                            builder: (context, editing, _) {
                              return ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (editing != null) {
                                      // We're editing, so update
                                      StudentModel updated = StudentModel(
                                        id: editing.id,
                                        studentName: studentNameController.text,
                                        studentRollNumber:
                                            studentRollNoController.text,
                                        studentMarks:
                                            studentMarksController.text,
                                      );
                                      updateStudent(updated);
                                      editingStudent.value = null;
                                    } else {
                                      // We're adding a new student
                                      StudentModel s = StudentModel(
                                        id: "",
                                        studentName: studentNameController.text,
                                        studentRollNumber:
                                            studentRollNoController.text,
                                        studentMarks:
                                            studentMarksController.text,
                                      );
                                      addStudent(s);
                                    }

                                    // Clear fields after either action
                                    studentMarksController.clear();
                                    studentNameController.clear();
                                    studentRollNoController.clear();
                                  }
                                },
                                child: Text(
                                  editing != null
                                      ? 'Update Student'
                                      : 'Add Student',
                                ),
                              );
                            },
                          ),

                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              clearStudents();
                            },
                            child: Text('Clear'),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.indigo),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * .55,
            child: ValueListenableBuilder(
              valueListenable: studentsList,
              builder: (context, List<StudentModel> newstudentsList, _) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    var studentData = newstudentsList[index];
                    return ListTile(
                      leading: Text('${index + 1}'.toString()),
                      title: Text(studentData.studentName),
                      subtitle: Row(
                        children: [
                          Text('Roll Number:${studentData.studentRollNumber}'),
                          Spacer(),
                          IconButton(
                            onPressed: () async {
                              await deleteStudent(studentData.id);
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                          IconButton(
                            onPressed: () {
                              studentNameController.text =
                                  studentData.studentName;
                              studentRollNoController.text =
                                  studentData.studentRollNumber;
                              studentMarksController.text =
                                  studentData.studentMarks;

                              // Now user can modify fields, and then click "Update Student"
                              editingStudent.value = studentData;
                            },
                            icon: Icon(Icons.edit),
                          ),
                        ],
                      ),

                      trailing: Text(studentData.studentMarks),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: newstudentsList.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
