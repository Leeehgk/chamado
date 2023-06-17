import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:chamados/main.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;



  Future<bool> _checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void _signInWithEmailAndPassword() async {
    bool isConnected = await _checkInternetConnectivity();

    if (!isConnected) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro de Conexão'),
          content: Text('Por favor, verifique sua conexão com a internet.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text;

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(),
          ),
        );
      }
    } catch (e) {
      print('Erro no login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.message),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor insira um E-mail';
                }
                // adicione a expressão regular para permitir o ponto
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: Icon(Icons.key),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Senha Incorreta ou Usuario Não Existe !';
                }
                return null;
              },
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signInWithEmailAndPassword,
              child: Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}