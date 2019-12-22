import 'package:flutter/material.dart';

const int _PAGE_SIZE = 20;

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
  List<String> _list = [];
  int _currentMax = _PAGE_SIZE;

  GlobalKey<RefreshIndicatorState> _refreshKey;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _refreshKey = GlobalKey<RefreshIndicatorState>();

    _list = List.generate(_PAGE_SIZE, (int index) => 'Item: ${index + 1}');

    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          getMoreData();
        }
      },
    );

    super.initState();
  }

  Future<void> _getList() async {
    await Future.delayed(
      Duration(seconds: 3),
    );

    _list = List.generate(_PAGE_SIZE, (int index) => 'Item: ${index + 1}');

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _list.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == _list.length) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return ListTile(
              title: Text(_list[index]),
            );
          },
        ),
        onRefresh: () async => await _getList(),
      ),
    );
  }

  Future<void> getMoreData() async {
    await Future.delayed(
      Duration(seconds: 3),
    );

    for (int i = _currentMax; i < _currentMax + _PAGE_SIZE; i++) {
      _list.add('Item: ${i + 1}');
    }

    _currentMax += _PAGE_SIZE;

    setState(() {});
  }
}
