import 'dart:convert';
import 'dart:io';
import 'package:budgy/api/UserService.dart';
import 'package:budgy/api/token_storage.dart';
import 'package:http/io_client.dart';

class CategoryService {
  static final String baseUrl = "https://10.0.2.2:7091/api/Category";

  static Future<List<Map<String, dynamic>>> getIncomeData() async {
    final uri = Uri.parse(baseUrl+ "/type/0/"+UserService.user_id);

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
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>(); // JWT token
    } else {
      print("Login failed: ${response.body}");
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
  }

  static Future<List<Map<String, dynamic>>> getExpenseData() async {
    final uri = Uri.parse(baseUrl+ "/type/1/"+UserService.user_id);

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
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>(); // JWT token
    } else {
      print("Login failed: ${response.body}");
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
  }

}
