import 'package:Mynotes/services/auth/auth_service.dart';
import 'package:Mynotes/services/crud/notes_service.dart';
import 'package:flutter/material.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
   DatabaseNote? _note;
   late final NotesService _notesService;
   late final TextEditingController _textEditingController;

   @override
   void initState(){
     _notesService=NotesService();
     _textEditingController=TextEditingController();
     super.initState();
   }
   void _textControllerListener()async {
     final note=_note;
     if(note==null){
       return;
     }
     final text = _textEditingController.text;
     await _notesService.updateNotes(note: note, text: text);
   }
   void _setUpTextControllerListener(){
     _textEditingController.removeListener(_textControllerListener);
     _textEditingController.addListener(_textControllerListener);

   }

   Future<DatabaseNote> createNewNote()async{
     final exisitingNote=_note;
     if(exisitingNote!=null)return exisitingNote;
     final currentUser=AuthService.firebase().currentUser!;
     final email=currentUser.email!;
     final owner=await _notesService.getUser(email: email);
     return await _notesService.createNote(owner: owner);
   }


   void _deleteNoteIfTextEmpty(){
     final note=_note;
     if (_textEditingController.text.isEmpty && note!=null){
       _notesService.deleteNote(id: note.id);
     }
   }
   void _saveNoteIfTextNotEmpty()async{
     final note=_note;
     final text =_textEditingController.text;
     if(note!=null&& text.isNotEmpty){
       await _notesService.updateNotes(note: note, text: text);
     }
   }

   @override
  void dispose() {
    // TODO: implement dispose
     _deleteNoteIfTextEmpty();
     _saveNoteIfTextNotEmpty();
     _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(backgroundColor: Colors.tealAccent,
        title: (const Text('New Note',)

        ),

      ),
      body:
       FutureBuilder(
         future: createNewNote(),
         builder: (context, snapshot){
           switch (snapshot.connectionState){
             case ConnectionState.done:
               _note=snapshot.data;
               _setUpTextControllerListener();
               return TextField(
                 controller: _textEditingController,
                 keyboardType: TextInputType.multiline,
                 maxLines: null,
                 decoration:const InputDecoration(hintText:'Start typing your notes...') ,
               );
             default:
               return const CircularProgressIndicator();
           }
         }
       )

      ,
    );
  }
}







