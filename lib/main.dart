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
      title: 'tumblrGram',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('tumblrGram'),
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
            return GridView.count(
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                children: List.generate(snapshot.data!.length, (index) {
                  return Stack(
                    children: [
                      Image.network(
                        snapshot.data![index].photo,
                        fit: BoxFit.cover,
                        loadingBuilder: (_, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              print(index);
                            },
                          ),
                        ),
                      ),
                    ],
                    fit: StackFit.expand,
                  );
                }));
          } else if (snapshot.hasError) {
            return const Text('Snapshot error');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class ImageBuilder extends StatelessWidget {
  final Future<String> futureImage;
  final int index;

  const ImageBuilder({Key? key, required this.futureImage, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          NetworkImage('');
        } else if (snapshot.hasError) {
          return const Text('Snapshot error');
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
