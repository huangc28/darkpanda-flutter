/// MobileMasker transforms the original string to a combinition of asterisks and the followed
/// by a few characters of original string. For example: 12345678 ---> *****678
class MobileMasker {
  static String mask(String str) {
    if (str.length <= 3) {
      return str;
    }

    var masked = '';

    for (var i = 0; i < str.length; i++) {
      masked += i < str.length - 3 ? '*' : str[i];
    }

    return masked;
  }
}
