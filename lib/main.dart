import 'dart:collection';
import 'package:HackerNewsApp/bloc/hackerNews_Bloc.dart';
import 'package:HackerNewsApp/modals/Article.dart';
import 'package:HackerNewsApp/services/GetArticle%5BAPI%20calls%5D.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
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
  var currentIndexs = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: LoadingInfo(widget.bloc.outputisLoading),
      ),
      body: StreamBuilder<UnmodifiableListView<Articles>>(
          stream: widget.bloc.outputarticles,
          initialData: UnmodifiableListView<Articles>([]),
          builder: (context, snapshot) {
            return ListView(
              children: snapshot.data.map(_buildItem).toList(),
            );
          }),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndexs,
          onTap: (index) {
            if (index == 0) {
              widget.bloc.inputstoriesType.add(StoriesType.topStories);
            } else {
              widget.bloc.inputstoriesType.add(StoriesType.newStories);
            }
            setState(() {
              currentIndexs = index;
            });
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

class LoadingInfo extends StatefulWidget {
  Stream<bool> _isLoading;
  LoadingInfo(this._isLoading);

  @override
  _LoadingInfoState createState() => _LoadingInfoState();
}

class _LoadingInfoState extends State<LoadingInfo>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget._isLoading,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          _controller.forward().then((value) => _controller.reverse());
          return FadeTransition(
            opacity: Tween(begin: .5, end: 1.0).animate(
                CurvedAnimation(curve: Curves.easeIn, parent: _controller)),
            child: Icon(
              FontAwesomeIcons.hackerNews,
              size: 30,
            ),
          );
        });
  }
}
