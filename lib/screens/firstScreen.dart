import 'package:flutter/material.dart';

import 'package:newsapp/screens/exploreScreen.dart';
import 'package:newsapp/screens/homeScreen.dart';
import 'package:newsapp/screens/savedScreen.dart';
import 'package:newsapp/screens/userDetails.dart';

class FirstScreen extends StatefulWidget {
  FirstScreen({Key key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    HomeScreen(
      key: PageStorageKey('Page 1'),
    ),
    ExploreScreen(
        key: PageStorageKey('Page 2'),
    ),
    SavedScreen(
      key : PageStorageKey('Page 3'),
    ),
    UserDetails(
      key : PageStorageKey('Page 3'),
    )

  ];

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Icon(Icons.tab_outlined,color: Colors.white),
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 75.0),
                child: Text(
                  "Newzzzz",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Text(
                "App",
                style: TextStyle(color: Colors.blue),
              )
            ],
          ),
        ),
      
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orange,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.view_headline, color: Colors.black, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore, color: Colors.black, size: 30),
              label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark, color: Colors.black, size: 30),
              label: 'Saved Post'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, color: Colors.black, size: 30),
              label: 'Account'),
        ],
        onTap: (index) {
          if (mounted) {
            setState(() {
              selectedIndex = index;
            });
          }
        },
        currentIndex: selectedIndex,
      ),
      body: PageStorage(bucket: bucket, child: pages[selectedIndex]),
    );
  }
}
