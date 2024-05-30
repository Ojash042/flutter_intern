import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:flutter_intern/project/technical_models.dart' as TModels;
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget{
  const LandingPage({super.key});

  @override
  State<LandingPage> createState()=> _LandingPageState();

}

class PhotoGrid extends StatefulWidget {
      final int maxImages;
      final List<String> imageUrls;
      final Function(int) onImageClicked;
      final Function onExpandClicked;

  PhotoGrid({required this.imageUrls, required this.onImageClicked, required this.onExpandClicked,
      this.maxImages = 4, super.key});

  @override
  createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {
  @override
  Widget build(BuildContext context) {
    var images = buildImages();

    return GridView(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      children: images,
    );
  }

  List<Widget> buildImages() {
    int numImages = widget.imageUrls.length;
    return List<Widget>.generate(min(numImages, widget.maxImages), (index) {
      String imageUrl = widget.imageUrls[index];

      // If its the last image
      if (index == widget.maxImages - 1) {
        // Check how many more images are left
        int remaining = numImages - widget.maxImages;

        // If no more are remaining return a simple image widget
        if (remaining == 0) {
          return GestureDetector(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
            onTap: () => widget.onImageClicked(index),
          );
        } else {
          // Create the facebook like effect for the last image with number of remaining  images
          return GestureDetector(
            onTap: () => widget.onExpandClicked(),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(imageUrl, fit: BoxFit.cover),
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.black54,
                    child: Text('+$remaining',
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        return GestureDetector(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: () => widget.onImageClicked(index),
        );
      }
    });
  }
}

class _LandingPageState extends State<LandingPage>{
  List<UserData> userList = [];
  List<UserDetails> userDetailsList = [];
  List<TModels.UserPost> userPosts = List.empty(growable: true);
  String? loggedInEmail;
  bool isLoggedIn = false;
  int postIndex = 0;
  int minUser = 3;
  UserData? currentLoggedInUser;
  Future<void> getDataFromSharedPrefs() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.getString("user_post");
    String? userDataJson = sharedPreferences.getString("user_data");
    String? userPostJson = sharedPreferences.getString("user_post");
    String? userDetailsJson = sharedPreferences.getString("user_details");

    Iterable decoderUserData =  jsonDecode(userDataJson!);
    Iterable decoderUserDetails = jsonDecode(userDetailsJson!);
    Iterable decoderUserPost = jsonDecode(userPostJson!);


    setState(() {  

    loggedInEmail = sharedPreferences.getString("loggedInEmail");

    if(loggedInEmail != null){
      isLoggedIn = true;
    }

    userList =  decoderUserData.map((e) => UserData.fromJson(e)).toList();
    userPosts = decoderUserPost.map((e) => TModels.UserPost.fromJson(e)).toList();
    userDetailsList = decoderUserDetails.map((e) => UserDetails.fromJson(e)).toList();
    currentLoggedInUser = userList.firstWhereOrNull((element) => element.email == loggedInEmail);
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
                      
                      },
                       child: const Text("Add Post"))
                    ],)),
                  );
                }
              ),
            ),
          );
  }

  void clearShared() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

  @override
  void initState() {
    super.initState();
    getDataFromSharedPrefs();
    postIndex = 0;
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
    return Scaffold(
      bottomNavigationBar: CommonNavigationBar(),
      appBar: AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xffabb5ff), Color(0xfff6efe9)])
        ),
      ),
      centerTitle: true,
      title: const Text("Project"),
      actions: [
      isLoggedIn? 
        TextButton(onPressed: (){
        showDialog(context: context, builder:(BuildContext buildContext) => createPostModal(buildContext));
      }, child: const Row(children: [Icon(Icons.add), Text("Create Post")],)) : Container()],
      ),
      drawer: isLoggedIn? const LoggedInDrawer() : MyDrawer(),
      body: Container(
      color: Colors.grey[200],
        child: SingleChildScrollView(
          child: userList.length < minUser? Container(): Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: userPosts.where((element) => element.postId>0).length,
                  itemBuilder: (context, index){
                  var e = userPosts.where((element)=> element.postId>0).elementAt(index);
                  return SizedBox(
                    width: MediaQuery.of(context).size.width + 160,
                    child: Card(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 14.0, top: 5.0),
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10,),
                            GestureDetector(
                              onTap: ()=> Navigator.pushNamed(context, '/profileInfo/${e.userId}'),
                              child: Row(
                                children: [
                                  CircleAvatar(backgroundImage: FileImage(File(userDetailsList.firstWhereOrNull((element) => element.id == e.userId)!.basicInfo.profileImage.imagePath)),),
                                  const SizedBox(width: 10,),
                                  Text(userList.firstWhereOrNull((element) => element.id == e.userId)!.name, style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 16, color: Color(0xffabb5ff)),),
                                ],
                              )),
                            Center(child: SizedBox(width: MediaQuery.of(context).size.width * 0.7 ,child: const Divider())),
                            const SizedBox(height: 10,),
                            Text(e.title, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),),
                            const SizedBox(height: 5,),
                            SizedBox(
                              height: 300 * min(4, e.images.length.toDouble()) / 3,
                              width: MediaQuery.of(context).size.height - 40,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: PhotoGrid(imageUrls: e.images.map((image) => image.url).toList(), onImageClicked: (idx){}, onExpandClicked: (){},),
                              )),
                              const SizedBox(height: 10,),
                              Row(children: [
                                IconButton(onPressed: (){
                                if(!isLoggedIn){
                                  return;
                                }
                                pressedLikeOperation(e.postId);
                              }, 
                            icon: Icon(e.postLikedBys.map((e) => e.userId).toList().contains(currentLoggedInUser!.id)? Icons.thumb_up : Icons.thumb_up_alt_outlined, color: const Color(0xffabb5ff),)),
                            const SizedBox(width: 5,),
                            e.postLikedBys.length >= 2?
                            Text('${userList.firstWhere((element) => element.id == e.postLikedBys.first.userId).name} and ${(e.postLikedBys.length - 1).toString()} others liked this.')
                            : e.postLikedBys.length == 1 ? 
                            Text("${userList.firstWhere((element) => element.id == e.postLikedBys.first.userId).name} liked this")
                             : Container(),
                          ],),
                          const SizedBox(height: 10,)
                          ],),
                      ),
                    ));
                }),
             ],
            ),
          ),
        ),
      ),
      );
  } 
}