class StudentNumber {
  String studentNumber;
  String lastName;
  String firstName;
  String mInitial;
  String college;
  String course;
  int yearLvl;
  int section;
  bool isused;
  String email;
  //2.0
  String photoUrl;
  String about;
  String deviceToken;
  bool isEnabled;

  StudentNumber({
    required this.studentNumber,
    required this.lastName,
    required this.firstName,
    required this.mInitial,
    required this.college,
    required this.course,
    required this.email,
    required this.isused,
    required this.yearLvl,
    required this.section,
    required this.photoUrl,
    required this.about,
    required this.deviceToken,
    required this.isEnabled,
  });

  factory StudentNumber.fromJson(Map<String, dynamic> json) {
    return StudentNumber(
      studentNumber: json['student_number'],
      lastName: json['last_name'],
      firstName: json['first_name'],
      mInitial: json['middle_initial'],
      college: json['college'],
      course: json['course'],
      email: json['email'],
      isused: json['is_used'],
      yearLvl: json['year_level'],
      section: json['section'],
      //
      photoUrl: json['photo_url'],
      about: json['about'],
      deviceToken: json['device_token'],
      isEnabled: json['is_enabled'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'student_number': studentNumber,
      'last_name': lastName,
      'first_name': firstName,
      'middle_initial': mInitial,
      'college': college,
      'course': course,
      'email': email,
      'year_level': yearLvl,
      'section': section,
      'is_used': isused,
      //
      'photo_url': photoUrl,
      'about': about,
      'device_token': deviceToken,
      'is_enabled': isEnabled,
    };
  }
}
