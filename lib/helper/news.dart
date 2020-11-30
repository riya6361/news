import 'dart:convert';
import 'package:newsapp/model/article_model.dart';

import 'package:http/http.dart' as http;

class News {
  List<Article> news=[];

  Future<void> getNews() async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=f9dac49a6b4a44b289b0d9f317f1f19a';

    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);

    if (jsonData["status"] == "ok") {
      jsonData["articles"].forEach((element) {
        if(element["urlToImage"]!=null && element["description"]!=null){
        Article article = Article(
          title: element["title"],
          description: element["description"],
          urlToImg: element["urlToImage"],
          content: element["content"],
          url: element["url"],
          publishedAt: DateTime.parse(element["publishedAt"]),
          source: element["source"]["name"],
        );
        news.add(article);
        }
      });
    }
  }
}
