import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_intern/api_project/misc.dart';
import 'package:flutter_intern/api_project/models.dart';
import 'package:flutter_intern/api_project/posts_details_page.dart';
import 'package:flutter_intern/api_project/user_details.dart';
import 'package:http/http.dart' as http;

void main(List<String> args) {
  runApp(App());
}

class App extends StatelessWidget{

  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent)),
    routes: {
      "/": (context) => const HomePage(),
    },
    initialRoute: '/',
    onGenerateRoute: (settings){
      if(settings.name!.startsWith('/posts/')){
        var postId = settings.name!.split('/').last;
        return MaterialPageRoute(builder: (context) => PostPageDetails(postId: int.parse(postId),));
      }
      else if(settings.name!.startsWith('/users/')){
        var userId = settings.name!.split('/').last;
        return MaterialPageRoute(builder: (context) => UserDetailsPage(id: userId));
      }
      else{
        return null;
      }

    },
    );
  }
}


class HomePage extends StatefulWidget{

  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

}

class _HomePageState extends State<HomePage>{

  List<Posts> posts = List.empty(growable: true);

  Future<void> getAllPosts() async{
   var response = await http.get(Uri.parse("https://dummyjson.com/posts"));
   if(response.statusCode == 200){
    setState(() {
      Iterable decoderPosts = jsonDecode(response.body)["posts"];
      posts = decoderPosts.map((e) => Posts.fromJson(e)).toList();
    });
   }
   return; 
  }

  @override
  void initState() {
    super.initState();
    getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const CommonAppBar(),
      body: SingleChildScrollView(
        child: Column(
        children: posts.map((e) => GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, '/posts/${e.id}');
        },
          child: Card(
            child: Container(
            padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Text(e.title ?? "", style: Theme.of(context).textTheme.bodyLarge,),
                const SizedBox(height: 10,),
                Row(children: e.tags!.map((tag) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(tag ?? ""),
                  ),),
                )).toList(),),
                const SizedBox(height: 10,),
                Text(e.body ?? ""),
                const SizedBox(height: 10,),
                Row(children: [Icon(Icons.thumb_up_alt_sharp, color: Theme.of(context).highlightColor,), const SizedBox(height: 10,), Text("${e.reactions > 0 ? e.reactions : "No one"} ${e.reactions == 0 ? "" : e.reactions == 1 ? "Person" : "People"} liked this")],),
                const SizedBox(height: 20)
              ],),
            ),
          ),
        )).toList()
        ),
      ),
    );
  } 
}