import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/services/crud.dart';
import 'package:newsapp/screens/webScreen.dart';

import 'package:share/share.dart';
class SavedScreen extends StatefulWidget {
  SavedScreen({Key key}) : super(key: key);

  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  CrudMethods crudMethods = CrudMethods();
  Stream newsStreams;
  bool waiting = false;
  Widget newsList() {
    return Container(
        child: Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("save").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data == null)
                  return Center(child: CircularProgressIndicator());
                return Container(
                  child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return NewsTile(
                          urlToImg:
                              snapshot.data.docs[index].data()['urlToImg'],
                          description:
                              snapshot.data.docs[index].data()['description'],
                          title: snapshot.data.docs[index].data()['title'],
                          source: snapshot.data.docs[index].data()['source'],
                          url: snapshot.data.docs[index].data()['url'],
                          content: snapshot.data.docs[index].data()['content']);
                    },
                  ),
                );
              },
            ),
          ),
        )
      ],
    ));
  }

  @override
  void initState() {
    crudMethods.getNewzzz().then((result) {
      newsStreams = result;
    });
    newsList();
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: newsList());
  }
}

class NewsTile extends StatefulWidget {
  final String urlToImg, description, title, source, url, content;
  NewsTile(
      {@required this.urlToImg,
      @required this.description,
      @required this.title,
      @required this.source,
      @required this.url,
      @required this.content});

  @override
  _NewsTileState createState() => _NewsTileState();
}

class _NewsTileState extends State<NewsTile> {
  CrudMethods _crudMethods = CrudMethods();

  _deleteArticle() {
    print("came here");
    FirebaseFirestore.instance
        .collection("save")
        .snapshots()
        .listen((snapshot) {
      snapshot.docs.forEach((doc) {
          if(widget.title == doc.data()['title']) {
            _crudMethods.deleteArticle(doc.id);
            print('Deleted');
          }
      });
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => WebScreen(data: widget.url)));
      },
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Card(
          elevation: 1.25,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.source,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text((widget.title == null) ? "Loading..." : widget.title,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Text(
                                (widget.description == null)
                                    ? "Loading..."
                                    : widget.description,
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
                            imageUrl: widget.urlToImg,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(children: [
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () async {
                              Share.share(widget.url,
                                  subject: 'Be updated with the latest news!!');
                            },
                          ),
                          SizedBox(height : 8),
                          IconButton(icon:Icon(Icons.delete_sweep),onPressed:(){ _deleteArticle();},)
                        ]),
                      )
                    ])
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}