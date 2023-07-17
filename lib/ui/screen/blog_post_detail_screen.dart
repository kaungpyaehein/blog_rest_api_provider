import 'package:blog_rest_api_provider/data/model/get_one_post_response.dart';
import 'package:blog_rest_api_provider/data/service/blog_api_service.dart';
import 'package:blog_rest_api_provider/provider/get_complete_post/get_complete_post_notifier.dart';
import 'package:blog_rest_api_provider/provider/get_complete_post/get_complete_post_state.dart';
import 'package:blog_rest_api_provider/provider/update_post/blog_update_provider.dart';
import 'package:blog_rest_api_provider/ui/screen/home_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlogPostDetailScreen extends StatefulWidget {
  final int id;
  const BlogPostDetailScreen({super.key, required this.id});

  @override
  State<BlogPostDetailScreen> createState() => _BlogPostDetailScreenState();
}

class _BlogPostDetailScreenState extends State<BlogPostDetailScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getBlogDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<GetCompletePostNotifier>(
            builder: (_, getCompletePostNotifier, __) {
          GetCompletePostState getCompletePostState =
              getCompletePostNotifier.getCompletePostState;
          if (getCompletePostState is GetCompletePostSuccess) {
            GetOnePostResponse getOnePostResponse =
                getCompletePostState.getOnePostResponse;
            return Text(getOnePostResponse.title ?? "");
          } else if (getCompletePostState is GetCompletePostFailed) {
            return Text(getCompletePostState.errorMessage);
          }
          return (const Text(" "));
        }),
        actions: [
          Consumer<GetCompletePostNotifier>(
            builder: (_, getCompletePostNotifier, __) {
              GetCompletePostState getCompletePostState =
                  getCompletePostNotifier.getCompletePostState;
              if (getCompletePostState is GetCompletePostSuccess) {
                GetOnePostResponse getOnePostResponse =
                    getCompletePostState.getOnePostResponse;
                return IconButton(
                    onPressed: () {
                      _showPopupWindow(
                          body_one: getOnePostResponse.body ?? "",
                          title_one: getOnePostResponse.title ?? "");
                    },
                    icon: const Icon(Icons.settings));
              }
              return (const Text(" "));
            },
          ),
          IconButton(
              onPressed: () {
                Provider.of<GetCompletePostNotifier>(context, listen: false)
                    .deletePost(id: widget.id);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ));
              },
              icon: const Icon(Icons.delete)),
        ],
      ),
      body: Consumer<GetCompletePostNotifier>(
        builder: (_, getCompletePostNotifier, __) {
          GetCompletePostState getCompletePostState =
              getCompletePostNotifier.getCompletePostState;
          if (getCompletePostState is GetCompletePostSuccess) {
            GetOnePostResponse getOnePostResponse =
                getCompletePostState.getOnePostResponse;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(getOnePostResponse.body ?? ""),
                    const Divider(),
                    if (getOnePostResponse.photo != null)
                      CachedNetworkImage(
                          imageUrl:
                              "${BlogApiService.baseUrl}${getOnePostResponse.photo}"),
                  ],
                ),
              ),
            );
          } else if (getCompletePostState is GetCompletePostFailed) {
            return Column(
              children: [
                Text(getCompletePostState.errorMessage),
                const Divider(),
                ElevatedButton(
                    onPressed: () {
                      _getBlogDetail(widget.id);
                    },
                    child: const Text("Please try again"))
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _getBlogDetail(int id) {
    Provider.of<GetCompletePostNotifier>(context, listen: false)
        .getCompletePost(id: widget.id);
  }

  void _showPopupWindow({required String title_one, required String body_one}) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _bodyController = TextEditingController();
    _titleController.text = title_one;
    _bodyController.text = body_one;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<BlogUpdateNotifier>(builder: (_, value, __) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: const Text('Update Title and Body'),
              actions: [
                TextButton(
                    onPressed: () async {
                      if (_titleController.text.isNotEmpty &&
                          _bodyController.text.isNotEmpty) {
                        String title = _titleController.text;
                        String body = _bodyController.text;
                        int id = widget.id;

                        if (mounted) {
                          Provider.of<BlogUpdateNotifier>(context,
                                  listen: false)
                              .update(title: title, body: body, id: id);
                        }
                        Navigator.pop(context);
                        _getBlogDetail(widget.id);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please enter title and body")));
                      }
                    },
                    child: const Text("Update")),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
              content: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                        // labelText: "Update your blog title",
                        border: OutlineInputBorder()),
                  ),
                  const Divider(),
                  TextField(
                    maxLines: 5,
                    minLines: 3,
                    controller: _bodyController,
                    decoration: const InputDecoration(

                        // labelText: "Update your blog content",
                        border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
