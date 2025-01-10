import 'dart:convert';
import 'dart:io';
import 'package:budgy/api/UserService.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';


class AuthService {

  // Login Method
  Future<String?> login({required String email, required String password}) async {
    final uri = Uri.parse("https://10.0.2.2:7091/api/Auth");
    try {
      HttpClient httpClient = HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      final ioClient = IOClient(httpClient);

      final response = await ioClient.post(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        UserService.user_id = data["user"]["id"];
        return data['token']; // JWT token
      } else {
        print("Login failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error during login: $e");
      return null;
    }
  }

  // Register Method
  Future<bool> register(String fullName, String email, String password) async {
    try {
      HttpClient httpClient = HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      final ioClient = IOClient(httpClient);

      final response = await ioClient.post(
        Uri.parse("https://10.0.2.2:7091/api/user"), // API URL
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'fullName': fullName,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        if (responseData == true) {
          print("Registration successful");
          return true;  // Başarı durumunda true döndür
        } else {
          print("Registration failed");
          return false;  // Başarısızlık durumunda false döndür
        }
      } else {
        print("Registration failed: ${response.body}");
        return false;  // API yanıtı 200 değilse false döndür
      }
    } catch (e) {
      print("An error occurred during registration: $e");
      return false;  // Hata durumunda false döndür
    }
  }
}
