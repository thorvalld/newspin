import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tunipin/pages/settings.dart';

import 'details.dart';

class Newsfeed extends StatefulWidget {
  @override
  _NewsfeedState createState() => _NewsfeedState();
}

class _NewsfeedState extends State<Newsfeed> {
  List<String> feedList = [
    "Nunc consectetur odio sed dolor pellentesque, eget dapibus nunc ornare.",
    "Ut vulputate nisl a aliquet consectetur.",
    "Vivamus condimentum scelerisque magna consequat posuere.",
    "Nam velit risus, porta at convallis non, sodales vel neque",
    "Proin urna dui, tincidunt sit amet malesuada sit amet, ornare nec massa.",
    "Nullam consequat egestas mollis. Donec placerat erat in turpis tristique lobortis.",
    "Integer eros ipsum, mollis tincidunt tristique a, elementum vel enim."
        "Vestibulum lorem leo, faucibus eu libero feugiat, bibendum sagittis dui.",
    "Sed dapibus felis eget mollis lacinia. Ut eget sapien nisl.",
    "Pellentesque congue ipsum et lacus tempus ultricies."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: null,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Platform.isIOS
                  ? Icon(
                      CupertinoIcons.news,
                      color: Theme.of(context).primaryColor,
                    )
                  : Icon(
                      Icons.document_scanner_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
              SizedBox(
                width: 4,
              ),
              Text(
                'Newsfeed',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          actions: [
            IconButton(
              splashRadius: 20,
              icon: Icon(
                  Platform.isIOS ? CupertinoIcons.settings : Icons.settings),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    Platform.isIOS
                        ? CupertinoPageRoute(builder: (context) => Settings())
                        : MaterialPageRoute(builder: (context) => Settings()));
              },
            ),
          ],
        ),
        body: SafeArea(
            child: CarouselSlider.builder(
                options: CarouselOptions(
                  pageSnapping: true,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.vertical,
                  height: MediaQuery.of(context).size.height,
                ),
                itemCount: feedList.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) =>
                        GestureDetector(
                            child: _feedItem(feedList[itemIndex]),
                            onHorizontalDragUpdate: (details) {
                              int sensitivity = 8;
                              if (details.delta.dx > sensitivity) {
                                print('right swipe');
                              } else if (details.delta.dx < -sensitivity) {
                                print('left swipe');
                                Navigator.pushReplacement(
                                    context,
                                    Platform.isIOS
                                        ? CupertinoPageRoute(
                                            builder: (context) => Details())
                                        : MaterialPageRoute(
                                            builder: (context) => Details()));
                              }
                            }))));
  }

  Widget _feedItem(String headline) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildCategoryChip('Category'),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                          child: new Text(
                        headline,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.arrow_left,
                        size: 14,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'swipe to continue reading',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.grey.shade600,
                        ),
                      )
                    ],
                  )
                ],
              )),
          //Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Published by: Lorem Ipsum'),
                      Text(
                        DateTime.now().toIso8601String(),
                        style: TextStyle(fontSize: 9),
                      )
                    ],
                  ),
                  Spacer(),
                  InkResponse(
                    radius: 18,
                    onTap: () {
                      _triggerOptionMenu();
                    },
                    child: Icon(Platform.isIOS
                        ? CupertinoIcons.ellipsis_vertical
                        : Icons.more_vert),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      label: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      backgroundColor: Colors.deepOrange,
      elevation: 0.0,
      padding: EdgeInsets.all(8.0),
    );
  }

  void _triggerOptionMenu() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext ctx, StateSetter stateSetter) {
            return Container(
              padding: EdgeInsets.only(top: 14, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    onTap: () {},
                    leading: Icon(Platform.isIOS
                        ? CupertinoIcons.arrowshape_turn_up_right_fill
                        : Icons.share),
                    title: Text('Share'),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.report),
                    title: Text('Report'),
                  ),
                ],
              ),
            );
          });
        });
  }
}
