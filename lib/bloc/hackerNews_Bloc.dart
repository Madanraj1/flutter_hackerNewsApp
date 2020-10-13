import 'dart:async';

import 'package:HackerNewsApp/modals/Article.dart';
import 'package:HackerNewsApp/services/GetArticle%5BAPI%20calls%5D.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:collection';

enum StoriesType { topStories, newStories }

class HackerNewsBloc {
  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Articles>>();
  var _articles = <Articles>[];

  Sink<StoriesType> get storiesType => _storiesTypeController.sink;
  final _storiesTypeController = StreamController<StoriesType>();

  var topids = [
    24761714,
    24762971,
    24762612,
    24763120,
    24758772,
    24759649,
  ];

  var newIds = [
    24762554,
    24753626,
    24757333,
    24760271,
    24753642,
    24761105,
  ];

  HackerNewsBloc() {
    _getArtcilesAndUpdate(topids);

    _storiesTypeController.stream.listen((storiesType) {
      if (storiesType == StoriesType.newStories) {
        print("new stories");
        _getArtcilesAndUpdate(newIds);
      } else {
        print("top stories");
        _getArtcilesAndUpdate(topids);
      }
    });
  }

  _getArtcilesAndUpdate(List<int> idss) {
    _updateArticles(idss)
        .then((_) => {_articlesSubject.add(UnmodifiableListView(_articles))});
  }

  Stream<UnmodifiableListView<Articles>> get articles =>
      _articlesSubject.stream;

  Future<Null> _updateArticles(List<int> articlesIds) async {
    final futureArticles = articlesIds.map((e) => getArticle(e));
    final articles = await Future.wait(futureArticles);
    _articles = articles;
  }
}
