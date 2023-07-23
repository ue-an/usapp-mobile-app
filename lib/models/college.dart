class College {
  late String collegeName;
  late String campus;
  late String collegeID;
  List courses;

  College({
    required this.campus,
    required this.collegeName,
    required this.collegeID,
    required this.courses,
  });

  factory College.fromJson(Map<String, dynamic> json) {
    return College(
      collegeID: json['collegeID'],
      campus: json['campus'],
      collegeName: json['college_name'],
      courses: json['courses'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'collegeID': collegeID,
      'campus': campus,
      'college_name': collegeName,
      'courses': courses,
    };
  }
}
