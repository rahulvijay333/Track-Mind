import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:track_mind/constants/cons.dart';
import 'package:track_mind/db/notes_db.dart';
import 'package:track_mind/model/note.dart';
import 'package:track_mind/screens/add_note/screen_add.dart';
import 'package:track_mind/screens/home/widgets/default_tile.dart';

class Screenhome extends StatefulWidget {
  const Screenhome({super.key});

  @override
  State<Screenhome> createState() => _ScreenhomeState();
}

class _ScreenhomeState extends State<Screenhome> {
  List<Note>? noteslist;
  bool isloading = false;

  @override
  void initState() {
    refreshDB();
    super.initState();
  }

  void refreshDB() async {
    setState(() {
      isloading = true;
    });
    noteslist = await NoteDatabase.instance.readAllNotes();
    setState(() {
      isloading = false;
    });
  }

  showInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kCardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('TrackMind', style: kTitleStyle),
          content: Text('Focus and Flow.\nVersion: 1.0.0', style: kBodyStyle),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: kAccentColor)),
            )
          ],
        );
      },
    );
  }

  showExitDialoge() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kCardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Exit App', style: kTitleStyle),
          content: Text('Are you sure you want to leave?', style: kBodyStyle),
          actions: [
            TextButton(
              onPressed: () async {
                await NoteDatabase.instance.close();
                if (!context.mounted) return;
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
              child:
                  const Text('Yes', style: TextStyle(color: kImportantColor)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No', style: TextStyle(color: kAccentColor)),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        showExitDialoge();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TrackMind'),
          actions: [
            IconButton(
              onPressed: showInfo,
              icon: const Icon(Icons.info_outline_rounded),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: isloading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: kAccentColor,
                  ),
                )
              : noteslist == null || noteslist!.isEmpty
                  ? DefaultTile(size: size)
                  : MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      itemCount: noteslist!.length,
                      padding: const EdgeInsets.only(top: 10, bottom: 80),
                      itemBuilder: (context, index) {
                        final note = noteslist![index];
                        String formattedDateTime =
                            DateFormat('d MMM, yyyy').format(note.createdTime);

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => ScreenAdd(note: note),
                            ));
                          },
                          child: Hero(
                            tag: 'note_${note.id}',
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: note.isImportant
                                      ? kImportantColor.withValues(alpha: 0.15)
                                      : kCardColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: note.isImportant
                                        ? kImportantColor.withValues(alpha: 0.3)
                                        : Colors.white.withValues(alpha: 0.1),
                                    width: 1,
                                  ),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (note.isImportant)
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 8),
                                        child: Icon(Icons.star_rounded,
                                            color: kImportantColor, size: 20),
                                      ),
                                    Text(
                                      note.title,
                                      style: kTitleStyle.copyWith(fontSize: 18),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      note.description,
                                      style: kMutedStyle,
                                      maxLines: 6,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          formattedDateTime,
                                          style: kMutedStyle.copyWith(
                                              fontSize: 10),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            await NoteDatabase.instance
                                                .delete(note.id!);
                                            if (!context.mounted) return;
                                            refreshDB();
                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(SnackBar(
                                                backgroundColor: kCardColor,
                                                content: const Text(
                                                    'Note cleared',
                                                    style: TextStyle(
                                                        color: kTextColor)),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ));
                                          },
                                          child: const Icon(
                                              Icons.delete_outline_rounded,
                                              color: kTextMutedColor,
                                              size: 18),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ScreenAdd()),
            );
          },
          child: Container(
            height: 56,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_rounded, color: Colors.black, size: 24),
                SizedBox(width: 8),
                Text(
                  'New Note',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
