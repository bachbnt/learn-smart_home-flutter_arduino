import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:persistent_bottom_nav_bar/models/persisten-bottom-nav-item.widget.dart';

class CustomBotNavBar extends StatelessWidget {
  final int selectedIndex;
  final List<PersistentBottomNavBarItem> items;
  final ValueChanged<int> onItemSelected;

  CustomBotNavBar({
    Key key,
    this.selectedIndex,
    @required this.items,
    this.onItemSelected,
  });

  Widget buildBotNavBarItem(
      BuildContext context, PersistentBottomNavBarItem item, bool isSelected) {
    return Neumorphic(
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.all(Radius.circular(16))),
        shape: isSelected ? NeumorphicShape.concave : NeumorphicShape.convex,
        color: NeumorphicTheme.variantColor(context)
      ),
      child: Container(
        width: 60.0,
        height: 60.0,
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: IconTheme(
                data: IconThemeData(
                    size: 24.0,
                    color: isSelected
                        ? NeumorphicTheme.accentColor(context)
                        : NeumorphicTheme.defaultTextColor(context)),
                child: item.icon,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Material(
                type: MaterialType.transparency,
                child: FittedBox(
                    child: Text(
                  item.title,
                  style: TextStyle(
                      color: isSelected
                          ? NeumorphicTheme.accentColor(context)
                          : NeumorphicTheme.defaultTextColor(context),
                      fontWeight: FontWeight.w400,
                      fontSize: item.titleFontSize),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: NeumorphicTheme.baseColor(context),
      width: double.infinity,
      height: 80.0,
      child: Neumorphic(
        style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(24))),color: NeumorphicTheme.variantColor(context)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: items.map((item) {
            var index = items.indexOf(item);
            return Flexible(
              child: GestureDetector(
                onTap: () {
                  this.onItemSelected(index);
                },
                child: buildBotNavBarItem(context, item, selectedIndex == index),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
