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

// Screen (UI)
class HttpSampleScreen extends StatefulWidget {
  const HttpSampleScreen({super.key});

  @override
  State<HttpSampleScreen> createState() => _HttpSampleScreenState();
}

class _HttpSampleScreenState extends State<HttpSampleScreen> {
  final model = HttpSampleModel();
  @override
  void initState() {
    super.initState();

    model.getUiData().whenComplete(
          () => setState(() {}),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HttpSampleScreen'),
      ),
      body: Center(
        child: Text('${model.body}, ${model.title}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
    );
  }
}

// Model (상태 & 로직)
class HttpSampleModel {
// State
  String _body = "Loading";
  String _title = '';

  String get title => _title;
  String get body => _body;

  Future<String> _getData() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
    final response = await http.get(url);
    print(response.body);
    return response.body;
  }

  Future<void> getUiData() async {
    final jsonString = await _getData();

    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;

    _body = jsonMap['body'];
    _title = jsonMap['title'];
  }
}
