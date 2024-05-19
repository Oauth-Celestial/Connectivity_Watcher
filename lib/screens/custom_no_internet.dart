import 'package:flutter/material.dart';

class CustomNoInternetWrapper extends StatelessWidget {
  final Widget Function(BuildContext) builder;
  CustomNoInternetWrapper({required this.builder});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
            backgroundColor: Colors.transparent, body: builder(context));
      },
    );
  }
}
