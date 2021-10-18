/// Try to parse decimal value with zero decimal to int.
/// If decimal has value, return decimal value
/// Eg. 1.00 to 1
///     1.10 to 1.10

String convertZeroDecimalToInt(double value) {
  if ((value % 1) == 0) {
    int number = value.toInt();
    return number.toString();
  } else {
    return value.toStringAsFixed(2);
  }
}
