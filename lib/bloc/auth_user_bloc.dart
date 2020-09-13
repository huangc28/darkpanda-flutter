import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/pkg/secure_store.dart';

part 'auth_user_event.dart';
part 'auth_user_state.dart';

class AuthUserBloc extends Bloc<AuthUserEvent, AuthUserState> {
  AuthUserBloc() : super(AuthUserState.initial());

  @override
  Stream<AuthUserState> mapEventToState(
    AuthUserEvent event,
  ) async* {
    if (event is PatchJwt) {
      // store jwt in secure storage
      yield* _mapPatchJwtToState(event);
    }
  }

  Stream<AuthUserState> _mapPatchJwtToState(PatchJwt event) async* {
    // store jwt to security store.
    await SecureStore().fsc.write(
          key: 'jwt',
          value: event.jwt,
        );

    yield AuthUserState.patchJwt(jwt: event.jwt);
  }
}
