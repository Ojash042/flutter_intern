import 'package:flutter/material.dart';
import 'package:flutter_intern/pdf_project/misc.dart';

void main(List<String> args) {
  runApp(App());
}

enum PDFOptions{none,network, localFile}

class App extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}
class _AppState extends State<App>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage() ,
    );
  }
}

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() {
    return _HomePageState();
  } 
}

class _HomePageState extends State<HomePage>{
  PDFOptions? selectedOption;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CommonAppBar(),
    body: SingleChildScrollView(child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PopupMenuButton<PDFOptions>(
          child: Text("Choose an option"),
          initialValue: PDFOptions.none,
          onSelected: (PDFOptions options){
            setState(() {
              selectedOption = options; 
            });
          },
          itemBuilder: (context){
            return <PopupMenuEntry<PDFOptions>>[
              const PopupMenuItem<PDFOptions>(child: Row(children: [Icon(Icons.file_open), Text("Open a file")],), value: PDFOptions.localFile,),  
              const PopupMenuItem<PDFOptions>(child: Row(children: [Icon(Icons.file_open), Text("Open a file")],), value: PDFOptions.localFile,),
              ];
        }),
        ElevatedButton(onPressed: (){}, child: const Text("Read ")),
        ElevatedButton(onPressed: (){}, child: const Text("we")),
        ],
    ),),
    );
  }
}