import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:time_tracker/common_widgets/platform_widget.dart';
import 'package:flutter/material.dart';

class PlatformAlretDialog extends PlatformWidget {
  final String title;
  final String content;
  final String cancelActionText;
  final String defaultActionText;
  PlatformAlretDialog(
      {@required this.title,
      @required this.content,
      this.cancelActionText,
      @required this.defaultActionText})
      : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);
  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog(
            context: context, builder: (context) => this)
        : await showDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (context) => this);
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: _buildActions(context));
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    if (cancelActionText != null) {
      actions.add(
        FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelActionText)),
      );
    }
    actions.add(FlatButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(defaultActionText)));
        return actions;
  }
}

class PlatformAlertDialogActions extends PlatformWidget {
  PlatformAlertDialogActions({this.child, this.onPressed});
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return FlatButton(onPressed: onPressed, child: child);
  }
}
