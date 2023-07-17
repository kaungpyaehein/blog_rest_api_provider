import 'package:blog_rest_api_provider/data/model/update_response.dart';

abstract class UpdateUIState {}

class UpdateFormState extends UpdateUIState {}

class UpdateUILoading extends UpdateUIState {
  final double progress;
  UpdateUILoading(this.progress);
}

class UpdateUISuccess extends UpdateUIState {
  final UpdateResponse blogUpdateResponse;

  UpdateUISuccess(this.blogUpdateResponse);
}

class UpdateUIFailed extends UpdateUIState {
  final String errorMessage;

  UpdateUIFailed(this.errorMessage);
}
