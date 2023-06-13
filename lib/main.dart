import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chamados/firebase_options.dart';
import 'package:chamados/HomeScreen/HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
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
                padding:
                EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    PersonForm(),
                  ],
                ),
              ),
              // conteúdo da segunda tab
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: PersonList(),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: PersonList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}