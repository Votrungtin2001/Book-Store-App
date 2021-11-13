import 'package:flutter/material.dart';

class DismissibleWidget<T> extends StatelessWidget {
  final T item;
  final Widget child;
  final DismissDirectionCallback onDismissed;

  const DismissibleWidget({
    Key? key,
    required this.item,
    required this.child,
    required this.onDismissed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Dismissible(
    key: ObjectKey(item),
    background: buildSwipeActionLeft(),
    secondaryBackground: buildSwipeActionRight(),
    child: child,
    onDismissed: onDismissed,
  );

  Widget buildSwipeActionLeft() => Container(
    height: 200,
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.symmetric(horizontal: 20),
    color: Colors.green,
    child: Icon(Icons.check_box_sharp, color: Colors.white, size: 32),
  );

  Widget buildSwipeActionRight() => Container(
    height: 200,
    alignment: Alignment.centerRight,
    padding: EdgeInsets.symmetric(horizontal: 20),
    color: Colors.red,
    child: Icon(Icons.delete, color: Colors.white, size: 32),
  );
}