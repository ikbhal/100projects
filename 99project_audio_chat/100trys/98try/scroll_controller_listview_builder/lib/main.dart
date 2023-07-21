import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String title ='';

  final ScrollController _scrollController = ScrollController();
  
  @override
  Widget build(BuildContext context) {

    _scrollController.addListener(() {
      print('ScrollController: ${_scrollController.offset}');
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('ScrollController Test'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            color: index % 2 == 0 ? Colors.green : Colors.yellow,
            height: 150,
            child: Text(
              'Item $index',
              style: Theme.of(context).textTheme.headline5,
            ),
          );
        },
      )
    );
  }

}

