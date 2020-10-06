import 'package:flutter/material.dart';

class DeleteAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.redAccent,
      ),
      child: Icon(
        Icons.delete_forever,
        size: 60.0,
        color: Colors.white,
      ),
    );
  }
}
