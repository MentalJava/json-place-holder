import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final model = HttpSampleModel();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HttpSampleModel());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HttpSampleScreen(),
    );
  }
}

// Screen (UI)
class HttpSampleScreen extends StatelessWidget {
  final HttpSampleModel model = Get.find();
  HttpSampleScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HttpSampleScreen'),
      ),
      body: Center(
        child: Obx(
          () => Text('${model.state.value.body}, ${model.state.value.title}'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          model.fetchData();
        },
      ),
    );
  }
}

// Model (상태 & 로직)
class HttpSampleModel extends GetxController {
// State
  var state = HttpSampleState().obs;

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

    state.value = state.value.copyWith(
      body: jsonMap['body'],
      title: jsonMap['title'],
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
