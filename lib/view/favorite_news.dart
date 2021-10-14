import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prerequisite_hackathon_app/view/home.dart';
import 'package:prerequisite_hackathon_app/view/news_search.dart';
import 'package:prerequisite_hackathon_app/view/profile.dart';
import 'package:prerequisite_hackathon_app/view/register.dart';

class FavoriteNews extends StatefulWidget {
  @override
  _FavoriteNewsState createState() => _FavoriteNewsState();
}

class _FavoriteNewsState extends State<FavoriteNews> {
  String _newstitle = "";

  @override
  void initState() {
    getNamePreference().then(updateNewstitle);
    super.initState();
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.of(context)
            .push(new MaterialPageRoute(builder: (context) => Home()));
        break;
      case 1:
        Navigator.of(context)
            .push(new MaterialPageRoute(builder: (context) => NewsSearch()));
        break;
      case 2:
        Navigator.of(context)
            .push(new MaterialPageRoute(builder: (context) => FavoriteNews()));
        break;
      case 3:
        Navigator.of(context)
            .push(new MaterialPageRoute(builder: (context) => Profile()));
        break;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text("Flutter News")],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person,
            ),
            onPressed: () {
              Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => Register()));
            },
          )
        ],
        centerTitle: true,
        elevation: 0.0,
      ),
      drawer: Drawer(),
      body: ListTile(
        title: Text(_newstitle),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Color(0xFF3B3D58),
            primaryColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: TextStyle(color: Colors.grey))),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_sharp),
              title: Text('Search'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              title: Text('Favorite'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              title: Text('More'),
            ),
          ],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void updateNewstitle(String? newstitle) {
    setState(() {
      this._newstitle = newstitle!;
    });
  }
}
