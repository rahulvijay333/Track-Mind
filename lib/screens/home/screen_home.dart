import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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

  showInfo(){
    showDialog(context: context, builder: (context) {
      return const AlertDialog(
        title: Text('TrackMind'),content: Text('Version: 1.0.0'),
      );
    },);
  }

  showExitDialoge() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Are you sure ?',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
          actions: [
            TextButton(
                onPressed: () async {
                  await NoteDatabase.instance.close();

                  Navigator.of(context).pop();
                  SystemNavigator.pop();
                },
                child:
                    const Text('Yes', style: TextStyle(color: Colors.black))),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.black),
                ))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        showExitDialoge();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('TrackMind'),
          centerTitle: true,
          actions: [IconButton(onPressed: () {

            showInfo();
            
          }, icon: const Icon(Icons.info))],
        ),
        body: isloading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 0.1,
                ),
              )
            : noteslist == null || noteslist!.isEmpty
                ? DefaultTile(size: size)
                : Column(
                    children: [
                      // space15,
                      ClipRRect(
                        child: SizedBox(
                          height: size.height * 0.80,
                          child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              itemBuilder: (context, index) {
                                String formattedDateTime =
                                    DateFormat('d MMMM y, hh:mm a')
                                        .format(noteslist![index].createdTime);
                                return Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      //-----------------------------------------------------navigation
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) {
                                          return ScreenAdd(
                                            note: noteslist?[index],
                                          );
                                        },
                                      ));
                                    },
                                    child: Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 3.0),
                                      decoration: BoxDecoration(

                                      
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black,
                                              blurRadius: 6.0,
                                              spreadRadius: 1.0,
                                              offset: Offset(1.0,
                                                  1.0), // shadow direction: bottom right
                                            )
                                          ],
                                          color: noteslist![index].isImportant ? Colors.red.shade100 : Colors.white,
                                          border: Border.all(
                                              color: Colors.black, width: 0.5),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: size.width * 0.85,
                                      // height: size.height * 0.20,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        //--------------------------------------------------
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              noteslist![index].title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            space5,
                                            Text(formattedDateTime,
                                                style: const TextStyle(
                                                    color: Colors.grey)),
                                            space10,
                                            Text(noteslist![index].description,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                .bodyLarge),
                                            Row(
                                              children: [
                                                const Spacer(),
                                                IconButton(
                                                    padding: EdgeInsets.zero,
                                                    onPressed: () async {
                                                      await NoteDatabase
                                                          .instance
                                                          .delete(
                                                              noteslist![index]
                                                                  .id!);

                                                      noteslist =
                                                          await NoteDatabase
                                                              .instance
                                                              .readAllNotes();

                                                      ScaffoldMessenger
                                                              .of(context)
                                                          .showSnackBar(SnackBar(
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          3),
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                              margin: EdgeInsets.only(
                                                                  bottom:
                                                                      size.height *
                                                                          0.10,
                                                                  left: 25,
                                                                  right: 25),
                                                              content: const Text(
                                                                  'note deleted')));

                                                      setState(() {});
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: 10,
                                  ),
                              itemCount: noteslist?.length ?? 0),
                        ),
                      ),
                      const Spacer(),
                      //------------------------------------------------add note button
                      SizedBox(
                        width: size.width * 0.6,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              //------------------------------------------------navigation
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (ctx1) {
                                    return const ScreenAdd();
                                  },
                                ),
                              );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Icon(Icons.add), Text('Add note')],
                            )),
                      ),
                      space10
                    ],
                  ),
      ),
    );
  }
}
