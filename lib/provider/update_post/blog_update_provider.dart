import 'package:blog_rest_api_provider/data/model/update_response.dart';
import 'package:blog_rest_api_provider/provider/update_post/update_blog_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../data/service/blog_api_service.dart';

class BlogUpdateNotifier extends ChangeNotifier {
  UpdateUIState updateUIState = UpdateFormState();
  final BlogApiService _blogApiService = BlogApiService();
  void update({
    required int id,
    required String title,
    required String body,
  }) async {

    UpdateResponse blogUpdateResponse = await _blogApiService.updatePost(
      id: id,
      title: title,
      body: body,
    );
    updateUIState = UpdateUISuccess(blogUpdateResponse);
    notifyListeners();

    updateUIState = UpdateUISuccess(blogUpdateResponse);
    notifyListeners();
  }
}
