import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:faker/faker.dart';
void main() {
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey)
        ),
        home: MyHomePage(),
      ),
      );

    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     // This is the theme of your application.
    //     //
    //     // TRY THIS: Try running your application with "flutter run". You'll see
    //     // the application has a purple toolbar. Then, without quitting the app,
    //     // try changing the seedColor in the colorScheme below to Colors.green
    //     // and then invoke "hot reload" (save your changes or press the "hot
    //     // reload" button in a Flutter-supported IDE, or press "r" if you used
    //     // the command line to start the app).
    //     //
    //     // Notice that the counter didn't reset back to zero; the application
    //     // state is not lost during the reload. To reset the state, use hot
    //     // restart instead.
    //     //
    //     // This works for code too, not just values: Most code changes can be
    //     // tested with just a hot reload.
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
    //     useMaterial3: true,
    //   ),
    //   home: const MyHomePage(title: 'Flutter Demo Home Page'),
    // );
  }
}

class MyAppState extends ChangeNotifier{
  var current = WordPair.random();
  void getChange(){
        current = WordPair.random();
        notifyListeners();
  }
}

class MyHomePage extends StatelessWidget{ 
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>(); 
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, 
        elevation: 1.0,
        backgroundColor: Colors.blue,
        title: Text("App Bar No.1"),
      ),
      body:
        Column(
          children: [ 
            TextFieldRow(),
            BodyWidget(appState: appState),
          ],
        ));
  }}

class TextFieldRow extends StatefulWidget{
  State<TextFieldRow> createState() => _TextFieldRowState(); 
}
class _TextFieldRowState extends State<TextFieldRow>{
  Faker faker = Faker();
  String word = "";
  String resultArea = "Tries: 0/5";
  int mistakeCounter = 0;
  List<FocusNode> _focusNodes = List.empty(growable: true);
  List<TextEditingController> _controllers = List.empty(growable: true);
  List<Expanded> wordInputList = List.empty(growable: true);
  List<bool> _inputsEnabledState = List.empty(growable: true);
  @override
  void dispose(){
    for (var focusNode in _focusNodes){
      focusNode.dispose();
    }
    for(var controllerNode in _controllers){
      controllerNode.dispose();
    }
    super.dispose();
  }

  void checkStringMatch(){
    String answerText="";
    int _index = 0;
    for(var (controllerNode) in _controllers){
      if (controllerNode.text == ""){
          return;
      }

      if(controllerNode.text == this.word.substring(_index, _index+1).toLowerCase()){
        _inputsEnabledState[_index] = false; 
      }
      answerText+=controllerNode.text;
    _index++;
    }

    if(answerText != word.toLowerCase()){
        this.mistakeCounter++;
    }
    if(this.mistakeCounter == 5){
      this.resultArea = "Game Over!";
    }
    else{
      this.resultArea = 'Tries: ${mistakeCounter}/5';
    }
  }
  void changeState(){
    setState(() {
      this.word = this.faker.animal.name();
      mistakeCounter = 0; 
      for (var letter in _controllers) {
        letter.clear();
      }
    });
  }

  void createControllers(){
    this.word = faker.animal.name();
    print(word);
    this._focusNodes = List.generate(word.length, (index) => FocusNode());
    this._controllers = List.generate(word.length, (index) => TextEditingController()); 
    this._inputsEnabledState = List.generate(word.length, (index) => true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createControllers(); 
  }

 @override
  Widget build(BuildContext context) {
    wordInputList =  List.generate(this.word.length, (index) => Expanded(child: Padding(padding: const EdgeInsets.all(3.0),
    child: TextField(maxLength: 1, textAlign: TextAlign.center, focusNode: _focusNodes[index], controller: _controllers[index],
    enabled: _inputsEnabledState[index],
    decoration: InputDecoration(fillColor: _inputsEnabledState[index] ? Colors.greenAccent: Colors.blueAccent),
    onChanged: (value){
      if(value.isNotEmpty){
        _focusNodes[index].unfocus();
        if(index < word.length-1){
          FocusScope.of(context).requestFocus(_focusNodes[index+1]);
        }
      }
    },
    )),));

    // TODO: implement build
    return Column(
      children: [
      Center(
        child: Card(child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(this.resultArea, style: TextStyle(fontSize: 32.0),),
        ), 
        color: (this.mistakeCounter == 5)? Colors.redAccent : Colors.greenAccent, 
        ),
      ),
      Row(
          children: wordInputList),
      ElevatedButton(onPressed: () => checkStringMatch(), child: Text("Check")),
      TextButton(onPressed: ()=> changeState(), child: Text("Refresh"))
    ]);
  } 
}

class BodyWidget extends StatelessWidget {
  const BodyWidget({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    return Expanded(
     child: 
         Center(
         child:
             Column( 
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                     Text("A random idea", style: TextStyle(fontSize: 30),),
                     SizedBox(height: 10,),
                     Text(appState.current.asPascalCase, style: TextStyle(fontSize: 26)),
                     SizedBox(height: 10),
                     ElevatedButton(
                         style: ButtonStyle(minimumSize: MaterialStateProperty.all(Size(32, 32))),
                         onPressed: (){
                             appState.getChange();
                         },
                         child: Text("Next", style: TextStyle(fontSize: 21),),
                     )
                 ],) 
        ));
  }
}

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  //final String title;

  //@override
  //State<MyHomePage> createState() => _MyHomePageState();


/*class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.primary,
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}*/