import 'package:flutter/material.dart';

PreferredSizeWidget appBarWithBack(
  BuildContext context, {
  required String title,
  List<Widget>? actions,
}) {
  return AppBar(
    title: Text(title),
    leading: Navigator.canPop(context)
        ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          )
        : null,
    actions: actions,
  );
}
