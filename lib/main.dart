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
      home: const MyHomePage(title: 'Pesquisar'),
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
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
              child: TextField(
                controller: _controllerId,
                decoration: InputDecoration(
                  hintText: 'Buscar usuário por ID',
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _fetchUser, child: const Text('Buscar')),
            const SizedBox(height: 40),

            if (errorMessage != null) Text(errorMessage!),

            if (userData != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 52,
                  vertical: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(userData!['avatar']),
                      radius: 44,
                    ),
                    const SizedBox(width: 20),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${userData!['first_name']} ${userData!['last_name']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userData!['email'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
