import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'pages/login/login_page.dart';
import 'package:work_together_flutter/pages/group_search/group_search_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

int loggedUserId = 2;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'SourceSansPro'),
      home: const LoginPage(),
    );
  }
}
