import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_user_event.dart';
part 'auth_user_state.dart';

class AuthUserBloc extends Bloc<AuthUserEvent, AuthUserState> {
  AuthUserBloc() : super(AuthUserState.initial());

  @override
  Stream<AuthUserState> mapEventToState(
    AuthUserEvent event,
  ) async* {
    if (event is PatchJwt) {
      yield AuthUserState.patchJwt(jwt: event.jwt);

      return;
    }
  }
}
