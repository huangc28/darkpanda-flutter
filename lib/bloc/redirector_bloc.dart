import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'redirector_event.dart';
part 'redirector_state.dart';

// This bloc handles redirect event. It's made for the purchase of handling redirection
// certain API exception, such as jwt expired or invalid. BaseClient would emit redirect
// event when receiving those kinds of API exception.
class RedirectorBloc extends Bloc<RedirectorBlocEvent, RedirectorBlocState> {
  RedirectorBloc() : super(RedirectorBlocInitial()) {
    on<NotifyRedirect>((event, emit) {
      print('redirect route ${event}');
    });
  }
}
