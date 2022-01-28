import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:smarthome/screens/home_screen.dart';
import 'package:smarthome/screens/sensor_screen.dart';
import 'package:smarthome/screens/setting_screen.dart';
import 'package:smarthome/widgets/custom_bot_nav_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PersistentTabController controller = PersistentTabController(initialIndex: 0);
  List<PersistentBottomNavBarItem> items = [
    PersistentBottomNavBarItem(
      icon: Icon(Icons.home),
      title: 'Phòng',
      activeColor: CupertinoColors.activeBlue,
      inactiveColor: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.devices),
      title: 'Thiết bị',
      activeColor: CupertinoColors.activeBlue,
      inactiveColor: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.timer),
      title: 'Tiện ích',
      activeColor: CupertinoColors.activeBlue,
      inactiveColor: CupertinoColors.systemGrey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var now=int.parse(DateFormat('kk').format(DateTime.now()));
    bool isDark=now>=18||now<6;
    return NeumorphicApp(
      themeMode: isDark?ThemeMode.dark:ThemeMode.light,
      theme: NeumorphicThemeData(
          baseColor: Color(0xFFF2F2F2),
          lightSource: LightSource.topLeft,
          defaultTextColor: CupertinoColors.systemGrey,
          depth: 10,
          intensity: 0.5,
          accentColor: CupertinoColors.activeBlue,
          variantColor: Color(0xFFF0F0F0)),
      darkTheme: NeumorphicThemeData(
          baseColor: Color(0xFF3E3E3E),
          lightSource: LightSource.topLeft,
          defaultTextColor: CupertinoColors.systemGrey,
          depth: 6,
          intensity: 0.3,
          accentColor: CupertinoColors.activeOrange,
          variantColor: Color(0xFF3D3D3D)),
      debugShowCheckedModeBanner: false,
      home: PersistentTabView(
        controller: controller,
        screens: [HomeScreen(), SensorScreen(), SettingScreen(context)],
        navBarStyle: NavBarStyle.custom,
        onItemSelected: (index) {
          setState(() {});
        },
        itemCount: items.length,
        customWidget: CustomBotNavBar(
          items: items,
          selectedIndex: controller.index,
          onItemSelected: (index) {
            setState(() {
              controller.index = index;
            });
          },
        ),
      ),
    );
  }
}
