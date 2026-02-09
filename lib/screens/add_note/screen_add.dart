import 'package:flutter/material.dart';
import 'package:track_mind/constants/cons.dart';
import 'package:track_mind/db/notes_db.dart';
import 'package:track_mind/model/note.dart';
import 'package:track_mind/screens/home/screen_home.dart';

class ScreenAdd extends StatefulWidget {
  const ScreenAdd({super.key, this.note});

  final Note? note;

  @override
  State<ScreenAdd> createState() => _ScreenAddState();
}

class _ScreenAddState extends State<ScreenAdd> {
  bool isImportant = false;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
      isImportant = widget.note!.isImportant;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Screenhome(),
        ));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.note != null ? 'Edit Note' : 'New Note'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const Screenhome(),
              ));
            },
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            Hero(
              tag: widget.note != null ? 'note_${widget.note!.id}' : 'new_note',
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: kCardColor,
                    borderRadius: BorderRadius.circular(24),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _titleController,
                          style: kTitleStyle.copyWith(fontSize: 22),
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Title',
                            hintStyle: kTitleStyle.copyWith(
                              fontSize: 22,
                              color: kTextMutedColor.withValues(alpha: 0.5),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                        const Divider(color: Colors.white10, height: 30),
                        TextField(
                          controller: _descriptionController,
                          style: kBodyStyle,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Describe your thoughts...',
                            hintStyle: kBodyStyle.copyWith(
                              color: kTextMutedColor.withValues(alpha: 0.5),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mark as Important', style: kBodyStyle),
                Switch.adaptive(
                  value: isImportant,
                  activeThumbColor: kImportantColor,
                  onChanged: (value) {
                    setState(() {
                      isImportant = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  if (_titleController.text.isNotEmpty &&
                      _descriptionController.text.isNotEmpty) {
                    final note = Note(
                      id: widget.note?.id,
                      isImportant: isImportant,
                      number: 10,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      createdTime: DateTime.now(),
                    );

                    if (widget.note != null) {
                      await NoteDatabase.instance.update(note);
                    } else {
                      await NoteDatabase.instance.create(note);
                    }

                    if (!context.mounted) return;
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const Screenhome(),
                    ));
                  } else {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(
                        backgroundColor: kCardColor,
                        content: Text('Fields cannot be empty',
                            style: TextStyle(color: kTextColor)),
                        behavior: SnackBarBehavior.floating,
                      ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  widget.note != null ? 'Update Note' : 'Save Note',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
