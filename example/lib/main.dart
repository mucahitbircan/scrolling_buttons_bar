import 'package:flutter/material.dart';
import 'package:scrolling_buttons_bar/scrolling_buttons_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Animated  Buttons Bar'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedItemIndex = -1;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double childHeight = MediaQuery.of(context).size.height / 20;
    double childWidth = MediaQuery.of(context).size.width / 5;
    double iconSize = childHeight * 0.8;
    var toolbarItems = [
      Icon(Icons.home, size: iconSize, color: Colors.red,),
      Icon(Icons.search, size: iconSize, color: Colors.blue,),
      Icon(Icons.notifications, size: iconSize, color: Colors.orange,),
      Icon(Icons.description, size: iconSize, color: Colors.indigoAccent,),
      Icon(Icons.image, size: iconSize, color: Colors.green,),
      Icon(Icons.opacity, size: iconSize, color: Colors.black),
      Icon(Icons.expand, size: iconSize, color: Colors.pinkAccent),
    ];
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(child: Container()),
      bottomNavigationBar: SafeArea(
        child: ScrollingButtonBar(
          selectedItemIndex: selectedItemIndex,
          scrollController: _scrollController,
          childWidth: childWidth,
          childHeight: childHeight,
          foregroundColor: const Color(0xffc7c7c7),
          radius: 6,
          animationDuration: const Duration(milliseconds: 333),
          children: [for (int i = 0; i < toolbarItems.length; i++) buildSingleItemInToolbar(i, toolbarItems)],
        ),
      ),
    );
  }

  buildSingleItemInToolbar(i, toolbarItems) {
    return ButtonsItem(
        child: toolbarItems[i],
        onTap: () {
          setState(() {
            selectedItemIndex = i;
          });
        });
  }
}
