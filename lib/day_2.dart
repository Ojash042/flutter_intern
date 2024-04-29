import 'dart:math';

import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData( 
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ), 
      home: MyHomePage(title: 'Flutter Day 1'),

    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//     final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }


class MyHomePage extends StatefulWidget { 
State<StatefulWidget> createState() => _MyHomePageState(); 

final String title;
MyHomePage({super.key, required String this.title});
}


class _MyHomePageState extends State<MyHomePage>{
String? title;

    IconData _randIcon = Icons.access_alarm;
    String  _randImage ="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimages.pexels.com%2Fphotos%2F236047%2Fpexels-photo-236047.jpeg%3Fcs%3Dsrgb%26dl%3Dclouds-cloudy-countryside-236047.jpg%26fm%3Djpg&f=1&nofb=1&ipt=2e385c69f76bcab1f8aaa2fce1b9e20fbf4561bb0de7e0b861f604af9d859ff3&ipo=images";
    
    void changeContainer(){
      List<IconData> ico = [Icons.access_alarm, Icons.face_2, Icons.g_mobiledata, Icons.network_cell, Icons.location_city];
      List<String> imagesSrcs = [
        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimages.pexels.com%2Fphotos%2F236047%2Fpexels-photo-236047.jpeg%3Fcs%3Dsrgb%26dl%3Dclouds-cloudy-countryside-236047.jpg%26fm%3Djpg&f=1&nofb=1&ipt=2e385c69f76bcab1f8aaa2fce1b9e20fbf4561bb0de7e0b861f604af9d859ff3&ipo=images",
        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse4.mm.bing.net%2Fth%3Fid%3DOIP.-IUUOpvVZZtw4Gz09Q-TFgHaE8%26pid%3DApi&f=1&ipt=b6c4dc49d756d78ca0a0f6762b110091ac9b104f066f3eee31a2e26d4394ef40&ipo=images",
        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse4.mm.bing.net%2Fth%3Fid%3DOIP.kmHWoAWrqETOGg63B-nYhwHaJ3%26pid%3DApi&f=1&ipt=286f7e34cc1f6e7ae0585b0ddebc6b9b0132ef816805c022cc0d6ab41c2f45b8&ipo=images",
        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse2.mm.bing.net%2Fth%3Fid%3DOIF.5TC%252f7dYWE9Sv%252fE9Mil%252feLg%26pid%3DApi&f=1&ipt=f19c230fd7a18599c12a80d90dca9543ed65e5b741adc425ce8ec3de8ebf289f&ipo=images",
    ]; 
    Random rand = Random();
    setState(() {
      _randIcon = ico[rand.nextInt(ico.length)];
      _randImage = imagesSrcs[rand.nextInt(imagesSrcs.length)];  
    });}

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar( 
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, 
        title: Text("Flutter Day 1"),
      ),
      body: Center( 
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[ 
              ChangingInput(),
              ChangeButtonInput(),
              ImageIconContainer(iconData: _randIcon, image: _randImage),
              FloatingActionInput(onPressed: ()=>changeContainer() ,),
              
            ], ),
        ),),);} 
}

class ChangeButtonInput extends StatefulWidget {  

State<ChangeButtonInput> createState() => _ChangeButtonInputState();
}

class _ChangeButtonInputState extends State<ChangeButtonInput>{
  Color? _randomColor = Colors.white;
  int width = 60;
  void _changeContainer(){
    print(_randomColor);
    setState(() {
      
    _randomColor = Color.fromARGB(Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), Random().nextInt(256)); 
    width =  Random().nextInt(30)*9 + 215;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


@override
  Widget build(BuildContext context) {
    print(width);
    // TODO: implement build 
    return Container(
      width: width.toDouble(),
      color: _randomColor,
      child: TextButton(child: const Text("Change container"), onPressed: _changeContainer,),
    );
  }

}

class ChangingInput extends StatefulWidget{
  State<ChangingInput> createState() => _ChangingInputState();

}
class _ChangingInputState extends State<ChangingInput>{
  FocusNode _focusNode = FocusNode();
  TextEditingController _controller = TextEditingController(); 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode.addListener(() { 
      if(_focusNode.hasFocus){
        var _intRand = Random().nextInt(30);
        var rand = Random();
        var functions = [
        () =>_controller.text  = String.fromCharCodes(List.generate(_intRand, (index) => rand.nextInt(33) + 65)), 
        () => _controller.text = _controller.text.toUpperCase(),
        () => _controller.text = _controller.text.toLowerCase()
        ]; 
        print('${_intRand%3}, ${_intRand}');
        
        _controller.text = functions[_intRand%3].call();
        print(_controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return TextField(
      focusNode: _focusNode,
      controller: _controller, 
    );
  }
}

class ImageIconContainer extends StatefulWidget{
  final IconData iconData;
  final String image;
  ImageIconContainer({required this.iconData, required this.image});

  State<ImageIconContainer> createState() => ImageIconContainerState();
  
}

class ImageIconContainerState extends State<ImageIconContainer>{
    
    @override
  Widget build(BuildContext context) {
  
  
    return Container(child: 
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Image.network(widget.image, width: 512.0, height: 512.0,),
          Icon(widget.iconData),  
        ],),
      )
    );
    // TODO: implement build
    
  }
}

// class FloatingActionInput extends StatefulWidget{
//   State<FloatingActionInput> createState() => FloatingActionInputState();
// }
class FloatingActionInput extends StatelessWidget{

  final VoidCallback onPressed;
  FloatingActionInput({required this.onPressed});
  
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FloatingActionButton(
      child: const Icon(Icons.plus_one),
      onPressed: () => onPressed(),
    );
    
  }
}
