import 'package:Mynotes/services/auth/auth_service.dart';
import 'package:Mynotes/services/crud/notes_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/routes.dart';
import '../enums/menu_action.dart';

class Notes_View_State extends StatefulWidget {
  const Notes_View_State({super.key});

  @override
  State<Notes_View_State> createState() => _Notes_View_StateState();
}

class _Notes_View_StateState extends State<Notes_View_State> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;
  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Notes'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      await AuthService.firebase().logout();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute, (route) => false);
                    }
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text('Logout'),
                  ),
                ];
              },
            ),
          ],
        ),
        body: FutureBuilder(
            future: _notesService.getOrCreateUser(email: userEmail),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return StreamBuilder(
                      stream: _notesService.allNotes,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Text('Waiting for all notes...');
                          default:
                            return const CircularProgressIndicator();
                        }
                      });

                  const Text('Your Texts are loading', style: TextStyle());
                default:
                  return const CircularProgressIndicator();
              }
            }));
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sign Out'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Logout'),
            )
          ],
        );
      }).then((value) => value ?? false);
}
