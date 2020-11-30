import 'package:flutter/material.dart';
import 'package:newsapp/helper/news.dart';
//import 'package:newsapp/models/articles_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool waiting = true;
  var articles;
  @override
  void initState() {
    super.initState();
    // print('init state');
    getNews();
  }

  @override
  void dispose() {
    super.dispose();
    //  print('dispose state');
  }

  getNews() async {
    News newsInstance = News();
    await newsInstance.getNews();
    articles = newsInstance.news;
    setState(() {
      waiting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
        body: (waiting)
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: articles.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Card(
                      elevation: 1.25,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  timeago.format(DateTime.parse(
                                      articles[index].publishedAt
                                      .toString())),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[600])),
                            ),
                              
                               Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    articles[index].source,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.indigo[400],
                                        fontSize: 15)),
                               )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            (articles[index].title == null)
                                                ? "Loading..."
                                                : articles[index].title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: Text(
                                            (articles[index].description ==
                                                    null)
                                                ? "Loading..."
                                                : articles[index].description,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
                                          ),
                                        )
                                      ]),
                                ),
                                Column(children: [
                                  SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: CachedNetworkImage(
                                        imageUrl: articles[index].urlToImg,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        fit: BoxFit.cover,
                                      )),
                                  Row(children: [
                                    Icon(Icons.share),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16.0),
                                      child: Icon(Icons.bookmark),
                                    ),
                                    Icon(Icons.block)
                                  ])
                                ])
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  );
                }));
  }
}
