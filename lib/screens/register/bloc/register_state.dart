part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class Registering extends RegisterState {
  const Registering();
}

class RegisterFailed extends RegisterState {
  final String message;
  final String code;

  const RegisterFailed({this.message, this.code});
}

 class Registered extends RegisterState {
	final String username;
	final bool phoneVerified;
	final String gender;
	final String uuid;

	Registered({
		this.username,
		this.phoneVerified,
		this.gender,
		this.uuid,
	});

	static Registered fromJson(Map<String, dynamic> data) {
		return Registered(
			username: data['username'],
			phoneVerified: data['phone_verified'],
			gender: data['gender'],
			uuid: data['uuid'],
		);
	}
 }
