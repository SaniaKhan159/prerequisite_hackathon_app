import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prerequisite_hackathon_app/helper/news.dart';

import 'package:prerequisite_hackathon_app/models/article_model.dart';
import 'package:prerequisite_hackathon_app/models/category_model.dart';
import 'package:prerequisite_hackathon_app/view/favorite_news.dart';
import 'package:prerequisite_hackathon_app/view/home.dart';
import 'package:prerequisite_hackathon_app/view/profile.dart';

class NewsSearch extends StatefulWidget {
  late String category;

  @override
  _NewsSearchState createState() => _NewsSearchState();
}

class _NewsSearchState extends State<NewsSearch> {
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
        title: Text('Search App'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              })
        ],
      ),
      drawer: Drawer(),
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
}

class DataSearch extends SearchDelegate<String> {
  List<ArticleModel> articles = [];

  final recentHistory = ["Business", "Entertainment", "General"];
  @override
  List<Widget>? buildActions(BuildContext context) {
    // actions for appbar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // leading icon on the left of the appbar
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null.toString());
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some result based on the selection
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something
    final suggestionList = query.isEmpty
        ? recentHistory
        : articles.where((element) {
            final date = element.publshedAt;
            return date == date.subtract(Duration(days: 30));
          }).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.category),
        title: Text(suggestionList[index].toString()),
      ),
      itemCount: suggestionList.length,
    );
  }
}
