import 'dart:async';
import 'dart:convert';
import 'package:newsapp/model/article_model.dart';
import 'package:http/http.dart' as http;

class News {
  List<Article> news = [];

  String url =
      "https://newsapi.org/v2/top-headlines?country=in&apiKey=8edf995eaca14ea39427558a5323ffb5";

  Future<void> getNews() async {
    var response = await http.get(url); //saves the url
    var jsonData = jsonDecode(response.body); //decodes jsonData

    if (jsonData["status"] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          Article article = Article(
            title: element["title"],
            description: element["description"],
            urlToImg: element["urlToImage"],
            publishedAt: DateTime.parse(element['publishedAt']),
            content: element["content"],
            url: element["url"],
            source: element["source"]["name"],
          );

          news.add(article);
        }
      });
    }
  }
}

//Category wise news
class CategoryNews {
  List<Article> news = [];

  Future<void> getCategorie(String getCategory) async {
    String url =
        "https://newsapi.org/v2/top-headlines?category=$getCategory&country=in&apiKey=8edf995eaca14ea39427558a5323ffb5";
    var response = await http.get(url); //saves the url
    var jsonData = jsonDecode(response.body); //decodes jsonData

    if (jsonData["status"] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          Article article = Article(
            title: element["title"],
            description: element["description"],
            urlToImg: element["urlToImage"],
            publishedAt: DateTime.parse(element['publishedAt']),
            content: element["content"],
            url: element["url"],
            source: element["source"]["name"],
          );
          news.add(article);
        }
      });
    }
  }
}