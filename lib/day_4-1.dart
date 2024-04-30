import "package:faker/faker.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

void main(List<String> args) {
  runApp(MyApp()); 
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Day 4.1",
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent)),
      home: MyHomePage()
    
    );
    
  }
}

class MyHomePage extends StatelessWidget{
  @override
  Widget build (BuildContext context){
    return  Scaffold(
      // appBar: SliverAppBar(
      //   p
      //   title: Text("Day 4.1"),
      //   centerTitle: true,
      //   
      //   leading: 
      //     IconButton(onPressed: ()=>{}, icon: Icon(Icons.navigate_next)), 
      //
      // ),
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverAppBar(
          backgroundColor: Theme.of(context).primaryColor,
            expandedHeight: 200,
            floating: true,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text("Day 3"),
              ),
            pinned: true,
            leading: Icon(Icons.navigate_before)),

          SliverList.list(children: List.generate(20, (index) => Container(
            height: 90,
          
            color: Colors.teal[(index*100-1)],
            child: Container(
              color: Colors.teal[(index+100-1)],
              child: Center(child: Text(faker.address.city()))),
          ))),
          SliverList.builder(
            itemCount: 10,
            itemBuilder: (context, index) => 
              Card(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child:Text(faker.animal.name()))
                  ],
                  )
              )
          )
        //Row(
          //children: [Text("N")],
          //List.generate(10, (index) => Card(child: Text(faker.color.commonColor()))),
        //)
        ],
      ),
      
    );
  } 
}


