import 'package:flutter/material.dart';
import 'live_canteen_counter.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final bool showLiveCount;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.showLiveCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          body,
          if (showLiveCount)
            const Positioned.fill(
              child: LiveCanteenCounter(),
            ),
        ],
      ),
    );
  }
}
