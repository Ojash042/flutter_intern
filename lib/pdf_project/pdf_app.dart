import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_intern/pdf_project/misc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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
      debugShowCheckedModeBanner: false,
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


class PDFViewPage extends StatefulWidget{
  
  final String? filePath;
  const PDFViewPage({super.key, this.filePath, isNetwork = false});
  @override
  State<StatefulWidget> createState() {
    return _PDFViewPageState();
  }
}

class _PDFViewPageState extends State<PDFViewPage>{
  int page = 0;
  int total = 0;
  bool isReady = false;
  late PDFViewController _controller;


  @override
  void initState() {
    super.initState();
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Stack(
      children: [
        LayoutBuilder(
          builder: (builder, context) {
            final sliderWidth = context.maxWidth /10;
            return Stack(
              children: [
                Positioned.fill(
                  child: PDFView(
                    filePath: widget.filePath,
                    enableSwipe: true,
                    autoSpacing: true,
                    pageSnap: false,
                    onRender: (_pages){ setState(() {
                     isReady = true;
                     page = _pages!;
                    });},
                    onViewCreated: (controller) => _controller = controller,
                    onPageChanged: (_page, _total){
                      setState(() {
                        setState(() {
                          page = _page!+1; 
                          total = _total ?? 0;
                        });
                      });
                    } ,
                  ),
                ),
              Align(alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 8),
                height: 30, width: 60,
              child:Text('$page / $total'), 
              ),),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: sliderWidth ),
                      child: Slider(
                      thumbColor: Colors.white,
                      label: page.toString(),
                      activeColor: Colors.transparent,
                      inactiveColor: Colors.transparent,
                        min: 0.0,
                        value: page.toDouble(),
                        max: total.toDouble(),
                        onChanged: (val){
                          setState((){
                          page = val.toInt();
                        }); 
                        Future.delayed(const Duration(milliseconds: 100), (){
                          _controller.setPage(page);
                        });
                        } 
                      ),
                    ),
                  ),
                ),
              )
              ],
            );
          }
        ),

        // Align(alignment: Alignment.bottomRight, child: Container(
        //   child: Text('${page ==null ? 0: page!}/$total')),),
      ],
    ),);
  }
}

enum LoadingStates {initial, loading, success}

class _HomePageState extends State<HomePage>{
  PDFOptions? selectedOption;
  String? pdfUrl;
  LoadingStates isLoading = LoadingStates.initial;
  TextEditingController urlController = TextEditingController();
  RegExp pdfRegex = RegExp(r'^(?:https?://).*\.pdf$');
  bool urlError = false;

  void openPDF() async{
    File file;
    FilePickerResult? picker = await FilePicker.platform.pickFiles( type: FileType.custom, allowedExtensions: ['pdf']);
    if(picker !=null){
      file = File(picker.files.single.path!);
      print("EEEEEEREJRKKJRKR");
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PDFViewPage(filePath: file.path,)));
      //Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  PDFView(filePath: file.path,)));
    }
  }

  void downloadPdf(url) async{
    setState(() {
      isLoading = LoadingStates.loading;
    });
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final filename = url.split('/').last;
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$filename');
    File urlFile = await file.writeAsBytes(bytes);
    setState(() {
      isLoading = LoadingStates.success;
    }); 
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PDFViewPage(filePath: urlFile.path, isNetwork: true,)));
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CommonAppBar(),
    body: SingleChildScrollView(child: 
    isLoading == LoadingStates.loading? const Center(child: CircularProgressIndicator(),): Center(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 90,),
            ElevatedButton(onPressed: (){openPDF();}, child: const Text("Open a pdf file.")),
            const SizedBox(height: 90,),
        
            SizedBox(
              width: MediaQuery.of(context).size.width /1.2,
              child: TextField(decoration:InputDecoration(
                errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
                error: urlError ? const Text("Error! Url is not valid"): null,
                hintText: "Enter url of pdf file"), controller: urlController,)),
            const SizedBox(height: 30,),
        
            ElevatedButton(onPressed: (){
              if(!pdfRegex.hasMatch(urlController.text)){
                urlError = true;
                return;
              }
              urlError = false;
              downloadPdf(urlController.text);}, child: const Text("Fetch a pdf from a network.")), 
            ],
        ),
      ),
    ),),
    );
  }
}