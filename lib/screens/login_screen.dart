import 'package:flutter/material.dart';
import 'package:budgy/api/AuthService.dart';
import 'package:budgy/screens/home_screen.dart';
import 'package:budgy/screens/register_screen.dart';
import '../api/token_storage.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isButtonClicked = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Login işlemi
  Future<void> _login() async {
    setState(() {
      _isButtonClicked = true;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    // AuthService üzerinden backend'e login isteği gönderiyoruz
    final authService = AuthService();
    final token = await authService.login(email: email, password: password);

    setState(() {
      _isButtonClicked = false;
    });

    if (token != null) {
      // Token başarılı şekilde alındı, bunu flutter_secure_storage'ta saklıyoruz
      await TokenStorage.saveToken(token);

      // Giriş başarılıysa home screen'e yönlendirilir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // Hata durumu: Login başarısız
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed")));
    }
  }

  void _navigateRegister() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterScreen())
    );
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
              onPressed: _login,
              child: Text("Giriş Yap"),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isButtonClicked ? Color(0xFF97349e).withOpacity(0.5) : null,
                foregroundColor: _isButtonClicked ? Colors.white : null,
              ),
            ),
            TextButton(
              onPressed: _navigateRegister,
              child: const Text(
                "Kayıt Oluşturun",
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
