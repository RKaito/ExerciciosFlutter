import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controllerId = new TextEditingController();
  Map<String, dynamic>? userData;
  String? errorMessage;

  Future<void> _fetchUser() async {
    final id = _controllerId.text.trim();

    if (id.isEmpty) {
      setState(() {
        errorMessage = 'Insira um ID de usuário por obséquio';
        userData = null;
      });
      return;
    }
    final url = Uri.parse('https://reqres.in/api/users/$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        setState(() {
          userData = body['data'];
          errorMessage = null;
        });
      } else {
        setState(() {
          userData = null;
          errorMessage = 'usuário não encontrado';
        });
      }
    } catch (e) {
      setState(() {
        userData = null;
        errorMessage = 'erro em request realizada';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _controllerId,
              decoration: InputDecoration(labelText: 'Insira Id de usuário'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _fetchUser, child: const Text('Buscar')),
            const SizedBox(height: 40),
            if (errorMessage != null) Text(errorMessage!),
            if (userData != null) ...[
              Image.network(userData!['avatar']),
              Text('${userData!['first_name']} ${userData!['last_name']}'),
              Text(userData!['email']),
            ],
          ],
        ),
      ),
    );
  }
}

// Campos do response exemplo:
// [{"id":1,
// "email":"george.bluth@reqres.in",
// "first_name":"George",
// "last_name":"Bluth",
// "avatar":"https://reqres.in/img/faces/1-image.jpg"},
