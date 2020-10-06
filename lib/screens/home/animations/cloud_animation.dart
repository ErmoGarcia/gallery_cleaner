import 'package:flutter/material.dart';

class CloudAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blueAccent,
      ),
      child: Icon(
        Icons.cloud_upload,
        size: 60.0,
        color: Colors.white,
      ),
    );
  }
}
