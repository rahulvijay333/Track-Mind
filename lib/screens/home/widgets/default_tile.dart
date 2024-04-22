import 'package:flutter/material.dart';
import 'package:track_mind/screens/add_note/screen_add.dart';

import '../../../constants/cons.dart';

class DefaultTile extends StatelessWidget {
  const DefaultTile({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset('assets/notes_empty.png',width: 150,),
          const Text('No Notes'),
          const Spacer(),
          Center(
            child: SizedBox(
              width: size.width * 0.6,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) {
                        return const ScreenAdd();
                      },
                    ));
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.add), Text('Add note')],
                  )),
            ),
          ),
          space15
        ],
      );
  }
}