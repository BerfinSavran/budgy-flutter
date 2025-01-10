import 'package:budgy/api/GoalService.dart';
import 'package:budgy/api/IncomeExpenseService.dart';
import 'package:budgy/components/customHomeCard.dart';
import 'package:flutter/material.dart';
import '../api/UserService.dart';
import '../api/token_storage.dart';
import '../components/customBottomNavBar.dart';
import '../components/customDialog.dart';
import '../components/customFab.dart';
import '../components/incomeExpenseChart.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  String? userName;

  final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  late Future<List<Map<dynamic,dynamic>>> _monthlyTotalExpenseFuture;
  late Future<int> _monthlyPlannedBudget;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _monthlyTotalExpenseFuture = IncomeExpenseService.getMonthlyTotals();
    _monthlyPlannedBudget = GoalService.MonthlyPlannedBudget();
    fetchUserName();
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
    List<Map<String, dynamic>> monthInExpMap = [];
    int stateCounter = 0;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Map<dynamic,dynamic>>>(
          future: _monthlyTotalExpenseFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Hata oluştu: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              final monthlyTotalExpense = snapshot.data!;
              var totalAmount = "0";
              var income = 0;
              var expense = 0;

              if (monthlyTotalExpense.length != 0){
                totalAmount = (monthlyTotalExpense[monthlyTotalExpense.length -1]["totalIncome"] - monthlyTotalExpense[monthlyTotalExpense.length -1]["totalExpense"]).toString();
                income = monthlyTotalExpense[monthlyTotalExpense.length -1]["totalIncome"];
                expense = monthlyTotalExpense[monthlyTotalExpense.length -1]["totalExpense"];

              }


              for (int i = 0; i < monthlyTotalExpense.length; i++) {

                var monthI = monthlyTotalExpense[i]["month"] -1;
                print(monthI);
                monthInExpMap.add({
                  "month": months[monthI],
                  "income": monthlyTotalExpense[i]["totalIncome"],
                  "expense": monthlyTotalExpense[i]["totalExpense"],
                });
              }

              return ListView(
                children: [
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
                  CustomHomeCard(
                    title: "Mevcut Bakiye",
                    amount: totalAmount,
                    width: 400,
                    height: 210,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomHomeCard(
                            title: "Gelir",
                            amount: income.toString(),
                            height: 101,
                            width: 150,
                          ),
                          CustomHomeCard(
                            title: "Gider",
                            amount: expense.toString(),
                            height: 101,
                            width: 150,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: FutureBuilder<int>(
                      future: _monthlyPlannedBudget,
                      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                        if (snapshot.connectionState == ConnectionState
                            .waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text("Hata oluştu: ${snapshot.error}"));
                        } else if (snapshot.hasData) {
                          int result = snapshot.requireData;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CustomHomeCard(
                                title: "Planlanan Bütçe",
                                amount: result.toString(),
                                height: 101,
                                width: 195,
                              ),
                              CustomHomeCard(
                                title: "Kalan Bütçe",
                                amount: (result - expense).toString(),
                                height: 101,
                                width: 195,
                              ),
                            ],
                          );
                        } else {
                          return Center(child: Text("Veri bulunamadı."));
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFf3ebf5),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Bütçe Harcama Durumu",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        FutureBuilder<int>(
                          future: _monthlyPlannedBudget,
                          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text("Hata oluştu: ${snapshot.error}"));
                            } else if (snapshot.hasData) {
                              int plannedBudget = snapshot.requireData;
                              int usedBudget = (plannedBudget - expense);
                              double perc = plannedBudget > 0
                                  ? 1 - (usedBudget / plannedBudget)
                                  : 0.0; // Planlanan bütçe sıfırsa %0 harcama göster

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      FractionallySizedBox(
                                        widthFactor: perc.clamp(0.0, 1.0), // %0 ile %100 arasında sınırlama
                                        child: Container(
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF97349e),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "%${(perc * 100).toStringAsFixed(1)} Harcandı", // Yüzdeliği göster
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Center(child: Text("Veri bulunamadı."));
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  Container(
                    child: MonthlyIncomeExpenseChart(data: monthInExpMap),
                  ),
                ],
              );
            } else {
              return Center(child: Text("Veri bulunamadı."));
            }
          },
        ),
      ),
      floatingActionButton: CustomFAB(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog(onSave: () {
                setState(() {
                  _monthlyTotalExpenseFuture = IncomeExpenseService.getMonthlyTotals();
                  _monthlyPlannedBudget = GoalService.MonthlyPlannedBudget();
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
    );
  }
}