import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_hunter_app/Models/posting_objects.dart';
import 'package:hotel_hunter_app/Screens/view_posting_page.dart';
import 'package:hotel_hunter_app/Views/grid_widgets.dart';

class ExplorePage extends StatefulWidget {
  ExplorePage({Key key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 50.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.all(5.0),
                ),
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
            ),
            StreamBuilder(
              stream: Firestore.instance.collection('postings').snapshots(),
              builder: (context, snapshots) {
                switch (snapshots.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    return GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshots.data.documents.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 3 / 4),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snapshot = snapshots.data.documents[index];
                        Posting currentPosting = Posting(id: snapshot.documentID);
                        currentPosting.getPostingInfoFromSnapshot(snapshot);
                        return InkResponse(
                          enableFeedback: true,
                          child: PostingGridTile(posting: currentPosting,),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ViewPostingPage.routeName,
                            );
                          },
                        );
                      },
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
