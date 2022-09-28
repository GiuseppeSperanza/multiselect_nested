import 'package:flutter/material.dart';

class MultiSelectTreeTestComponent extends StatelessWidget {
  const MultiSelectTreeTestComponent({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Select Tree test Component',
      home: Scaffold(
        body: Center(
          child: child,
        ),
      ),
    );
  }
}
