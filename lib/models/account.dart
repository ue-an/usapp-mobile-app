class Account {
  final String studNum;
  final String email;
  final DateTime created;

  Account({
    required this.studNum,
    required this.email,
    required this.created,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      studNum: json['stud_number'],
      email: json['email'],
      created: json['created'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'student_number': studNum,
      'email': email,
      'created': created,
    };
  }
}
