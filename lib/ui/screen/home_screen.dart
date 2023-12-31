import 'package:blog_rest_api_provider/data/model/get_all_posts_response.dart';
import 'package:blog_rest_api_provider/provider/get_all_post/get_all_post_state.dart';
import 'package:blog_rest_api_provider/provider/get_all_post/get_all_provider.dart';
import 'package:blog_rest_api_provider/ui/screen/blog_post_detail_screen.dart';
import 'package:blog_rest_api_provider/ui/screen/blog_upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getAllPost(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog api lesson"),
        centerTitle: true,
      ),
      body: Consumer<GetAllPostNotifier>(
        builder: (_, getAllProvider, __) {
          GetAllPostState getAllPostState = getAllProvider.getAllPostState;
          if (getAllPostState is GetAllPostSuccess) {
            List<GetAllPostsResponse> getAllPostResponseList =
                getAllPostState.getAllPostList;
            return RefreshIndicator(
              onRefresh: () {
                _getAllPost(context);
              return Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                itemCount: getAllPostResponseList.length,
                itemBuilder: (context, index) {
                  GetAllPostsResponse getAllPostResponse =
                      getAllPostResponseList[index];
                  return InkWell(
                    onTap: () {
                      if (getAllPostResponse.id != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlogPostDetailScreen(
                                  id: getAllPostResponse.id!),
                            ));
                      }
                    },
                    child: Card(
                      child: ListTile(
                        title: Text("${getAllPostResponse.title}"),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (getAllPostState is GetAllPostFailed) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Oops! Something went wrong"),
                const Divider(),
                ElevatedButton(
                  onPressed: () {
                    _getAllPost(context);
                  },
                  child: const Text("Try Again"),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (__) => const BlogUploadScreen(),
              ));
          if (result != null && result == "success") {
            if (mounted) {
              _getAllPost(context);
            }
          }
        },
      ),
    );
  }

  void _getAllPost(BuildContext ctx) {
    Provider.of<GetAllPostNotifier>(ctx, listen: false).getAllPost();
  }
}
