import 'package:HackerNewsApp/modals/Article.dart';
import 'package:http/http.dart' as http;

Future<Articles> getArticle(int id) async {
  print("done2");
  final storyUrl =
      "https://hacker-news.firebaseio.com/v0/item/${id}.json?print=pretty";
  final response = await http.get(storyUrl);
  print("done3");
  if (response.statusCode == 200) {
    return articlesFromJson(response.body);
  }
  print("done4");
}

// Future<Articles> updateArticle(int id) async {
//   final storyUrl =
//       "https://hacker-news.firebaseio.com/v0/item/${id}.json?print=pretty";
//   final response = await http.get(storyUrl);
//   if (response.statusCode == 200) {
//     return articlesFromJson(response.body);
//   }
// }
