import 'package:budgy/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/UserService.dart';
import '../api/token_storage.dart';
import '../components/customBottomNavBar.dart';
import '../components/customDialog.dart';
import '../components/customFab.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 3;

  // Kullanıcı bilgilerini tutan değişkenler
  String fullName = "";
  String telNo = "";
  String email = "";
  String gender = "";

  // Düzenleme moduna geçiş için bir flag
  bool isEditing = false;

  // Form kontrolcüsü
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController telNoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Cinsiyet Enum Değerleri
  final Map<String, String> genderMap = {
    "0": "Erkek",
    "1": "Kadın",
    "Bilinmiyor":"Bilinmiyor"
  };
  String selectedGenderKey = ""; // Backend'den dönen enum key

  // Kullanıcı bilgilerini API'den yükle
  Future<void> loadUserData() async {
    try {
      final userData = await UserService.getUserData();

      if (userData != null) {
        setState(() {
          fullName = userData["fullName"] ?? "Bilinmiyor";
          telNo = userData["telNo"] ?? "Bilinmiyor";
          email = userData["email"] ?? "Bilinmiyor";
          if(userData["gender"] == null){
            gender =  "Bilinmiyor";
          }
          else{
            gender =  userData["gender"].toString();
          }
           // Backend enum key
          selectedGenderKey = gender;

          // TextField'lere başlangıç değerlerini atıyoruz
          fullNameController.text = fullName;
          telNoController.text = telNo;
          emailController.text = email;
        });
      }
    } catch (e) {
      print("Kullanıcı bilgileri yüklenirken hata: $e");
    }
  }

  // Kullanıcı bilgilerini kaydet
  void saveProfile() {
    setState(() {
      fullName = fullNameController.text;
      telNo = telNoController.text;
      email = emailController.text;
      gender = selectedGenderKey; // Backend'e enum key gönderilecek
      isEditing = false; // Düzenleme modunu kapat
    });


    if(selectedGenderKey == "Bilinmiyor"){
      print(telNo);
      UserService.updateUserData(fullName, telNo, email, null);
    }else{
      print(telNo);
      UserService.updateUserData(fullName, telNo, email,int.parse(selectedGenderKey));
    }

  }

  // Çıkış yap
  void logout() async {
    // Token'ı sil
    await TokenStorage.deleteToken();

    // Çıkış yaptıktan sonra login ekranına yönlendir
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // Login sayfasına yönlendirme
    );
  }

  @override
  void initState() {
    super.initState();
    loadUserData(); // Kullanıcı verilerini yükle
  }

  @override
  void dispose() {
    fullNameController.dispose();
    telNoController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
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
                  Text(
                    fullName.isEmpty ? "Yükleniyor..." : fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            // Profil Bilgileri
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // İsim
                  const Text("İsim: ", style: TextStyle(fontSize: 18)),
                  isEditing
                      ? CupertinoTextField(
                    controller: fullNameController,
                    placeholder: "İsim Soyisim",
                    textInputAction: TextInputAction.next,
                  )
                      : Text(fullName, style: const TextStyle(fontSize: 18)),
                  SizedBox(height: 10),

                  // Telefon No
                  const Text("Telefon: ", style: TextStyle(fontSize: 18)),
                  isEditing
                      ? CupertinoTextField(
                    controller: telNoController,
                    placeholder: "Telefon No:",
                    textInputAction: TextInputAction.next,
                  )
                      : Text(telNo, style: const TextStyle(fontSize: 18)),
                  SizedBox(height: 10),

                  // E-mail
                  const Text("E-mail: ", style: TextStyle(fontSize: 18)),
                  isEditing
                      ? CupertinoTextField(
                    controller: emailController,
                    placeholder: "E-mail",
                    textInputAction: TextInputAction.next,
                  )
                      : Text(email, style: const TextStyle(fontSize: 18)),
                  SizedBox(height: 10),

                  // Cinsiyet Seçimi
                  const Text("Cinsiyet: ", style: TextStyle(fontSize: 18)),
                  isEditing
                      ? DropdownButton<String>(
                    value: selectedGenderKey,
                    items: genderMap.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: (entry.key).toString(),
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGenderKey = newValue!;
                      });
                    },
                  )
                      : Text(
                    genderMap[gender]?? "Bilinmiyor",
                    style: const TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),

                  // Düzenle ve Çıkış Yap Butonları
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: isEditing
                            ? saveProfile
                            : () {
                          setState(() {
                            isEditing = true;
                          });
                        },
                        child: Text(isEditing ? "Kaydet" : "Düzenle"),
                      ),
                      ElevatedButton(
                        onPressed: logout,
                        child: const Text("Çıkış Yap"),
                      ),
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
                setState(() {});
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
