import 'package:HackerNewsApp/modals/Article.dart';
import 'package:HackerNewsApp/services/GetArticle%5BAPI%20calls%5D.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:collection';

class HackerNewsBloc {
  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Articles>>();
  var _articles = <Articles>[];

  var ids = [
    24761714,
    24762971,
    24762612,
    24763120,
    24758772,
    24759649,
    24762554,
    24753626,
    24757333,
    24760271,
    24753642,
    24761105,
  ];

  HackerNewsBloc() {
    _updateArticles()
        .then((_) => {_articlesSubject.add(UnmodifiableListView(_articles))});
  }
  Stream<UnmodifiableListView<Articles>> get articles =>
      _articlesSubject.stream;

  Future<Null> _updateArticles() async {
    final futureArticles = ids.map((e) => getArticle(e));
    final articles = await Future.wait(futureArticles);
    _articles = articles;
  }
}
