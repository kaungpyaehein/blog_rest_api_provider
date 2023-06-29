import 'dart:html';

import 'package:blog_rest_api_provider/data/model/blog_upload_response.dart';
import 'package:blog_rest_api_provider/data/service/blog_api_service.dart';
import 'package:blog_rest_api_provider/provider/upload_post/upload_ui_state.dart';
import 'package:flutter/widgets.dart';
import 'package:dio/src/form_data.dart';


class BlogUploadNotifier extends ChangeNotifier {
  UploadUIState uploadUIState = UploadUILoading(0);
  final BlogApiService _blogApiService = BlogApiService();
  void upload({
    required String title,
    required String body,
    required FormData data,
  }) async {
    try {
      uploadUIState = UploadUILoading(0);
      BlogUploadResponse blogUploadResponse = await _blogApiService.uploadPost(
          title: title, body: body, data: data);
      uploadUIState = UploadUISuccess(blogUploadResponse);
    } catch (e) {
      uploadUIState = UploadUIFailed("Something went wrong");
    }
  }
}
