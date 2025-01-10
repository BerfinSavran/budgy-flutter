import 'dart:convert';
import 'dart:io';
import 'package:budgy/api/UserService.dart';
import 'package:budgy/api/token_storage.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';

class GoalService {
  static final String baseUrl = "https://10.0.2.2:7091/api/Goal";

  static Future<void> addGoal(String categoryId,int amount,int inExType,String description,String startdate,String enddate) async {
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
          "startdate":startdate,
          "enddate":enddate
        })
    );

    if (response.statusCode == 200) {

        // JWT token
    } else {
      print("Login failed: ${response.body}");


    }
  }
  static Future<int> MonthlyPlannedBudget() async {
    DateTime now = DateTime.now();
    String nowDate = DateFormat("yyyy-MM-dd").format(now);

    final uri = Uri.parse(baseUrl+ "/dateRange/"+UserService.user_id+","+nowDate);

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
      var datad = int.parse(response.body);

      print(datad);

      return datad;  // JWT token
    } else {
      print("Login failed: ${response.body}");
      final datad = int.parse(response.body);
      return datad;

    }
  }
}