import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HttpSampleScreen(),
    );
  }
}

class HttpSampleScreen extends StatefulWidget {
  const HttpSampleScreen({super.key});

  @override
  State<HttpSampleScreen> createState() => _HttpSampleScreenState();
}

class _HttpSampleScreenState extends State<HttpSampleScreen> {
  String body = "Loading";
  String title = '';

  Future<String> getData() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
    final response = await http.get(url);
    print(response.body);
    return response.body;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HttpSampleScreen'),
      ),
      body: Center(
        child: FutureBuilder<String>(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final String jsonString = snapshot.data!;
                final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;

                body = jsonMap['body'];
                title = jsonMap['title'];
              }
              return Text('$body, $title');
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
    );
  }
}
