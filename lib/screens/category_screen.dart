import 'package:budgy/api/CategoryService.dart';
import 'package:budgy/components/categoryPieChart.dart';
import 'package:flutter/material.dart';
import '../api/UserService.dart';
import '../api/token_storage.dart';
import '../components/customAnalysisCard.dart';
import '../components/customBottomNavBar.dart';
import '../components/customDialog.dart';
import '../components/customFab.dart';
import 'login_screen.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int _currentIndex = 2;

  String? userName;
  List<Map<String, dynamic>> incomeData = [];
  List<Map<String, dynamic>> expenseData = [];


  final exp_colors = [
    Color(0xFFbaefbf),//kira
    Color(0xFF36a7f7),
    Color(0xffd26259),
    Color(0xffb7b16b),
    Color(0xffc4277c),
    Color(0xFFf6a3ab),
    Color(0xff005751),
    Color(0xff76a5af),
    Color(0xffd6bfa7),
    Color(0xff7833dc),
  ];



  final in_colors = [
    Color(0xFFbaefbf),
    Color(0xFF9c9dfb),
    Color(0xFFf49ae9),
    Color(0xFF20c4d8),
    Color(0xFFf1df76),
  ];

  void initState() {
    super.initState();
    _checkLoginStatus();
    fetchUserName();
    fetchIncomeData();
    fetchExpenseData();
  }

  Future<void> fetchIncomeData() async{
    final data = await CategoryService.getIncomeData();

    setState(() {
      incomeData = data;
    });
  }

  Future<void> fetchExpenseData() async{
    final data = await CategoryService.getExpenseData();

    setState(() {
      expenseData = data;
    });
  }

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
    List<Map<String,dynamic>> monthExpMap = [];
    List<Map<String,dynamic>> monthInMap = [];

    final category_expense = expenseData.map((item){
      return item["name"];
    }).toList();
    final expenses = expenseData.map((item){
      return item["totalAmount"];
    }).toList();

    final category_income = incomeData.map((item){
      return item["name"];
    }).toList();
    final incomes = incomeData.map((item){
      return item["totalAmount"];
    }).toList();

    for(int i=0;i<category_expense.length;i++){
      monthExpMap.add({"category":category_expense[i],"expense":expenses[i],"color":exp_colors[i]});
    }

    for(int i=0;i<category_income.length;i++){
      monthInMap.add({"category":category_income[i],"income":incomes[i],"color":in_colors[i]});
    }

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
                        CategoryPieChart(data: monthInMap, income: true,),
                        const Text("  İşlem Geçmişi:", style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,)),
                        SizedBox(height: 5,),
                        ...incomeData.map((item){
                          return CustomAnalysisCard(title: item["name"], amount: "${item["totalAmount"]}", showDate: false,);
                        }).toList()
                        // Diğer kartları buraya ekleyebilirsiniz
                      ],
                    ),
                    // Gider Tab içeriği
                    ListView(
                      children: [
                        CategoryPieChart(data: monthExpMap),
                        const Text("  İşlem Geçmişi:", style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,)),
                        SizedBox(height: 5,),
                        ...expenseData.map((item){
                          return CustomAnalysisCard(title: item["name"] , amount: "${item["totalAmount"]}",showDate: false, income: false,);
                        }).toList()
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
                    _checkLoginStatus();
                    fetchUserName();
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
