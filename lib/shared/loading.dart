import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Loading animation
    return Center(
      child: SpinKitFadingCircle(
        color: Colors.purpleAccent,
        size: 60.0,
      ),
    );
  }
}
