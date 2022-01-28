import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class RoomScreen extends StatefulWidget {
  var args;

  RoomScreen(this.args);

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final firebase = FirebaseDatabase.instance;
  var deviceMap = Map<dynamic, dynamic>();
  var root = 'Room';

  @override
  void initState() {
    super.initState();
    firebase.reference().child(root).onChildChanged.listen((event) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final ref = firebase.reference();
    return Scaffold(
      appBar: NeumorphicAppBar(
        leading: NeumorphicButton(
          style: NeumorphicStyle(boxShape: NeumorphicBoxShape.circle()),
          child: Icon(
            Icons.arrow_back_ios,
            color: NeumorphicTheme.defaultTextColor(context),
            size: 24,
          ),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
        title: NeumorphicText(
          ('${widget.args[1]}').toUpperCase(),
          style: NeumorphicStyle(            color: NeumorphicTheme.accentColor(context),
          ),
          textStyle: NeumorphicTextStyle(

            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: NeumorphicBackground(
          child: FutureBuilder<DataSnapshot>(
              future: ref
                  .child('Room')
                  .child(widget.args[0])
                  .child('Devices')
                  .once(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  deviceMap = snapshot.data.value;
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) =>
                        FutureBuilder<DataSnapshot>(
                            future: ref
                                .child('Room')
                                .child(widget.args[0])
                                .child('Devices')
                                .child((deviceMap.keys.toList())[index])
                                .once(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Neumorphic(
                                    style: NeumorphicStyle(
                                      shape: NeumorphicShape.flat,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(16.0)),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: buildDeviceItem(
                                            ref, snapshot, index)),
                                  ),
                                );
                              }
                              return Container();
                            }),
                    itemCount: deviceMap.keys.toList().length,
                  );
                }
                return NeumorphicIndicator();
              }),
        ),
      ),
    );
  }

  int getToggleIndex(int level, String status) {
    if (level == 3) {
      switch (status) {
        case 'SMALL':
          return 1;
        case 'LARGE':
          return 2;
        default:
          return 0;
      }
    } else if (level == 4) {
      switch (status) {
        case 'LOW':
          return 1;
        case 'MEDIUM':
          return 2;
        case 'HIGH':
          return 3;
        default:
          return 0;
      }
    }
    return 0;
  }

  double getSliderValue(String status) {
    switch (status) {
      case 'OFF':
        return 0.0;
      case 'MIN':
        return 1.0;
      case 'MAX':
        return 100.0;
      default:
        return double.parse(status);
    }
  }

  IconData getItemIcon(String type) {
    switch (type) {
      case 'LIGHT':
        return Icons.lightbulb_outline;
      case 'WATER':
        return Icons.invert_colors;
      case 'FIRE':
        return Icons.whatshot;
      case 'FAN':
        return Icons.toys;
      case 'TV':
        return Icons.tv;
      case 'SENSOR':
        return Icons.developer_board;
      default:
        return Icons.devices;
    }
  }

  Widget buildDeviceItem(
      DatabaseReference ref, AsyncSnapshot<DataSnapshot> snapshot, int index) {
    switch (snapshot.data.value['Level']) {
      case 0:
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NeumorphicIcon(
                  getItemIcon(snapshot.data.value['Type']),
                  size: 24,
                  style: NeumorphicStyle(
                      color: snapshot.data.value['Status'] == 'ACTIVE'
                          ? NeumorphicTheme.accentColor(context)
                          : NeumorphicTheme.defaultTextColor(context)),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Text(
                  '${snapshot.data.value['Subname']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: snapshot.data.value['Status'] == 'ACTIVE'
                        ? NeumorphicTheme.accentColor(context)
                        : NeumorphicTheme.defaultTextColor(context),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            snapshot.data.value['Status'] == 'ACTIVE'
                ? NeumorphicText(
                    'Hoạt động',
                    style: NeumorphicStyle(
                      color: CupertinoColors.activeGreen,
                    ),
                  )
                : NeumorphicText(
                    'Không hoạt động',
                    style:
                        NeumorphicStyle(color: CupertinoColors.destructiveRed),
                  )
          ],
        );
      case 1:
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NeumorphicIcon(
                  getItemIcon(snapshot.data.value['Type']),
                  size: 24,
                  style: NeumorphicStyle(
                      color: snapshot.data.value['Status'] == 'OFF'
                          ? NeumorphicTheme.defaultTextColor(context)
                          : NeumorphicTheme.accentColor(context)),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Text(
                  '${snapshot.data.value['Subname']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: snapshot.data.value['Status'] == 'OFF'
                        ? NeumorphicTheme.defaultTextColor(context)
                        : NeumorphicTheme.accentColor(context),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            NeumorphicRangeSlider(
              height: 24.0,
              style: RangeSliderStyle(
                accent: NeumorphicTheme.accentColor(context),
                variant: NeumorphicTheme.baseColor(context),
              ),
              valueLow: 0.0,
              valueHigh: getSliderValue(snapshot.data.value['Status']),
              min: 0.0,
              max: 100.0,
              onChangeHigh: (value) {
                switch (value.toInt()) {
                  case 0:
                    ref
                        .child(root)
                        .child(widget.args[0])
                        .child('Devices')
                        .child((deviceMap.keys.toList())[index])
                        .update({'Status': 'OFF'});
                    break;
                  case 1:
                    ref
                        .child(root)
                        .child(widget.args[0])
                        .child('Devices')
                        .child((deviceMap.keys.toList())[index])
                        .update({'Status': 'MIN'});
                    break;
                  case 100:
                    ref
                        .child(root)
                        .child(widget.args[0])
                        .child('Devices')
                        .child((deviceMap.keys.toList())[index])
                        .update({'Status': 'MAX'});
                    break;
                  default:
                    ref
                        .child(root)
                        .child(widget.args[0])
                        .child('Devices')
                        .child((deviceMap.keys.toList())[index])
                        .update({'Status': value.toInt().toString()});
                    break;
                }
              },
            ),
          ],
        );
      case 2:
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NeumorphicIcon(
                  getItemIcon(snapshot.data.value['Type']),
                  size: 24,
                  style: NeumorphicStyle(
                      color: snapshot.data.value['Status'] == 'OFF'
                          ? NeumorphicTheme.defaultTextColor(context)
                          : NeumorphicTheme.accentColor(context)),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Text(
                  '${snapshot.data.value['Subname']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: snapshot.data.value['Status'] == 'OFF'
                        ? NeumorphicTheme.defaultTextColor(context)
                        : NeumorphicTheme.accentColor(context),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            NeumorphicSwitch(
                onChanged: (value) {
                  ref
                      .child(root)
                      .child(widget.args[0])
                      .child('Devices')
                      .child((deviceMap.keys.toList())[index])
                      .update({'Status': value ? 'ON' : 'OFF'});
                },
                value: snapshot.data.value['Status'] == 'OFF' ? false : true),
          ],
        );
      case 3:
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NeumorphicIcon(
                  getItemIcon(snapshot.data.value['Type']),
                  size: 24,
                  style: NeumorphicStyle(
                      color: snapshot.data.value['Status'] == 'OFF'
                          ? NeumorphicTheme.defaultTextColor(context)
                          : NeumorphicTheme.accentColor(context)),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Text(
                  '${snapshot.data.value['Subname']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: snapshot.data.value['Status'] == 'OFF'
                        ? NeumorphicTheme.defaultTextColor(context)
                        : NeumorphicTheme.accentColor(context),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            NeumorphicToggle(
              height: 48.0,
              displayForegroundOnlyIfSelected: true,
              onChanged: (value) {
                switch (value) {
                  case 0:
                    ref
                        .child(root)
                        .child(widget.args[0])
                        .child('Devices')
                        .child((deviceMap.keys.toList())[index])
                        .update({'Status': 'OFF'});
                    break;
                  case 1:
                    ref
                        .child(root)
                        .child(widget.args[0])
                        .child('Devices')
                        .child((deviceMap.keys.toList())[index])
                        .update({'Status': 'SMALL'});
                    break;
                  case 2:
                    ref
                        .child(root)
                        .child(widget.args[0])
                        .child('Devices')
                        .child((deviceMap.keys.toList())[index])
                        .update({'Status': 'LARGE'});
                    break;
                }
              },
              selectedIndex: getToggleIndex(3, snapshot.data.value['Status']),
              children: [
                ToggleElement(
                    foreground: Center(
                        child: Text(
                      'Tắt',
                      style: TextStyle(
                          color: NeumorphicTheme.accentColor(context),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )),
                    background: Center(
                        child: Text(
                      'Tắt',
                      style: TextStyle(
                          color: NeumorphicTheme.defaultTextColor(context),
                          fontWeight: FontWeight.bold),
                    ))),
                ToggleElement(
                    foreground: Center(
                        child: Text('Nhỏ',
                            style: TextStyle(
                                color: NeumorphicTheme.accentColor(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 18))),
                    background: Center(
                        child: Text(
                      'Nhỏ',
                      style: TextStyle(
                        color: NeumorphicTheme.defaultTextColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ))),
                ToggleElement(
                    foreground: Center(
                        child: Text('Lớn',
                            style: TextStyle(
                                color: NeumorphicTheme.accentColor(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 18))),
                    background: Center(
                        child: Text(
                      'Lớn',
                      style: TextStyle(
                        color: NeumorphicTheme.defaultTextColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ))),
              ],
            ),
          ],
        );
      case 4:
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NeumorphicIcon(
                  getItemIcon(snapshot.data.value['Type']),
                  size: 24,
                  style: NeumorphicStyle(
                      color: snapshot.data.value['Status'] == 'OFF'
                          ? NeumorphicTheme.defaultTextColor(context)
                          : NeumorphicTheme.accentColor(context)),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Text(
                  '${snapshot.data.value['Subname']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: snapshot.data.value['Status'] == 'OFF'
                        ? NeumorphicTheme.defaultTextColor(context)
                        : NeumorphicTheme.accentColor(context),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            NeumorphicToggle(
              height: 48.0,
              displayForegroundOnlyIfSelected: true,
              onChanged: (value) {
                switch (value) {
                  case 0:
                    ref
                        .child(root)
                        .child(widget.args[0])
                        .child('Devices')
                        .child((deviceMap.keys.toList())[index])
                        .update({'Status': 'OFF'});
                    break;
                  case 1:
                    ref
                        .child(root)
                        .child(widget.args[0])
                        .child('Devices')
                        .child((deviceMap.keys.toList())[index])
                        .update({'Status': 'LOW'});
                    break;
                  case 2:
                    ref
                        .child(root)
                        .child(widget.args[0])
                        .child('Devices')
                        .child((deviceMap.keys.toList())[index])
                        .update({'Status': 'MEDIUM'});
                    break;
                  case 3:
                    ref
                        .child(root)
                        .child(widget.args[0])
                        .child('Devices')
                        .child((deviceMap.keys.toList())[index])
                        .update({'Status': 'HIGH'});
                    break;
                }
              },
              selectedIndex: getToggleIndex(4, snapshot.data.value['Status']),
              children: [
                ToggleElement(
                    foreground: Center(
                        child: Text('Tắt',
                            style: TextStyle(
                                color: NeumorphicTheme.accentColor(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 18))),
                    background: Center(
                        child: Text(
                      'Tắt',
                      style: TextStyle(
                          color: NeumorphicTheme.defaultTextColor(context),
                          fontWeight: FontWeight.bold),
                    ))),
                ToggleElement(
                    foreground: Center(
                        child: Text('Nhẹ',
                            style: TextStyle(
                                color: NeumorphicTheme.accentColor(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 18))),
                    background: Center(
                        child: Text(
                      'Nhẹ',
                      style: TextStyle(
                        color: NeumorphicTheme.defaultTextColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ))),
                ToggleElement(
                    foreground: Center(
                        child: Text('Vừa',
                            style: TextStyle(
                                color: NeumorphicTheme.accentColor(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 18))),
                    background: Center(
                        child: Text(
                      'Vừa',
                      style: TextStyle(
                        color: NeumorphicTheme.defaultTextColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ))),
                ToggleElement(
                    foreground: Center(
                        child: Text('Mạnh',
                            style: TextStyle(
                                color: NeumorphicTheme.accentColor(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 18))),
                    background: Center(
                        child: Text(
                      'Mạnh',
                      style: TextStyle(
                        color: NeumorphicTheme.defaultTextColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ))),
              ],
            ),
          ],
        );
      default:
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NeumorphicIcon(
                  getItemIcon(snapshot.data.value['Type']),
                  size: 24,
                  style: NeumorphicStyle(
                      color: snapshot.data.value['Status'] == 'OFF'
                          ? NeumorphicTheme.defaultTextColor(context)
                          : NeumorphicTheme.accentColor(context)),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Text(
                  '${snapshot.data.value['Subname']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: snapshot.data.value['Status'] == 'OFF'
                        ? NeumorphicTheme.defaultTextColor(context)
                        : NeumorphicTheme.accentColor(context),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        );
    }
  }
}
