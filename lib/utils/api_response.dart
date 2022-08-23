/// A template class being used to listen for and hold api responses, states of this
/// class is mainly responsible for showing loading dialog and finally response
/// during and after api calls
class ApiResponse {
  dynamic model;
  String errorMessage = '';
  bool isLoading = true;
  ApiResponse.loading(this.isLoading);
  ApiResponse.success(this.isLoading, this.model);
  ApiResponse.error(this.isLoading, this.errorMessage);
}
