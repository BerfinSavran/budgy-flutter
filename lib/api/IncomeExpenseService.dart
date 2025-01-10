import 'dart:convert';
import 'dart:io';
import 'package:budgy/api/UserService.dart';
import 'package:budgy/api/token_storage.dart';
import 'package:http/io_client.dart';

class IncomeExpenseService {
  static final String baseUrl = "https://10.0.2.2:7091/api/IncomeExpense";

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
      return data.map((item) => item as Map<String, dynamic>).toList();
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
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      print("Login failed: ${response.body}");
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
  }

  static Future<bool> addIncomeExpense(String categoryId,int amount,int inExType,String description,String date) async {
    final uri = Uri.parse(baseUrl);

    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    final ioClient = IOClient(httpClient);

    final response = await ioClient.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + await TokenStorage.getToken().toString()
        },
        body: json.encode({
          "userId":UserService.user_id,
          "categoryId":categoryId,
          "amount":amount,
          "inExType":inExType,
          "description":description,
          "date":date
        })
    );

    if (response.statusCode == 200) {

      return bool.parse(response.body);  // JWT token
    } else {
      print("Login failed: ${response.body}");
      return bool.parse(response.body);

    }
  }

  static Future<List<Map<dynamic,dynamic>>> getMonthlyTotals() async {
    final uri = Uri.parse(baseUrl+ "/MonthlyTotals/"+UserService.user_id);

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
        var datad = (jsonDecode(response.body) as List)
            .map((dynamic e) {
          if (e is Map<dynamic, dynamic>) {
            return e; // Veriyi doğrudan al
          } else {
            // Burada hatalı bir veriyle karşılaşıldığında işlem yapılabilir.
            return {}; // Hata durumunda boş bir Map dönebiliriz
          }
        }).toList();


        print(datad);

        return datad;  // JWT token
      } else {
        print("Login failed: ${response.body}");
        final List<Map<String,dynamic>> data = json.decode(response.body);
        return data;

    }
  }


}
