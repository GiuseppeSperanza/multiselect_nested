import 'package:flutter/material.dart';

class MultiSelectNestedTestComponent extends StatelessWidget {
  const MultiSelectNestedTestComponent({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Select Nested test Component',
      home: Scaffold(
        body: Center(
          child: child,
        ),
      ),
    );
  }
}
