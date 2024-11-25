import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const ProviderScope(child: MyApp()));
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
class HttpSampleScreen extends ConsumerWidget {
  const HttpSampleScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(modelNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('HttpSampleScreen'),
      ),
      body: Center(
        child: Text('${state.body}, ${state.title}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(modelNotifierProvider.notifier).fetchData();
        },
      ),
    );
  }
}

// Model (상태 & 로직)
class HttpSampleModel extends Notifier<HttpSampleState> {
// State
  @override
  HttpSampleState build() => HttpSampleState();

  HttpSampleModel() {
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

    state = state.copyWith(
      body: jsonMap['body'],
      title: jsonMap['title'],
    );
  }
}

final modelNotifierProvider =
    NotifierProvider<HttpSampleModel, HttpSampleState>(HttpSampleModel.new);

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
