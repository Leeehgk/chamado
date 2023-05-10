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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Chamados'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              PersonForm(),
              const Divider(),
              Expanded(child: PersonList()),
            ],
          ),
        ),
      ),
    );
  }
}

