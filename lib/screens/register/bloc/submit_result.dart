import 'dart:async';

class RegisterFailedEvent {
  String error = '';

  RegisterFailedEvent({this.error});
}

class SubmitResult {
  RegisterFailedEvent error;

  final _submitResultController = StreamController<Map<String, dynamic>>();
  final _registerFailedController = StreamController<RegisterFailedEvent>();

  Sink get submitResultSink => _submitResultController.sink;
  Stream get submitResultStream => _submitResultController.stream;

  Sink get registerFailedSink => _registerFailedController.sink;
  Stream get registerFailedStream => _submitResultController.stream;

  /// Initialize a stream listener to handle API result from _submitResultController.sink
  SubmitResult() {
    _submitResultController.stream.listen(_registerAPIResponseHandler);

    _registerFailedController.stream.listen(_registerFailedHandler);
  }

  _registerAPIResponseHandler(Map<String, dynamic> response) {
    print('DEBUG 2 response $response');
  }

  _registerFailedHandler(RegisterFailedEvent evt) {
    error = evt;
  }

  void dispose() {
    _submitResultController.close();

    _registerFailedController.close();
  }
}
