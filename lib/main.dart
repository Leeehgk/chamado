import 'package:chamados/HomeScreen/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chamados/firebase_options.dart';
import 'package:chamados/HomeScreen/HomeScreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
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
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home), text: 'Home'),
                Tab(icon: Icon(Icons.note), text: 'Chamados'),
                Tab(icon: Icon(Icons.assignment), text: 'Chat'),
              ],
            ),
          ),
          body: TabBarView(
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