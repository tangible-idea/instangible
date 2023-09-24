
import 'package:flutter/material.dart';
import 'package:instagible/extensions/textstyle_extension.dart';

import '../constants/constants.dart';
import '../styles/themes.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    required Key key,
    this.titleText = 'Your Title',
    required this.child,
    this.showAppBar = true,
    this.showDrawer = false,
    this.showAppBarActions = false,
    this.enableDarkMode = false,
    required this.drawerChild,
    required Widget bottomSheet,
    required this.actions,
  })  : _bottomSheet = bottomSheet,
        super(key: key);

  final String titleText;
  final Widget child;
  final bool showAppBar;
  final bool showAppBarActions;
  final bool showDrawer;
  final bool enableDarkMode;
  final Widget drawerChild;
  final Widget _bottomSheet;
  final List<Widget> actions;

  static TextStyle get light => const TextStyle().c(Colors.black);
  static TextStyle get dark => const TextStyle().c(Colors.white);

  List<Widget> get _showActions {
    if (showAppBarActions) {
      return actions;
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {

    return Theme(
      data: enableDarkMode
          ? ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: ApplevelConstants.fontFamily,
        ),
      )
          : AppTheme.darkTheme,
      child: Scaffold(
        appBar: showAppBar
            ? AppBar(
          actions: _showActions,
          title: Text(titleText, style: enableDarkMode ? dark : light),
        )
            : null,
        body: child ?? const Center(child: Text('Hi there')),
        endDrawer: showDrawer ? drawerChild : null,
        bottomSheet: _bottomSheet,
      ),
    );
  }
}
