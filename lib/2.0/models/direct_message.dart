class DirectMessage {
  final String dmID;
  // final DirectMessagesContent lastDmContent;
  final List users;
  final List photos;
  final List names;
  final List yearSecs;

  DirectMessage({
    required this.dmID,
    // required this.lastMessage,
    // required this.lastDmContent,
    required this.users,
    required this.photos,
    required this.names,
    required this.yearSecs,
  });

  factory DirectMessage.fromJson(Map<String, dynamic> json) {
    return DirectMessage(
      dmID: json['dm_id'],
      // lastMessage: json['last_message'],
      // lastDmContent: json['last_message'],
      users: json['users'],
      photos: json['photos'],
      names: json['names'],
      yearSecs: json['year_sections'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dm_id': dmID,
      // 'last_message': lastMessage,
      // 'last_message': lastDmContent,
      'users': users,
      'photos': photos,
      'names': names,
      'year_sections': yearSecs,
    };
  }
}
