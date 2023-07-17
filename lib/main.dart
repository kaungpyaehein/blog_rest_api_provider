import 'package:blog_rest_api_provider/provider/get_all_post/get_all_provider.dart';
import 'package:blog_rest_api_provider/provider/get_complete_post/get_complete_post_notifier.dart';
import 'package:blog_rest_api_provider/provider/update_post/blog_update_provider.dart';
import 'package:blog_rest_api_provider/provider/upload_post/blog_upload_provider.dart';
import 'package:blog_rest_api_provider/ui/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> GetAllPostNotifier()),
        ChangeNotifierProvider(create: (_)=> GetCompletePostNotifier()),
        ChangeNotifierProvider(create: (_)=> BlogUploadNotifier()),
        ChangeNotifierProvider(create: (_) => BlogUpdateNotifier(),)
      ],
      child: const MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
