import 'package:flutter/material.dart';
import 'package:prerequisite_hackathon_app/models/article_model.dart';
import 'package:prerequisite_hackathon_app/helper/news.dart';
import 'package:prerequisite_hackathon_app/view/article_view.dart';
import 'package:prerequisite_hackathon_app/view/home.dart';
import 'package:prerequisite_hackathon_app/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryNews extends StatefulWidget {
  final String category;
  CategoryNews({required this.category});
  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ArticleModel> articles = [];
  bool _loading = true;

  void initState() {
    super.initState();
    getCategoryNews();
  }

  void getCategoryNews() async {
    CategoryNewsClass newsClass = CategoryNewsClass();
    await newsClass.getNews(widget.category);
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Flutter"),
            Text(
              "News",
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
        actions: <Widget>[
          Opacity(
            opacity: 0,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.save)),
          )
        ],
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _loading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
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
    );
  }
}

Future<bool> saveNamePreference(String newstitle) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
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
