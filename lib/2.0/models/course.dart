import 'dart:io';

class Course {
  String college;
  String courseId;
  String courseName;
  int sections;
  int years;

  Course({
    required this.college,
    required this.courseId,
    required this.courseName,
    required this.sections,
    required this.years,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      college: json['college'],
      courseId: json['couresID'],
      courseName: json['course_name'],
      sections: json['sections'],
      years: json['years'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'college': college,
      'couresID': courseId,
      'course_name': courseName,
      'sections': sections,
      'years': years,
    };
  }
}
