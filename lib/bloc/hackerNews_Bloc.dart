import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:HackerNewsApp/modals/Article.dart';
import 'package:HackerNewsApp/services/GetArticle%5BAPI%20calls%5D.dart';
import 'dart:collection';

enum StoriesType { topStories, newStories }

class HackerNewsBloc {
// TODO: [1st]  first setup with stream controller
  final _storiesTypeController = StreamController<StoriesType>();
  final _isLoadingSubject = StreamController<bool>();
  final _articlesSubject = StreamController<UnmodifiableListView<Articles>>();
// other variables

  var _articles = <Articles>[];

//TODO: [2nd] stresm sink getter
  Stream<bool> get outputisLoading => _isLoadingSubject.stream;
  Stream<UnmodifiableListView<Articles>> get outputarticles =>
      _articlesSubject.stream;
  Sink<StoriesType> get inputstoriesType => _storiesTypeController.sink;

  // var topids = [
  //   24761714,
  //   24762971,
  //   24762612,
  //   24763120,
  //   24758772,
  //   24759649,
  // ];

  // var newIds = [
  //   24762554,
  //   24753626,
  //   24757333,
  //   24760271,
  //   24753642,
  //   24761105,
  // ];

// calling constructor
  HackerNewsBloc() {
    // _getArtcilesAndUpdate(topids);

    _storiesTypeController.stream.listen((storiesType) async {
      _getArtcilesAndUpdate(await _getIds(storiesType));
    });

    // _storiesTypeController.stream.listen((storiesType) {
    //   if (storiesType == StoriesType.newStories) {
    //     print("new stories");
    //     _getArtcilesAndUpdate(newIds);
    //   } else {
    //     print("top stories");
    //     _getArtcilesAndUpdate(topids);
    //   }
    // });
  }

  Future<List<dynamic>> _getIds(StoriesType type) async {
    final partUrl = type == StoriesType.topStories ? 'top' : 'new';
    print("partUrl: $partUrl");
    final url = "https://hacker-news.firebaseio.com/v0/${partUrl}stories.json";
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw HackerNewsApiError("Stories coudn't be fetched");
    }
    // print(response.body.runtimeType);
    List<dynamic> iids = json.decode(response.body);
    print(iids.take(10).toList());
    print(iids.take(10).toList().runtimeType);
    return iids.take(10).toList();
  }

  _getArtcilesAndUpdate(List<dynamic> idss) async {
    _isLoadingSubject.add(true);
    await _updateArticles(idss)
        .then((_) => {_articlesSubject.add(UnmodifiableListView(_articles))});
    _isLoadingSubject.add(false);
  }

  Future<Null> _updateArticles(List<dynamic> articlesIds) async {
    print("articlesIds $articlesIds");
    print("done1");
    final futureArticles = articlesIds.map((e) => getArticle(e)).toList();
    print("done5");
    final articles = await Future.wait(futureArticles);
    print("done6");
    _articles = articles;
  }

  void close() {
    _storiesTypeController.close();
  }
}

class HackerNewsApiError extends Error {
  final String message;
  HackerNewsApiError(this.message);
}
