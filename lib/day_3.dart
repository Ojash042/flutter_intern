import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

void main(){
  runApp(MyApp());
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

class MyHomePage extends StatefulWidget{

  String title;
  bool showMore = false;
  

  MyHomePage({required this.title});
  State<MyHomePage> createState()=> _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

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
      child:(Row(
        children: [
          Expanded(
            child: VerticalList(mapper: mapper, onPressed: () => {changeSetShowMore()}, showMore: widget.showMore)),
          Expanded(child: HorizontalList(mapper: mapper,)),
          Expanded(child: WrapList())
        ],
      )));
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
      Card(
        margin: const EdgeInsets.all(5),
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
    print(imageTitle);
    // TODO: implement build
    return Column(
      children: [
        Text(imageTitle),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Image.network(imageSrc, width: 512, height: 512),
        ),
        Text(imageDescription),
      ],
    );
  }
}