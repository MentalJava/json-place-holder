import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final model = HttpSampleModel();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider<HttpSampleModel>(
        create: (_) {
          return HttpSampleModel();
        },
        child: const HttpSampleScreen(),
      ),
    );
  }
}

// Screen (UI)
class HttpSampleScreen extends StatelessWidget {
  const HttpSampleScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HttpSampleScreen'),
      ),
      body: Center(
        child: BlocBuilder<HttpSampleModel, HttpSampleState>(
          builder: (context, state) {
            return Text('${state.body}, ${state.title}');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<HttpSampleModel>().fetchData();
        },
      ),
    );
  }
}

// Model (상태 & 로직)
class HttpSampleModel extends Cubit<HttpSampleState> {
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

    emit(
      state.copyWith(
        body: jsonMap['body'],
        title: jsonMap['title'],
      ),
    );
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
