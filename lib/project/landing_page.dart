import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:flutter_intern/project/technical_models.dart' as TModels;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget{
  @override
  State<LandingPage> createState()=> _LandingPageState();
}

class _LandingPageState extends State<LandingPage>{
  late List<UserData> userList;
  late List<TModels.UserPost> userPosts = List.empty(growable: true);
  String? loggedInEmail;
  bool isLoggedIn = false;
  Future<void> getDataFromSharedPrefs() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.getString("user_post");
    String? userDataJson = sharedPreferences.getString("user_data");
    String? userPostJson = sharedPreferences.getString("user_post");

    Iterable decoderUserData =  jsonDecode(userDataJson!);
    Iterable decoderUserPost = jsonDecode(userPostJson!);

    setState(() {  

    loggedInEmail = sharedPreferences.getString("loggedInEmail");

    if(loggedInEmail != null){
      isLoggedIn = true;
    }

    userList =  decoderUserData.map((e) => UserData.fromJson(e)).toList();
    userPosts = decoderUserPost.map((e) => TModels.UserPost.fromJson(e)).toList();
    });
  }

Future<void> addPost(TModels.UserPost userPost) async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? loggedInEmail = sharedPreferences.getString("loggedInEmail");
  String? userPostJson = sharedPreferences.getString("user_post"); 
  Iterable decoderUserPost = jsonDecode(userPostJson!);
  int currentUserId = userList.firstWhere((element) => element.email == loggedInEmail).id; 

  setState(() {
    userPosts = decoderUserPost.map((e) => TModels.UserPost.fromJson(e)).toList();
    userPost.postId = userPosts.length + 1;
    userPost.userId = currentUserId;
    userPosts.add(userPost);

    String editedJson = jsonEncode(userPosts.map((e) => e.toJson()).toList());
    sharedPreferences.setString("user_post", editedJson);

  });
}
  

  Widget createPostModal(BuildContext buildContext){

    int imagesCounter = 0;
    TModels.UserPost userPost = TModels.UserPost();
    List<TModels.PostLikedBy> postLikedBy = List.empty(growable: true);
    List<TModels.Image> images = List.empty(growable: true);
    userPost.postLikedBys = postLikedBy;
    userPost.images = images;
    FToast fToast = FToast();
    bool posted = false;

    List<TextEditingController> imageUrlControllers = List.empty(growable: true);
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    
      return Scaffold(
          body: Center(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: SingleChildScrollView(child: Column(children: [
                    Align(alignment: Alignment.topRight, child: IconButton(onPressed: (){
                      Navigator.pop(context);
                    } , icon: const Icon(Icons.cancel),),),
                    posted ? 
                    const Card(color: Colors.lightGreen, child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 44.0,vertical:14.0),
                      child: Text("Posted"),
                    ),):
                    Container(),
                    const SizedBox(height: 30,),
                    const Text("Create a new Post"),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(hintText: "Post Title"), 
                      onChanged: (value)=>{userPost.title = value},
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: descriptionController,
                      onChanged: (value) => {userPost.description = value},
                      decoration: const InputDecoration(hintText: "Post Description"),),
                    const SizedBox(height: 10,),
                    SizedBox(
                      height: (120 * imagesCounter).toDouble(),
                      width: MediaQuery.of(context).size.height - 40,
                      child: ListView.builder(
                        itemCount: imagesCounter,
                        itemBuilder: (context, index){
                        return Column(children: [
                          const SizedBox(height: 10,),
                          TextFormField(
                            controller: imageUrlControllers.elementAt(index),
                            decoration: const InputDecoration(hintText: "Insert Image Url"),),
                          const SizedBox(height: 10,),
                        ],);
                        }),
                    ),
                    OutlinedButton(onPressed: (){
                      setState(() { 
                        imagesCounter++;                 
                        TModels.Image image = TModels.Image();
                        userPost.images.add(image);
                        imageUrlControllers.add(TextEditingController());
                      });
                    }, child: Text(imagesCounter == 0 ? "Add Image" : "Add More Images")),
                    const SizedBox(height: 10,),

                    /// Add Post button
                    OutlinedButton(onPressed: (){
                      for(int index=0;index<imagesCounter; index++){
                        userPost.images.elementAt(index).id = Random().nextInt(10000) + 1000;
                        userPost.images.elementAt(index).url = imageUrlControllers.elementAt(index).text;
                      }
                      userPost.createdAt = DateTime.now().toIso8601String();
                      addPost(userPost);
                      setState((){
                      posted = true; 
                      titleController.clear();
                      descriptionController.clear();
                      for(var controller in imageUrlControllers){
                        controller.clear();
                      }
                      });
                      fToast.init(context);
                      
                      },
                       child: const Text("Add Post"))
                    ],)),
                  );
                }
              ),
            ),
          );
  }

  @override
  void initState() {
    super.initState();
    getDataFromSharedPrefs();
  } 

  Future<void> pressedLikeOperation(int postId) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int currentUserId = userList.firstWhere((element) => element.email == loggedInEmail).id;
    List<TModels.PostLikedBy> postLikedBys = userPosts.firstWhere((element) => element.postId == postId).postLikedBys;
    bool userLikedPost = postLikedBys.firstWhereOrNull((element) => element.userId == currentUserId) == null;
    if(userLikedPost){
      TModels.PostLikedBy postLikedBy = TModels.PostLikedBy();
      postLikedBy.dateTime = DateTime.now().toIso8601String();
      postLikedBy.userId = currentUserId;
      userPosts.firstWhere((element) => element.postId == postId).postLikedBys.add(postLikedBy);
    }
    else{
      postLikedBys.remove(postLikedBys.firstWhere((element) => element.userId == currentUserId));
    }
      setState(() { 
      String? editedJson = jsonEncode(userPosts.map((e) => e.toJson()).toList());
      sharedPreferences.setString("user_post", editedJson);
      });
  } 



  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      backgroundColor: Colors.blueAccent,
      centerTitle: true,
      title: const Text("Project"),
      actions: [
      isLoggedIn? 
        TextButton(onPressed: (){
        showDialog(context: context, builder:(BuildContext buildContext) => createPostModal(buildContext));
      }, child: const Row(children: [Icon(Icons.add), Text("Create Post")],)) : Container()],
      ),
      drawer: isLoggedIn? LoggedInDrawer() : MyDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Title(title:"Hello World", color: Colors.blueGrey, child: Text(userPosts.length.toString()),),
              Column(
                children: userPosts.where((element) => element.postId>0).map((e) => SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0, top: 5.0),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                          const SizedBox(height: 5,),
                          GestureDetector(
                            onTap: ()=> Navigator.pushNamed(context, '/profileInfo/${e.userId}'),
                            child: Text(userList.firstWhereOrNull((element) => element.id == e.userId)!.name, style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 12),)),
                          const SizedBox(height: 10,), 
                          SizedBox(
                            height: 156 * min(4, e.images.length.toDouble()) / 3,
                            width: MediaQuery.of(context).size.height - 40,
                            child: Center(
                              child: GridView.builder(
                                itemCount: e.images.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5.0, mainAxisSpacing: 4.0),
                              physics: const NeverScrollableScrollPhysics(),           
                              itemBuilder:(context, index)=> Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(e.images.elementAt(index).url, fit: BoxFit.cover,),
                              ),),
                            )),
                          // Wrap(
                          // spacing: 10,
                          //   children: 
                          // e.images.map((e) => Image.network(e.url, fit: BoxFit.contain,)).toList(),
                          // )
                        const SizedBox(height: 10,),
                        Row(children: [
                          IconButton(onPressed: (){
                            if(!isLoggedIn){
                              return;
                            }
                            pressedLikeOperation(e.postId);
                            }, 
                            icon: const Icon(Icons.thumb_up_alt_outlined, color: Colors.lightBlue,)),
                          const SizedBox(width: 5,),
                          e.postLikedBys.length >= 2?
                          Text('${userList.firstWhere((element) => element.id == e.postLikedBys.first.userId).name} and ${(e.postLikedBys.length - 1).toString()} others liked this.')
                          : e.postLikedBys.length ==1 ? 
                          Text("${userList.firstWhere((element) => element.id == e.postLikedBys.first.userId).name} liked this")
                           : Container(),
                        ],),
                        const SizedBox(height: 10,)
                        ],),
                    ),
                  ))).toList(),
              ),
            ],
          ),
        ),
      ),
      );
  } 
}