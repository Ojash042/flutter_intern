import "dart:math";

import "package:faker/faker.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: "Assessment 4",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:MyHomePage()
    );
    // TODO: implement build
  }
}
class MyHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 3,
      initialIndex: 2,
      child:Scaffold(
      appBar: AppBar(
        title: const Row(children: [Text("Assessment 4"), Icon(Icons.javascript)],),
        centerTitle: true,
        bottom: const TabBar(tabs: <Widget>[
          Tab(text: "Day 2",),
          Tab(text: "Day 3",),
          Tab(text: "Day 4",),
        ]),
      ),

      body: TabBarView(
        children: <Widget>[
        Day2Component(),
        Day3Component(),
        Day4Component(),
        ],
      ),
    ));
  }
}

class Day3Component extends StatefulWidget{

  bool showMore = false;

  Day3Component({super.key});
  

  State<Day3Component> createState()=> _Day3ComponentState();
}

class _Day3ComponentState extends State<Day3Component>{

void changeSetShowMore(){
    setState(() {
      widget.showMore = !widget.showMore; 
      print(widget.showMore); 
    });
    }

Map<String, List<String>> mapper = {
  "ImageSrcs": [
    "https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fthewowstyle.com%2Fwp-content%2Fuploads%2F2015%2F01%2Fnature-images.jpg&f=1&nofb=1&ipt=07fad20f7c5599fbf2b027fb8b21c9384bdf8db52f4ebbb3769482e107950f21&ipo=images"
    "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse2.mm.bing.net%2Fth%3Fid%3DOIP.IppCYyeRCjYD7fAVM2ABKwHaE8%26pid%3DApi&f=1&ipt=c44a628dd4adb3d5135b355737ce039b34df40c8c51e594611e4bfcff93b2b68&ipo=images",
    "https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fthewowstyle.com%2Fwp-content%2Fuploads%2F2015%2F01%2Fnature-images.jpg&f=1&nofb=1&ipt=07fad20f7c5599fbf2b027fb8b21c9384bdf8db52f4ebbb3769482e107950f21&ipo=images",
    "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.bPBCgvp9N0SUbVYJnBg2IQHaEo%26pid%3DApi&f=1&ipt=420ac2e9093e3cdfce1c6092780485c1bf2152679f33cd9a5ba6efcc8d02cb57&ipo=images",
    "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fjooinn.com%2Fimages%2Fnature-319.jpg&f=1&nofb=1&ipt=f9b97b21e2069f341261e24c0cecf8217a9f1f4e299a851ce732664ebe272d52&ipo=images",
    "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.aj48y9KXH2xOZ46X9NvKJQHaEo%26pid%3DApi&f=1&ipt=48ae23b97eee2a69d5d6a77d193d46c79e4419ae32d493754a8c249dec923c24&ipo=images",
    "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.aj48y9KXH2xOZ46X9NvKJQHaEo%26pid%3DApi&f=1&ipt=48ae23b97eee2a69d5d6a77d193d46c79e4419ae32d493754a8c249dec923c24&ipo=images",
    "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.aj48y9KXH2xOZ46X9NvKJQHaEo%26pid%3DApi&f=1&ipt=48ae23b97eee2a69d5d6a77d193d46c79e4419ae32d493754a8c249dec923c24&ipo=images",
    "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.TRNXjrKQXvevPz7MTXWbtgHaFj%26pid%3DApi&f=1&ipt=27ec4c692e2be6b312c147dca5b657c0c3153f10ae8b0d69272b3b62fd82b1ab&ipo=images",
    "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.nWZT1ADubNGRfC6JXYQKuwHaFA%26pid%3DApi&f=1&ipt=337a49d11ec1e409165ed1956ce6d0cd75bb2b11ee76c17794dfeeca88a13693&ipo=images",
    "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.nWZT1ADubNGRfC6JXYQKuwHaFA%26pid%3DApi&f=1&ipt=337a49d11ec1e409165ed1956ce6d0cd75bb2b11ee76c17794dfeeca88a13693&ipo=images",
    ],
    "ImageTitle":[
      "Image 1",
      "Image 2",
      "Image 3",
      "Image 4",
      "Image 5",
      "Image 6",
      "Image 7",
      "Image 8",
      "Image 9",
      "Image 10"
    ],
    "ImageDescription":[
      "Description 1",
      "Description 2",
      "Description 3",
      "Description 4",
      "Description 5",
      "Description 6",
      "Description 7",
      "Description 8",
      "Description 9",
      "Description 10"
    ] 
};

@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              height: 512,
              child: VerticalList(mapper: mapper,onPressed: () => {changeSetShowMore()}, showMore: widget.showMore,),
              
            ),
              Container(
                height: 512,
                child: HorizontalList(mapper: mapper)),
              Container(child: WrapList()),
            ]
              )
            ,
          )
        );
      //   Row(
      //   children: [
      //     Expanded(
      //       child: VerticalList(mapper: mapper, onPressed: () => {changeSetShowMore()}, showMore: widget.showMore)),
      //     Expanded(child: HorizontalList(mapper: mapper,)),
      //     Expanded(child: WrapList())
      //   ],
      // )
      
      
      
  }
}

class WrapList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _WrapListState();
}
class _WrapListState extends State<WrapList>{
bool showMore = false;
String btnText = "Show More";
List<IconData> icons= [Icons.back_hand,Icons.css, Icons.javascript ,Icons.safety_check,Icons.vaccines,Icons.account_balance_wallet_sharp, Icons.wallet_giftcard, Icons.place, Icons.agriculture, Icons.one_k_rounded];
List<String> iconText = ["Text1", "Text2", "Text3", "Text4", "Text5", "Text6", "Text6", "Text7", "Text8", "Text9", "Text10"];
void _changeShowMore(){
  setState(() {
    showMore = !showMore;
    btnText = showMore? "Show Less": "Show More";
  });
}
@override
  Widget build(BuildContext context) {
    return
    // TODO: implement build
    Wrap(
      direction: Axis.horizontal,
      children: [
      Wrap(
        direction: Axis.horizontal ,children: List.generate(showMore? 10: 5, (index) => Card( child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(iconText[index]),
          Icon(icons[index]),
      ],
    )),)),
    Center(child:TextButton(onPressed: _changeShowMore, child: Text(btnText))),
    ],
    );
  }

}

class HorizontalList extends StatelessWidget {
  const HorizontalList({
    super.key,
    required this.mapper,
  });

  final Map<String, List<String>> mapper;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(scrollDirection: Axis.horizontal,
    itemCount: 10,
    itemBuilder: (context, index) => (
      Container(
        height: 1024,
        width: 512,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ImageAndDescriptionContainer(imageSrc: mapper["ImageSrcs"]![index], imageTitle: mapper["ImageTitle"]![index], imageDescription: DateTime.now().toString(),),
        ),
    )
    )
    );
  }
}


class VerticalList extends StatefulWidget{
  final Map<String, List<String>> mapper;
  final VoidCallback onPressed;
  final bool showMore;

  State<VerticalList> createState() => _VerticalListState();
  VerticalList({required this.mapper, required this.onPressed, required this.showMore});
}

class _VerticalListState extends State<VerticalList>{
  bool showMore = false;
  String btnText = "Show More";
  
  @override
  void didUpdateWidget(covariant VerticalList oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    setState(() { 
      btnText = widget.showMore ? "Show Less": "Show More";
    });
  } 
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(

      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child:  ListView.builder(scrollDirection: Axis.vertical,
        itemCount: widget.showMore? 10: 5,
        itemBuilder: (context, index) => (
          Card(
            margin: const EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: ImageAndDescriptionContainer(imageSrc: widget.mapper["ImageSrcs"]![index], imageTitle: widget.mapper["ImageTitle"]![index], imageDescription: widget.mapper["ImageDescription"]![index],),
            ),
          )
        )
        )),
      
      TextButton(onPressed: widget.onPressed, 
            child: Text(btnText))],
    );
  }
}
class ImageAndDescriptionContainer extends StatelessWidget{
  String imageSrc;
  String imageTitle;
  String imageDescription;
  ImageAndDescriptionContainer({required this.imageSrc, required this.imageTitle, required this.imageDescription});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Text(imageTitle, style: Theme.of(context).textTheme.displayLarge),
        Image.network(imageSrc, width: 512, height: 256),
        Text(imageDescription, style: Theme.of(context).textTheme.bodyMedium,),
      ],
    );
  }
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


class Day2Component extends StatefulWidget { 
State<StatefulWidget> createState() => _Day2ComponentState(); 

}


class _Day2ComponentState extends State<Day2Component>{
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

// class Day2Component extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Center(child: Text("Day 3"));
//   }
// }


class Day4Component extends StatefulWidget{
  List<Color> colors = List.generate(20, (index) => Color.fromARGB(Random().nextInt(255), 
    Random().nextInt(255), 
    Random().nextInt(255),
    Random().nextInt(256)));
  List<Color> colorsInner = List.generate(20, (index) => Color.fromARGB(Random().nextInt(255), 
    Random().nextInt(255), 
    Random().nextInt(255),
    Random().nextInt(256)));

  List<String> textString = List.generate(20, (index) => faker.company.name());
  bool showMore = false;
  State<Day4Component> createState() => _Day4ComponentState();
}

class _Day4ComponentState extends State<Day4Component>{
String btnText = "Show More";
void changeShowMore(){
  setState(() { 
    widget.showMore = !widget.showMore;
    btnText = widget.showMore? "Show Less": "Show More";
  });
}

@override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
        

    // TODO: implement build
    return 
    Column(
      children: [
        Expanded(
          child: GridView.count(
            childAspectRatio: 1/0.2,
            crossAxisCount: 2, primary: false,
          padding: const EdgeInsets.all(12),
          crossAxisSpacing: 10,
          children: List.generate(5, (index) => 
          Card(borderOnForeground: true,
          color: Colors.lime ,
          child: Center(child: Text(widget.textString[index])),
          )
          ),
          ),
        ),
        Expanded(
          child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1/ 0.4,
            crossAxisCount: 2), 
            itemCount: widget.showMore ? widget.textString.length : 5,
            itemBuilder: (count,index) =>
            SizedBox(
            height: 50,
            width: 50,
              child: Card(  
                elevation: 10,
                shadowColor: Colors.black.withOpacity(1),
                color: widget.colors[index],
                   child: Container(
                   color: widget.colorsInner[index],
                   height: 30,
                   width: 30,
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                        Text(widget.textString[index]),
                       ],
                      ),
                   ),
                 ),
            )),
        ),
        const Divider(thickness: 10, color: Colors.black,),
        Row(
          children: [

          const SizedBox(
            width: 240,
            height: 60,
          ),
        Center(
          child: TextButton(child: Text(btnText), onPressed: () {
          changeShowMore();
        },),
      )],
     ),

      
      ],
    )

      // Container(
      //   height: 124,
      //   width: 124,
      //   child: Padding(padding: EdgeInsets.all(8.0),
      //   child:  
      //       // child: Row(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //
        //     Text(textString[index]),
        //     
        //   ],
        // )
        
      
      // Text(index.toString()),
      // const SizedBox(
      //   width: 20,
      //   height: 20,
      // )
      

    /*Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
        Container(
      
      height: 512,
      width: 1024, 
      decoration: const BoxDecoration(
        color: Colors.blue,
        boxShadow: <BoxShadow>[

        BoxShadow(

          color: Colors.black38,
          blurRadius: 30.0,
          offset: Offset(0.0,0.75),
        )
        ], 
      ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Text("Title",style: textTheme.headlineLarge,), 
      Text("Subtitle", style: textTheme.titleMedium,),
      

    ]), 
    ),
        ])*/;
  }
}