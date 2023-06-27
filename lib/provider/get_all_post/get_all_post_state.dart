import '../../data/model/get_all_posts_response.dart';

abstract class GetAllPostState { }

class GetAllPostLoading extends GetAllPostState {}

class GetAllPostSuccess extends GetAllPostState {
  final List<GetAllPostsResponse> getAllPostList;

  GetAllPostSuccess(this.getAllPostList);
}

class GetAllPostFailed extends GetAllPostState {
  final String errorMessage;

  GetAllPostFailed(this.errorMessage);
}
