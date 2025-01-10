import 'dart:convert';
import 'dart:io';
import 'package:budgy/api/token_storage.dart';
import 'package:http/io_client.dart';

class UserService {
  static final String baseUrl = "https://10.0.2.2:7091/api";
  static  String user_id = "";

  static Future<Map<String,dynamic>?> getUserData() async {
    final uri = Uri.parse("https://10.0.2.2:7091/api/User/id/"+user_id);
    try {
      HttpClient httpClient = HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      final ioClient = IOClient(httpClient);

      final response = await ioClient.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + await TokenStorage.getToken().toString()
        }
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data; // JWT token
      } else {
        print("Login failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error during login: $e");
      return null;
    }
  }

  static Future<bool> updateUserData(String fullName, String telNo, String email, int? gender) async {
    final uri = Uri.parse("https://10.0.2.2:7091/api/User");
    try {
      HttpClient httpClient = HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      final ioClient = IOClient(httpClient);
      print(user_id);
      final response = await ioClient.post(
          uri,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + await TokenStorage.getToken().toString()
          },
          body: json.encode({
            'id': user_id,
            'fullName': fullName,
            'telNo': telNo,
            'email': email,
            'gender': gender,
          }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return true; // JWT token
      } else {
        print("Login failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error during login: $e");
      return false;
    }
  }

}
