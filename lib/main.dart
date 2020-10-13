import 'dart:collection';

import 'package:HackerNewsApp/bloc/hackerNews_Bloc.dart';
import 'package:HackerNewsApp/modals/Article.dart';
import 'package:HackerNewsApp/services/GetArticle%5BAPI%20calls%5D.dart';
import 'package:flutter/material.dart';

void main() {
  final hnBloc = HackerNewsBloc();
  runApp(MyApp(
    bloc: hnBloc,
  ));
}

class MyApp extends StatelessWidget {
  final HackerNewsBloc bloc;
  MyApp({Key key, this.bloc});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'Hacker Earth News',
        bloc: bloc,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final HackerNewsBloc bloc;
  MyHomePage({Key key, this.title, this.bloc}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var indxces;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<UnmodifiableListView<Articles>>(
          stream: widget.bloc.articles,
          initialData: UnmodifiableListView<Articles>([]),
          builder: (context, snapshot) {
            return ListView(
              children: snapshot.data.map(_buildItem).toList(),
            );
          }),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {
            if (index == 0) {
              widget.bloc.storiesType.add(StoriesType.topStories);
            } else {
              widget.bloc.storiesType.add(StoriesType.newStories);
            }
          },
          items: [
            BottomNavigationBarItem(
                title: Text("Top Stories"), icon: Icon(Icons.arrow_drop_up)),
            BottomNavigationBarItem(
                title: Text("New Stories"), icon: Icon(Icons.new_releases)),
          ]),
    );
  }
}

Widget _buildItem(Articles articles) {
  return ExpansionTile(
    title: Text("${articles.title}"),
    children: [
      Row(
        children: [
          Text("comments"),
          IconButton(icon: Icon(Icons.launch), onPressed: () {}),
        ],
      )
    ],
  );
}
