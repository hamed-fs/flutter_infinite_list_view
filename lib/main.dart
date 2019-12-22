import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _pageSize = 10;

  int _currentMax = 10;
  List<String> _list;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _list = List.generate(_pageSize, (int index) => 'Item: ${index + 1}');

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMoreData();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _list.length + 1,
        itemExtent: 80.0,
        itemBuilder: (BuildContext context, int index) {
          if (index == _list.length) {
            return JumpingDotsProgressIndicator(
              color: Theme.of(context).accentColor,
              fontSize: 48.0,
            );
          }

          return ListTile(
            title: Text(_list[index]),
          );
        },
      ),
    );
  }

  Future<void> getMoreData() async {
    await Future.delayed(
      Duration(seconds: 3),
    );

    for (int i = _currentMax; i < _currentMax + _pageSize; i++) {
      _list.add('Item: ${i + 1}');
    }

    _currentMax += _pageSize;

    setState(() {});
  }
}
