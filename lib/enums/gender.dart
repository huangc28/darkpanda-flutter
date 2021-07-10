import 'package:enum_to_string/enum_to_string.dart';

enum Gender {
  male,
  female,
}

extension GenderExtension on Gender {
  String get name => EnumToString.convertToString(this);
}
