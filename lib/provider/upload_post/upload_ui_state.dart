import 'package:blog_rest_api_provider/data/model/blog_upload_response.dart';

abstract class UploadUIState {}

class UploadFormState extends UploadUIState{

}
class UploadUILoading extends UploadUIState {
  final double progress;
  UploadUILoading(this.progress);
}

class UploadUISuccess extends UploadUIState {
  final BlogUploadResponse blogUploadResponse;

  UploadUISuccess(this.blogUploadResponse);
}

class UploadUIFailed extends UploadUIState {
  final String errorMessage;

  UploadUIFailed(this.errorMessage);
}
