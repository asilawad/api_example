class Post {
  final int? id;
  final String title;
  final String body;

  Post({this.id, required this.title, required this.body});

  // من JSON لـ Object (لما البيانات توصلنا)
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(id: json['id'], title: json['title'], body: json['body']);
  }

  // من Object لـ JSON (لما نبعت بيانات)
  Map<String, dynamic> toJson() {
    return {'title': title, 'body': body, 'userId': 1};
  }
}
