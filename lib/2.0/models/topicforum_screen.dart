class TopicForumScreen {
  String forumID;
  String forumTitle;
  String forumDescription;
  String authorName;
  String authorSection;
  String forumDate;
  String authorID;
  List likersTokens;
  String authorToken;

  TopicForumScreen({
    required this.forumID,
    required this.forumTitle,
    required this.forumDescription,
    required this.forumDate,
    required this.authorID,
    required this.authorName,
    required this.authorSection,
    required this.authorToken,
    required this.likersTokens,
  });

  factory TopicForumScreen.fromJson(Map<String, dynamic> json) {
    return TopicForumScreen(
      forumID: json['forum_id'],
      forumTitle: json['forum_title'],
      forumDescription: json['forum_desc'],
      forumDate: json['forum_date'],
      authorID: json['author_id'],
      authorName: json['author_name'],
      authorSection: json['author_section'],
      authorToken: json['author_token'],
      likersTokens: json['likers_tokens'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'forum_id': forumID,
      'forum_title': forumTitle,
      'forum_desc': forumDescription,
      'forum_date': forumDate,
      'author_id': authorID,
      'author_name': authorName,
      'author_section': authorSection,
      'author_token': authorToken,
      'likers_tokens': likersTokens,
    };
  }
}
