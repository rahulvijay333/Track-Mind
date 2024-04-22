import 'dart:developer';

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
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) {
            return const Screenhome();
          },
        ));
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: widget.note != null ? const Text('Note') : const Text('Note'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.transparent.withOpacity(0.1),
                    border: Border.all(color: Colors.black, width: 0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        color: const Color.fromRGBO(255, 255, 255, 1)
                            .withOpacity(0.4),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            maxLines: null,
                            cursorColor: Colors.black,
                            controller: _titleController,
                            decoration: const InputDecoration(
                              hintText: 'Title',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      space15,
                      Container(
                        color: Colors.white.withOpacity(0.4),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: _descriptionController,
                            maxLines: null,
                            cursorColor: Colors.black,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Add note',
                            ),
                          ),
                        ),
                      ),
                      space15,
                    ],
                  ),
                ),
              ),
              space15,
              ChoiceChip(
                // checkmarkColor: Colors.amber,
                selectedColor: Colors.red,
                label: Text(
                  'Important',
                  style: TextStyle(
                      color: !isImportant ? Colors.black : Colors.white),
                ),
                selected: isImportant,

                onSelected: (value) {
                
                  if (isImportant) {
                    setState(() {
                      isImportant = false;
                    });

                    
                  } else {
                    setState(() {
                      isImportant = true;
                    });
                    
                  }
                },
              ),
              space15,
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_titleController.value.text.isNotEmpty &&
                          _descriptionController.text.isNotEmpty) {
                        if (widget.note != null) {
                          final note = Note(
                              id: widget.note!.id,
                              isImportant: isImportant,
                              number: 10,
                              title: _titleController.value.text,
                              description: _descriptionController.text,
                              createdTime: DateTime.now());
                          final chamges =
                              await NoteDatabase.instance.update(note);

                      
                        } else {
                          final note = Note(
                              isImportant: isImportant,
                              number: 10,
                              title: _titleController.value.text,
                              description: _descriptionController.text,
                              createdTime: DateTime.now());
                          await NoteDatabase.instance.create(note);
                        }

                        FocusScope.of(context).unfocus();
                        // Navigator.of(context).pop();

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) {
                            return const Screenhome();
                          },
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: const Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(
                                bottom: size.height * 0.10,
                                left: 25,
                                right: 25),
                            content: const Text(
                                'notes with empty fields not saved')));
                      }
                    },
                    child: widget.note != null
                        ? const Text('update')
                        : const Text('save')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
