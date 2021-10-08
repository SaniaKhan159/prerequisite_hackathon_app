import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:prerequisite_hackathon_app/view/login.dart';

class NewsSearch extends StatefulWidget {
  // NewsSearch({required this.category});

  @override
  _NewsSearchState createState() => _NewsSearchState();
}

class _NewsSearchState extends State<NewsSearch> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('My Personal Journal');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customSearchBar,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (customIcon.icon == Icons.search) {
                  // Perform set of instructions.
                  customIcon = const Icon(Icons.cancel);
                  customSearchBar = const ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: TextField(
                      decoration: InputDecoration(
                        hintText: 'type in category news...',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                } else {
                  customIcon = const Icon(Icons.search);
                  customSearchBar = const Text('Search News');
                }
              });
            },
            icon: customIcon,
          )
        ],
        centerTitle: true,
      ),
      // body: SingleChildScrollView(
      //   child: Container(
      //     child: Column(
      //       children: [
      //         Container(
      //           margin: EdgeInsets.all(10),
      //           padding: EdgeInsets.all(10),
      //           decoration: BoxDecoration(
      //             color: Colors.blue,
      //             border: Border.all(color: Colors.white, width: 3.0),
      //             borderRadius: BorderRadius.all(Radius.circular(10.0)),
      //           ),
      //           child: TextField(
      //             decoration: InputDecoration(
      //                 hintText: 'Search Article', border: InputBorder.none),
      //             onChanged: (newValue) {
      //               setState(() {
      //                 widget.category = newValue;
      //               });
      //             },
      //           ),
      //         ),
      //         ElevatedButton(onPressed: () {}, child: Icon(Icons.search))
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
