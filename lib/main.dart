import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'file:///E:/flutter/udemy_flutter/lib/modules/login/login_screen.dart';
import 'package:udemy_flutter/layout/todo_layout.dart';
import 'package:udemy_flutter/shared/bloc_observer.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: HomeLayout(),
    );
  }
}
