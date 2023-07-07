import 'package:flutter/material.dart';
import 'package:media_collection_previewer/consts.dart';

class ArrowsBar extends StatelessWidget {
  final int index;
  final int length;
  final Color arrowColor;
  final Color arrowBgColor;
  final Function(int) onArrowTap;

  const ArrowsBar({
    Key? key,
    required this.index,
    required this.length,
    this.arrowColor = defaultIconColor,
    this.arrowBgColor = defaultIconBgColor,
    required this.onArrowTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Visibility(
              visible: index > 0,
              child: InkWell(
                onTap: () => onArrowTap(index - 1),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: arrowBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_left,
                    color: arrowColor,
                    size: 30,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: index < length - 1,
              child: InkWell(
                onTap: () => onArrowTap(index + 1),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: arrowBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    color: arrowColor,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
