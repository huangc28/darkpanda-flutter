import 'package:enum_to_string/enum_to_string.dart';

enum ServiceTypes {
  sex,
  diner,
  movie,
  shopping,
  chat,
}

extension ServiceTypesExtension on ServiceTypes {
  String get name => EnumToString.convertToString(this);
}
