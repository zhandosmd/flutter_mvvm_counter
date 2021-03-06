import 'package:flutter/material.dart';
import 'package:flutter_mvvm_counter/ui/widgets/auth_widget.dart';
import 'package:flutter_mvvm_counter/ui/widgets/example_widget.dart';
import 'package:flutter_mvvm_counter/ui/widgets/loader_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoaderWidget.create(),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == 'auth') {
          return PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                AuthWidget.create(),
            transitionDuration: Duration.zero,
          );
        } else if (settings.name == 'example') {
          return PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                ExampleWidget.create(),
            transitionDuration: Duration.zero,
          );
        } else if (settings.name == 'loader') {
          return PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                LoaderWidget.create(),
            transitionDuration: Duration.zero,
          );
        }
      },
    );
  }
}
