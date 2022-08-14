import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'api/post_api.dart';
import 'classes/post.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Post>> futurePost;
  static final apiKey = dotenv.get('API_KEY');

  @override
  void initState() {
    super.initState();
    futurePost = fetchBlogPhotos(apiKey);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('tumblrApp'),
          ),
          body: PostBuilder(futurePost: futurePost)),
    );
  }
}

class PostBuilder extends StatelessWidget {
  final Future<List<Post>> futurePost;

  const PostBuilder({Key? key, required this.futurePost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
        future: futurePost,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => Center(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Image.network(snapshot.data![index].photo),
                    )));
          } else if (snapshot.hasError) {
            return const Text('Snapshot error');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
