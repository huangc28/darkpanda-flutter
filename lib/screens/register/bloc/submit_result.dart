import 'dart:async';

class SubmitResult {
  final _submitResultController = StreamController<Map<String, dynamic>>();

  Sink get submitResultSink => _submitResultController.sink;
  Stream get submitResultStream => _submitResultController.stream;

  /// Initialize a stream listener to handle API result from _submitResultController.sink
  SubmitResult() {
    _submitResultController.stream.listen(_registerAPIResponseHandler);
  }
  _registerAPIResponseHandler(Map<String, dynamic> response) {
    print('DEBUG 2 response $response');
  }

  void dispose() {
    _submitResultController.close();
  }
}
