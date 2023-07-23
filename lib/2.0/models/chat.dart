class Chat {
  final String name;
  final String photo;
  final String section;
  final String token;

  Chat({
    required this.name,
    required this.photo,
    required this.section,
    required this.token,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
        name: json['name'],
        photo: json['photo'],
        section: json['section'],
        token: json['token']);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photo': photo,
      'section': section,
      'token': token,
    };
  }
}
