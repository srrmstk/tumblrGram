import 'dart:convert';
import 'package:http/http.dart' as http;
import '../classes/post.dart';

Future<List<Post>> fetchBlogPhotos(String apiKey) async {
  final res = await http.get(Uri.parse(
      'https://api.tumblr.com/v2/blog/porygon-digital.tumblr.com/posts/photo?api_key=$apiKey'));
  if (res.statusCode == 200) {
    final decodedJson =
        json.decode(res.body)['response']['posts'].cast<Map<String, dynamic>>();
    return decodedJson.map<Post>((json) => Post.fromJson(json)).toList();
    // List<Post> posts = [];
    // resPosts.forEach((e) {
    //   Post post = Post.fromJson(e);
    //   posts.add(post);
    // });
    // return posts;
  } else {
    throw Exception('Failed to load data');
  }
}
