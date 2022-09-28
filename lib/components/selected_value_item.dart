import 'package:flutter/material.dart';

class SelectedValueItem extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color dividerColor;
  final GestureTapCallback gestureTapCallback;

  const SelectedValueItem({
    Key? key,
    required this.label,
    required this.gestureTapCallback,
    required this.backgroundColor,
    required this.dividerColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: backgroundColor,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: Text(label)),
            VerticalDivider(
              color: dividerColor,
              thickness: 2,
            ),
            GestureDetector(
              onTap: gestureTapCallback,
              child: const Icon(
                Icons.close,
                size: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
