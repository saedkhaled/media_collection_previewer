import 'package:flutter/material.dart';

class MoreMedia extends StatelessWidget {
  final double height;
  final int count;

  const MoreMedia({super.key, required this.height, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: '+',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 60,
              ),
            ),
            TextSpan(
              text: '${count - 5}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
