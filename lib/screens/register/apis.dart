import 'package:http/http.dart' as http;

Future<http.Response> fetchAlbum() {
  return http.get('https://jsonplaceholder.typicode.com/albums/1');
}

// @TODO API origin should be extract to environment variable
Future<http.Response> createNewUser(
    {String username, String gender, String referalCode}) {
  return http.post(
    'http://localhost:3001/v1/register',
    body: {
      'username': username,
      'gender': gender,
      'refer_code': referalCode,
    },
  );
}
