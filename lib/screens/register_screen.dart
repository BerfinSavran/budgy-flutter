import 'package:flutter/material.dart';
import '../api/AuthService.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isButtonClicked = false;

  Future<void> _register() async {
    setState(() {
      _isButtonClicked = true;
    });

    final authService = AuthService();
    // Register fonksiyonu bool döndürecek
    final bool success = await authService.register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isButtonClicked = false;
    });

    if (success) {
      // Kayıt başarılıysa login sayfasına yönlendir
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration Successful')));
      Navigator.pop(context);  // Login sayfasına yönlendirme
    } else {
      // Kayıt başarısızsa hata mesajı göster
      _showErrorDialog("Kayıt işlemi başarısız oldu.");
    }
  }


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Hata"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dialog kapatılır
            },
            child: Text("Tamam"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Budgy",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w400,
                color: Color(0xFF97349e),
              ),
            ),
            const SizedBox(height: 50),
             TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Ad Soyad",
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF97349e), width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF97349e), width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "E-mail",
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF97349e), width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF97349e), width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
             TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Şifre",
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF97349e), width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF97349e), width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text("Kayıt Ol"),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isButtonClicked ? Color(0xFF97349e).withOpacity(0.5) : null,
                foregroundColor: _isButtonClicked ? Colors.white : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
