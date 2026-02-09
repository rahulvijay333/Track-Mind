import 'package:flutter/material.dart';
import '../../../constants/cons.dart';

class DefaultTile extends StatelessWidget {
  const DefaultTile({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Keep your mind clear',
            style: kTitleStyle.copyWith(fontSize: 20, color: kTextMutedColor),
          ),
          const SizedBox(height: 10),
          Text(
            'Start capturing your ideas',
            style: kMutedStyle,
          ),
        ],
      ),
    );
  }
}
