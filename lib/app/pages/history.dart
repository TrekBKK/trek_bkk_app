import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class History extends StatelessWidget {
  static String routeName = '/History';
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    print(ModalRoute.of(context)?.settings.name);
    return Scaffold(
      appBar: AppBar(
        title: Text('history page'),
      ),
    );
  }
}
