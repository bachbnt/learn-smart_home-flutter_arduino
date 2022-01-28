import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:smarthome/screens/room_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firebase = FirebaseDatabase.instance;
  var roomMap = Map<dynamic, dynamic>();
  var root = 'Room';

  @override
  void initState() {
    super.initState();
    firebase.reference().child(root).onChildChanged.listen((event) {
      setState(() {
        roomMap[event.snapshot.key] = event.snapshot.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ref = firebase.reference();
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: NeumorphicBackground(
        child: FutureBuilder<DataSnapshot>(
            future: ref.child(root).once(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                roomMap = snapshot.data.value;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => FutureBuilder<DataSnapshot>(
                    future: ref
                        .child(root)
                        .child((roomMap.keys.toList())[index])
                        .once(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: EdgeInsets.all(24.0),
                          child: NeumorphicButton(
                            onPressed: () {
                              pushNewScreenWithRouteSettings(context,
                                  screen: RoomScreen([
                                    (roomMap.keys.toList())[index],
                                    snapshot.data.value['Subname']
                                  ]),
                                  platformSpecific: true,
                                  withNavBar: false);
                            },
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(16.0)),
                            ),
                            child: Center(
                              child: Text(
                                '${snapshot.data.value['Subname']}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: NeumorphicTheme.accentColor(context),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  itemCount: roomMap.keys.toList().length,
                );
              }
              return NeumorphicIndicator();
            }),
      ),
    ));
  }
}
