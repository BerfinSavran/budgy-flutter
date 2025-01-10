import 'package:budgy/api/IncomeExpenseService.dart';
import 'package:flutter/material.dart';
import '../api/UserService.dart';
import '../api/token_storage.dart';
import '../components/budgetLineChart.dart';
import '../components/customAnalysisCard.dart';
import '../components/customBottomNavBar.dart';
import '../components/customDialog.dart';
import '../components/customFab.dart';
import 'login_screen.dart';

class AnalysisScreen extends StatefulWidget {
  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  int _currentIndex = 1;

  String? userName;
  List<Map<String, dynamic>> incomeData = [];
  List<Map<String, dynamic>> formattedIncomeData = [];
  List<Map<String, dynamic>> expenseData = [];
  List<Map<String, dynamic>> formattedExpenseData = [];
  List<Map<String, dynamic>> chartIncomeData = [];
  List<Map<String, dynamic>> chartExpenseData = [];

  final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  // Şu anki tarih bilgisi
  final currentYear = DateTime.now().year;
  final currentMonth = DateTime.now().month;

  void initState() {
    super.initState();
    _checkLoginStatus();
    fetchUserName();
    fetchIncomeData();
    fetchExpenseData();
  }

  Future<void> fetchIncomeData() async{
    formattedIncomeData = [];
    final data = await IncomeExpenseService.getIncomeData();

    setState(() {
      incomeData = data;
    });

    for (final item in incomeData) {
      final year = item["year"];
      final month = item["month"];

      if (year == currentYear && month == currentMonth) {
        final items = item["items"] ?? [];


        for (final subItem in items) {

          formattedIncomeData.add({
            "name": subItem["name"],
            "amount": subItem["amount"],
            "date": "$year-$month-${subItem["day"]}", // Tarihi birleştir
          });
        }
      }
    }

    chartIncomeData = prepareIncomeChartData(incomeData);

  }

  Future<void> fetchExpenseData() async{
    formattedExpenseData = [];
    final data = await IncomeExpenseService.getExpenseData();

    setState(() {
      expenseData = data;
    });

    for (final item in expenseData) {
      final year = item["year"];
      final month = item["month"];

      if (year == currentYear && month == currentMonth) {
        final items = item["items"] ?? [];

        for (final subItem in items) {
          formattedExpenseData.add({
            "name": subItem["name"],
            "amount": subItem["amount"],
            "date": "$year-$month-${subItem["day"]}", // Tarihi birleştir
          });
        }
      }
    }
    print(expenseData);
    chartExpenseData = prepareExpenseChartData(expenseData);


  }

  List<Map<String,dynamic>> prepareIncomeChartData(List<Map<String,dynamic>> oldData) {

    // Gelir verilerini filtrele ve düzenle
    List<Map<String,dynamic>> newData = oldData
        .where((entry) => entry['year'] == currentYear && entry['month'] == currentMonth) // Yıl ve ay filtresi
        .expand((entry) => entry['items'])
        .map((subItem) {
      return {
        "day": subItem['day'].toString(), // Gün
        "income": subItem['amount'], // Gelir miktarı
      };
    }).toList().reversed.toList();

    return newData;

    // Gider Verilerini Hazırla

  }
  List<Map<String,dynamic>> prepareExpenseChartData(List<Map<String,dynamic>> oldData) {

    // Gelir verilerini filtrele ve düzenle
    List<Map<String,dynamic>> newData = oldData
        .where((entry) => entry['year'] == currentYear && entry['month'] == currentMonth) // Yıl ve ay filtresi
        .expand((entry) => entry['items'])
        .map((subItem) {
      return {
        "day": subItem['day'].toString(), // Gün
        "expense": subItem['amount'], // Gelir miktarı
      };
    }).toList().reversed.toList();

    return newData;

    // Gider Verilerini Hazırla

  }

  /*
  * chartExpenseData = expenseData
        .where((entry) => entry['year'] == currentYear && entry['month'] == currentMonth)
        .expand((entry) => entry['items'])
        .map((subItem) {
      return {
        "day": subItem['day'], // Gün
        "expense": subItem['amount'], // Gider miktarı
      };
    }).toList();*/

  Future<void> fetchUserName() async {
    final userData = await UserService.getUserData();
    if (userData != null && userData['fullName'] != null) {
      setState(() {
        userName = userData['fullName']; // Kullanıcı adını değişkene ata
      });
    }
  }

  Future<void> _checkLoginStatus() async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(chartIncomeData);

    return DefaultTabController(
      length: 2, // Tab sayısı
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Üst Başlık
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: EdgeInsets.only(bottom: 5),
                color: Color(0xFF97349e),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Budgy",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          userName ?? "Bilinmiyor",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // TabBar Ekleniyor
              Container(
                color: Color(0xFFf3ebf5),
                child: const TabBar(
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: Color(0xFF97349e), width: 3), // Çizginin rengi ve kalınlığı
                    insets: EdgeInsets.symmetric(horizontal: 90), // Çizginin genişliğini ayarlamak için
                  ),
                  labelColor: Color(0xFF97349e), // Aktif tab yazı rengi
                  unselectedLabelColor: Color(0xFF964c9c), // Pasif tab yazı rengi
                  tabs: [
                    Tab(text: "Gelir"),
                    Tab(text: "Gider"),
                  ],
                ),
              ),
              // Tab İçerikleri
              Expanded(
                child: TabBarView(
                  children: [
                    // Gelir Tab içeriği
                    ListView(
                      children: [
                        BudgetLineChart(data: chartIncomeData, income: true,),
                        const Text("  İşlem Geçmişi:", style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,)),
                        SizedBox(height: 5,),
                        ...formattedIncomeData.map((item){
                          return CustomAnalysisCard(title: item["name"], amount: "${item["amount"]}", date: item["date"], showDate: true,);
                          }).toList(),
                        // Diğer kartları buraya ekleyebilirsiniz
                      ],
                    ),
                    // Gider Tab içeriği
                    ListView(
                      children: [
                        BudgetLineChart(data: chartExpenseData,),
                        const Text("  İşlem Geçmişi:", style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,)),
                        SizedBox(height: 5,),
                        ...formattedExpenseData.map((item){
                          return CustomAnalysisCard(title: item["name"], amount: "${item["amount"]}", date: item["date"], showDate: true, income: false,);
                        }).toList(),
                        // Diğer kartları buraya ekleyebilirsiniz
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: CustomFAB(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(onSave: () {
                  setState(() {

                    fetchIncomeData();
                    fetchExpenseData();

                  });
                });
              },
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
        ),
      ),
    );
  }
}
