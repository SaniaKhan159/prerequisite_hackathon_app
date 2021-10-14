import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prerequisite_hackathon_app/view/favorite_news.dart';
import 'package:prerequisite_hackathon_app/view/home.dart';
import 'package:prerequisite_hackathon_app/view/news_search.dart';
import 'package:prerequisite_hackathon_app/view/register.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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

  Stream? userStream =
      FirebaseFirestore.instance.collection('users').doc().snapshots();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

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
      body: Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        child: StreamBuilder<QuerySnapshot>(
          stream: users.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Container(
                  child: Column(
                    children: [
                      // ClipOval(
                      //   child: Image.network(
                      //     data['url'] ?? "",
                      //     width: 100,
                      //     height: 100,
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      // Image.network(
                      //   data['url'] ?? "",
                      //   width: 100,
                      //   height: 100,
                      // ),
                      Text(
                        data['username'] ?? "",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),

                      Text(
                        data['email'] ?? "",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),

                      Text(
                        data['phone'] ?? "",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),

                      Text(
                        data['address'] ?? "",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
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
