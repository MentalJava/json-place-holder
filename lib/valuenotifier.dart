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
    model.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HttpSampleScreen'),
      ),
      body: Center(
        child: ListenableBuilder(
          listenable: model,
          builder: (context, child) {
            return Text('${model.value.body}, ${model.value.title}');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
    );
  }
}

// Model (상태 & 로직)
class HttpSampleModel extends ValueNotifier<HttpSampleState> {
// State
  HttpSampleModel() : super(HttpSampleState()) {
    fetchData();
  }

  Future<String> _getData() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
    final response = await http.get(url);
    print(response.body);
    return response.body;
  }

  void fetchData() async {
    final jsonString = await _getData();

    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;

    //상태변경

    value = value.copyWith(
      body: jsonMap['body'],
      title: jsonMap['title'],
    );

    //외부에 알리기
    notifyListeners();
  }
}

class HttpSampleState {
  final String body;
  final String title;

  HttpSampleState({
    this.title = '',
    this.body = 'Loading',
  });

  HttpSampleState copyWith({
    final String? title,
    final String? body,
  }) {
    return HttpSampleState(
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
}