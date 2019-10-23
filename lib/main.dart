import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_loadmore/bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        '/screen1': (BuildContext context) => HomePage(),
        '/screen2': (BuildContext context) =>
            MyHomePage(title: 'Flutter Demo Home Page'),
      },
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Container(
        child: Center(
          child: RaisedButton(
            child: Text('Click me!'),
            onPressed: () {
              Navigator.of(context).pushNamed('/screen2');
            },
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Bloc _bloc;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _bloc = Bloc();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      print(
          'dkm ${_scrollController.position.pixels} - ${_scrollController.position.maxScrollExtent}');
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('load more ne');
        _bloc.loadData(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<Model>(
                  stream: _bloc.mainStream,
                  builder: (context, snapshot) {
                    final model = snapshot.data;
                    int childCount = _bloc.getChildCount();
                    if (childCount == 0) {
                      return Container(
                        alignment: Alignment.topCenter,
                        child: Text('Không có dữ liệu'),
                      );
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: childCount,
                      itemBuilder: (context, index) {
                        if (model == null) {
                          return ItemLoading();
                        }
                        if (index >= model.listItem.length)
                          return ItemLoading();
                        return Item(title: 'hihihihi $index');
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          _bloc.loadData(true, numOfItem: 3);
        },
      ),
    );
  }
}

class Item extends StatelessWidget {
  final String title;

  Item({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      color: Colors.white,
      margin: EdgeInsets.all(4),
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            color: Color.fromARGB(255, Random().nextInt(255),
                Random().nextInt(255), Random().nextInt(255)),
            child: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Center(
                child: Text(title),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      color: Colors.white,
      margin: EdgeInsets.all(4),
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            color: Colors.grey[200],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Center(
                child: Container(
                  height: 10,
                  width: 200,
                  color: Colors.grey[200],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
