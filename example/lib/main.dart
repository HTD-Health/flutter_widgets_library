import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:widgets_library/widgets_library.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  RendererBinding.instance.setSemanticsEnabled(true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spring loader demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                print('text pressed');
              },
              child: const Text('TextButton'),
            ),
            FadeButton(
              onPressed: () {
                print('fade pressed');
              },
              child: const Text('FadeButton'),
            ),
          ],
        ),
      ),
    );
  }
}
