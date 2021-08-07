import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'newsfeed.dart';

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  void initState() {
    super.initState();
    // Hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          splashRadius: 20,
          icon: Icon(
              Platform.isIOS ? CupertinoIcons.arrow_left : Icons.arrow_back),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.pushReplacement(
                context,
                Platform.isIOS
                    ? CupertinoPageRoute(builder: (context) => Newsfeed())
                    : MaterialPageRoute(builder: (context) => Newsfeed()));
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: false,
        //titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Platform.isIOS
                ? Icon(
                    CupertinoIcons.doc_text,
                    color: Theme.of(context).primaryColor,
                  )
                : Icon(
                    Icons.article,
                    color: Theme.of(context).primaryColor,
                  ),
            SizedBox(
              width: 4,
            ),
            Text(
              'Read more',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
        actions: [
          IconButton(
            splashRadius: 20,
            icon: Icon(Platform.isIOS
                ? CupertinoIcons.ellipsis_vertical
                : Icons.more_vert),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              //popup menu:
              //Item 1: Open in browser
              //Item 2: Share to social media
              //Item 3: Refresh
            },
          ),
        ],
      ),
      body: SafeArea(
          child: WebView(
        initialUrl: 'https://flutter.dev',
      )),
    );
  }
}
