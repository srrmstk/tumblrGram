class Post {
  final int id;
  final String photo;

  const Post({required this.id, required this.photo});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'], photo: json['photos'][0]['original_size']['url']);
  }
}
