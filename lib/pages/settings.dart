import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunipin/pages/newsfeed.dart';
import 'package:tunipin/widgets/theme_toggle.dart';

List<String> tunipinInterests = [
  "Business",
  "Entertainment",
  "Politics",
  "Health",
  "Sports",
  "Technology",
  "Sciences",
  "Fashion",
  "Travel",
  "World",
  "General",
  "Gaming"
];
List<String> userInterests = [""];

bool isNotifEnabled = true;

enum Availability { LOADING, AVAILABLE, UNAVAILABLE } // app review state

extension on Availability {
  String stringify() => this.toString().split('.').last;
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final InAppReview _inAppReview = InAppReview.instance;
  String _appStoreId = '';
  //String _microsoftId = '';
  Availability _availability = Availability.LOADING;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      try {
        final isAvailable = await _inAppReview.isAvailable();
        setState(() {
          _availability = isAvailable && !Platform.isAndroid
              ? Availability.AVAILABLE
              : Availability.UNAVAILABLE;
        });
      } catch (e) {
        setState(() {
          _availability = Availability.UNAVAILABLE;
        });
      }
    });
    super.initState();
  }

  //void _setAppStoreId(String id) => _appStoreId = id;
  //void _setMicrosoftStoreId(String id) => _microsoftId = id;
  Future<void> _requestReview() => _inAppReview.requestReview();
  /*Future<void> _openStoreListing() => _inAppReview.openStoreListing(
        appStoreId: _appStoreId,
        microsoftStoreId: _microsoftId,
      );*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //leading: null,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: false,
        //titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Platform.isIOS
                ? Icon(
                    CupertinoIcons.settings,
                    color: Theme.of(context).primaryColor,
                  )
                : Icon(
                    Icons.settings,
                    color: Theme.of(context).primaryColor,
                  ),
            SizedBox(
              width: 4,
            ),
            Text(
              'Settings',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Text(
                'Newsfeed',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 13),
              ),
              IconButton(
                splashRadius: 20,
                icon: Icon(Platform.isIOS
                    ? CupertinoIcons.arrow_right
                    : Icons.arrow_forward),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      Platform.isIOS
                          ? CupertinoPageRoute(builder: (context) => Newsfeed())
                          : MaterialPageRoute(
                              builder: (context) => Newsfeed()));
                },
              ),
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                _triggerInterestsPicker();
              },
              leading: Icon(Platform.isIOS
                  ? CupertinoIcons.archivebox
                  : Icons.inventory_2),
              title: Text('Center of interests'),
              subtitle: Text('Pick the area of your interests.'),
            ),
            ListTile(
              leading:
                  Icon(Platform.isIOS ? CupertinoIcons.moon : Icons.dark_mode),
              title: Text('Dark mode'),
              subtitle: Text('Turn dark mode on and off.'),
              trailing: ThemeToggle(),
            ),
            ListTile(
              leading: Icon(
                Platform.isIOS
                    ? isNotifEnabled
                        ? CupertinoIcons.bell
                        : CupertinoIcons.bell_slash
                    : isNotifEnabled
                        ? Icons.notifications
                        : Icons.notifications_off,
                color: !isNotifEnabled ? Colors.redAccent : Colors.teal,
              ),
              title: Text('Notifications'),
              subtitle: Text(isNotifEnabled
                  ? 'You\'re receiving notifications.'
                  : 'You\'re not receiving notifications.'),
              trailing: Switch.adaptive(
                  value: isNotifEnabled,
                  onChanged: (value) {
                    setState(() {
                      isNotifEnabled = value;
                    });
                  }),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.share),
              title: Text('Share'),
              subtitle: Text('Share Tunipin with friends and family.'),
            ),
            ListTile(
              onTap: () {
                _requestReview();
              },
              leading:
                  Icon(Platform.isIOS ? CupertinoIcons.star : Icons.star_rate),
              title: Text('Rate us'),
              subtitle: Text(Platform.isIOS
                  ? 'Rate Tunipin on App store'
                  : 'Rate Tunipin on Play store'),
            ),
            ListTile(
              onTap: () async {
                SharedPreferences mSharedPrefs =
                    await SharedPreferences.getInstance();
                print(mSharedPrefs.getBool('myThemeMode'));
              },
              leading: Icon(Icons.feedback),
              title: Text('Feedback'),
              subtitle: Text('Your opnion is important to us.'),
            ),
          ],
        ),
      ),
    );
  }

  void _triggerInterestsPicker() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext ctx, StateSetter stateSetter) {
            return Container(
              padding:
                  EdgeInsets.only(left: 14, right: 14, top: 30, bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        'Customize your interests',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  chipList(),
                  SizedBox(
                    height: 24,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 14, right: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoButton(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.teal,
                              child: Text('SAVE CHOICES'),
                              onPressed: () async {
                                SharedPreferences mSharedPrefs =
                                    await SharedPreferences.getInstance();
                                if (userInterests.isEmpty) {
                                  userInterests.add('notset');
                                  mSharedPrefs
                                      .setStringList(
                                          'myInterests', userInterests)
                                      .then((value) => Navigator.pop(context));
                                } else {
                                  userInterests.removeAt(0);
                                  if (userInterests.length ==
                                      tunipinInterests.length) {
                                    userInterests.clear();
                                    userInterests.add('allset');
                                    mSharedPrefs
                                        .setStringList(
                                            'myInterests', userInterests)
                                        .then(
                                            (value) => Navigator.pop(context));
                                  } else {
                                    mSharedPrefs
                                        .setStringList(
                                            'myInterests', userInterests)
                                        .then(
                                            (value) => Navigator.pop(context));
                                  }
                                }
                                //Read prefs
                                /*SharedPreferences mSharedPrefs = await SharedPreferences.getInstance();
                                List<String>? mList = mSharedPrefs.getStringList('myInterests');*/
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  Widget chipList() {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: <Widget>[
        _buildChip(tunipinInterests[0]),
        _buildChip(tunipinInterests[1]),
        _buildChip(tunipinInterests[2]),
        _buildChip(tunipinInterests[3]),
        _buildChip(tunipinInterests[4]),
        _buildChip(tunipinInterests[5]),
        _buildChip(tunipinInterests[6]),
        _buildChip(tunipinInterests[7]),
        _buildChip(tunipinInterests[8]),
        _buildChip(tunipinInterests[9]),
        _buildChip(tunipinInterests[10]),
        _buildChip(tunipinInterests[11]),
      ],
    );
  }

  Widget _buildChip(String label) {
    return StatefulBuilder(
        builder: (BuildContext ctx, StateSetter stateSetter) {
      return FilterChip(
        labelPadding: EdgeInsets.all(2.0),
        label: Text(
          label,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        //backgroundColor: color,
        elevation: 0.0,
        padding: EdgeInsets.all(8.0),
        selected: userInterests.contains(label),
        selectedColor: Colors.deepOrange,
        onSelected: (bool selected) {
          stateSetter(() {
            if (!userInterests.contains(label)) {
              userInterests.add(label);
            } else if (userInterests.contains(label)) {
              userInterests.remove(label);
            }
          });
        },
      );
    });
  }
}
