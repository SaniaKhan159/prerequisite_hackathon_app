import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prerequisite_hackathon_app/helper/data.dart';
import 'package:prerequisite_hackathon_app/helper/news.dart';
import 'package:prerequisite_hackathon_app/models/article_model.dart';
import 'package:prerequisite_hackathon_app/models/category_model.dart';
import 'package:prerequisite_hackathon_app/view/article_view.dart';
import 'package:prerequisite_hackathon_app/view/category_news.dart';
import 'package:prerequisite_hackathon_app/view/favorite_news.dart';
import 'package:prerequisite_hackathon_app/view/login.dart';
import 'package:prerequisite_hackathon_app/view/news_search.dart';
import 'package:prerequisite_hackathon_app/view/profile.dart';
import 'package:prerequisite_hackathon_app/view/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = <CategoryModel>[];
  List<ArticleModel> articles = <ArticleModel>[];

  bool _loading = true;
  // bool _isFavorited = true;

  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  void getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
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
      body: _loading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: <Widget>[
                    ///Categories
                    Container(
                      height: 70,
                      child: ListView.builder(
                        itemCount: categories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return CategoryTile(
                            imageUrl: categories[index].imageUrl,
                            categoryName: categories[index].categoryName,
                          );
                        },
                      ),
                    ),

                    ///Seachbar
                    // Container(
                    //   child: TextField(
                    //     decoration: InputDecoration(hintText: 'Search'),
                    //   ),
                    // ),

                    ///Blogs
                    Container(
                      padding: EdgeInsets.only(top: 16),
                      child: ListView.builder(
                        itemCount: articles.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return BlogTile(
                            imageUrl: articles[index].urlToImage,
                            title: articles[index].title,
                            description: articles[index].description,
                            url: articles[index].url,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
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
}

Future<bool> saveNamePreference(String newstitle) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // FirebaseAuth.instance.authStateChanges().listen((User user) {
  //   if (user == null) {
  //     print('User is currently signed out!');
  //   } else {
  //     print('User is signed in!');
  //   }
  // });
  // bool userStatus = prefs.containsKey('uid');
  // if (userStatus == null) {
  //   print('User is currently signed out!');
  // } else {
  //   print('User is signed in!');
  // }
  var email = prefs.getString('email');
  print(email);
  runApp(MaterialApp(home: email == null ? Login() : Home()));

  prefs.setString("newstitle", newstitle);
  return prefs.commit();
}

Future<String?> getNamePreference() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? newstitle = prefs.getString("newstitle");
  return newstitle;
}

class CategoryTile extends StatelessWidget {
  final imageUrl, categoryName;
  CategoryTile({this.imageUrl, this.categoryName});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNews(
                      category: categoryName.toLowerCase(),
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 120,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 120,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              child: Text(
                categoryName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, description, url;
  BlogTile(
      {required this.imageUrl,
      required this.title,
      required this.description,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleView(
                      blogUrl: url,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          children: <Widget>[
            Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      String newstitle = title;
                      saveNamePreference(newstitle).then((bool commited) {
                        Navigator.of(context).pushNamed('/favorite');
                      });
                    },
                    icon: Icon(
                      Icons.favorite,
                      size: 35,
                      color: Colors.pink,
                    ))),
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(imageUrl)),
            SizedBox(
              height: 8,
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              description,
              style: TextStyle(color: Colors.black54),
            )
          ],
        ),
      ),
    );
  }
}
