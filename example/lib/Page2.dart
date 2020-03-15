import 'package:flutter/material.dart';
import 'package:tix_analytics/tix.dart';

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> with Tix {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('$runtimeType'),
        ),
      ),
    );
  }
}
