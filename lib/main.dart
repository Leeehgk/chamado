import 'package:chamados/Home_Screen/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chamados/firebase_options.dart';
import 'package:chamados/Home_Screen/Home_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    title: 'Login Page',
    home: LoginPage(),
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
        length: 3, // número de tabs
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Chamados'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                  );
                },
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home), text: 'Home'),
                Tab(icon: Icon(Icons.note), text: 'Chamados'),
                Tab(icon: Icon(Icons.assignment), text: 'Chat'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              // conteúdo da primeira tab
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: PersonForm(),
                    ),
                  ],
                ),
              ),
              // conteúdo da segunda tab
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: PersonList(),
                    ),
                  ],
                ),
              ),
              // conteúdo da terceira tab
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: PersonList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}