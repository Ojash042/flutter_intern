import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern/project/auth_provider.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:flutter_intern/project/technical_models.dart' as TModels;

class MyPostsPage extends StatefulWidget{
  @override
  State<MyPostsPage> createState() {
    return _MyPostsPageState();
  }
}

class _MyPostsPageState extends State<MyPostsPage>{
  late List<UserData> userList = List.empty(growable: true);
  late List<TModels.UserPost> userPosts = List.empty(growable: true);
  late List<TModels.UserPost> allUserPosts = List.empty(growable: true);
  late UserData? loggedInUser;
  late UserDetails? loggedInUserDetails;

    Future<void> pressedLikeOperation(int postId) async{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      int currentUserId = userList.firstWhere((element) => element.email == loggedInUser!.email).id;
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
  void getDataFromSharedPrefs() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.getString("user_post");
    String? userDataJson = sharedPreferences.getString("user_data");
    String? userPostJson = sharedPreferences.getString("user_post");
    String? userDetailsJson = sharedPreferences.getString("user_details");
    Iterable decodeUserData = jsonDecode(userDataJson!);
    Iterable decodeUserPost = jsonDecode(userPostJson!);
    Iterable decoderUserDetails = jsonDecode(userDetailsJson!);

    loggedInUser = await Provider.of<AuthProvider>(context, listen: false).getLoggedInUser();

    setState(() { 
      loggedInUserDetails = decoderUserDetails.map((e) => UserDetails.fromJson(e)).firstWhere((element) => element.id == loggedInUser!.id);
      allUserPosts = decodeUserPost.map((e) => TModels.UserPost.fromJson(e)).where((element) => (element.postId > 0)).toList();
      userPosts = allUserPosts.where((element) => element.userId == loggedInUser!.id).toList();
      // userPosts = decodeUserPost.map((e) => TModels.UserPost.fromJson(e)).where((element) => (element.postId > 0) &&(element.userId == loggedInUser!.id)).toList();
      userList = decodeUserData.map((e) => UserData.fromJson(e),).toList();
    });
  
    print(userPosts);
  }

  @override
  void initState() {
    super.initState();
    getDataFromSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      drawer: const LoggedInDrawer(),
      body: SingleChildScrollView(child: 
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: userPosts.length,
          itemBuilder: (context, index){
          var e = userPosts.elementAt(index);
          return SizedBox(
            child: Card(child: Padding(
              padding: const EdgeInsets.only(left: 14, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15,),
                  GestureDetector(
                    onTap: ()=> Navigator.pushNamed(context, '/profileInfo/${e.userId}'),
                    child: Row(
                      children: [
                        CircleAvatar(backgroundImage: FileImage(File(loggedInUserDetails!.basicInfo.profileImage.imagePath))),
                        const SizedBox(width: 10,),
                        Text(loggedInUser!.name, style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 12),),
                      ],
                    ),),
                  const SizedBox(height: 10,),
                  Center(child: SizedBox(width: MediaQuery.of(context).size.width * 0.7, child: const Divider(),)),
                  Text(e.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  const SizedBox(height: 5,),
                  const SizedBox(height: 10,),
                  SizedBox(height: 156 * min(4, e.images.length.toDouble()/3),
                  width: MediaQuery.of(context).size.width - 40,
                  child: Center(
                    child: GridView.builder(
                      itemCount: e.images.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 4),
                       physics: const NeverScrollableScrollPhysics(),
                       itemBuilder: (context, index) => Padding(padding: const EdgeInsets.all(8),
                       child: Image.network(e.images.elementAt(index).url, fit: BoxFit.cover,),
                       )),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Row(children: [IconButton(onPressed: (){
                    pressedLikeOperation(e.postId);
                  }, icon:  Icon(
                    (e.postLikedBys.map((e) => e.userId).toList().contains(loggedInUser!.id)) ? Icons.thumb_up_sharp :Icons.thumb_up_alt_outlined , 
                    color: const Color(0xffabb5ff),),),
                  const SizedBox(height: 4,),
                  e.postLikedBys.length >= 2?
                  Text('${userList.firstWhere((element) => element.id == e.postLikedBys.first.userId).name} and ${(e.postLikedBys.length -1).toString()} others liked this.'):
                  e.postLikedBys.length == 1 ?
                  Text('${userList.firstWhere((element) => element.id == e.postLikedBys.first.userId).name} liked this')
                  :
                  Container(),
                  ],),
                  const SizedBox(height: 10,),
                ],
              ),
            ),),
          );
        }),
        // child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
          // children: userPosts.map((e) => SizedBox(
          //   child: Card(child: Padding(
          //     padding: const EdgeInsets.only(left: 25, top: 5),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(e.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          //         const SizedBox(height: 5,),
          //         GestureDetector(
          //           onTap: ()=> Navigator.pushNamed(context, '/profileInfo/${e.userId}'),
          //           child: Text(loggedInUser!.name, style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 12),),),
          //         const SizedBox(height: 10,),
          //         SizedBox(height: 156 * min(4, e.images.length.toDouble()/3),
          //         width: MediaQuery.of(context).size.width - 40,
          //         child: Center(
          //           child: GridView.builder(
          //             itemCount: e.images.length,
          //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 4),
          //              physics: const NeverScrollableScrollPhysics(),
          //              itemBuilder: (context, index) => Padding(padding: const EdgeInsets.all(8),
          //              child: Image.network(e.images.elementAt(index).url, fit: BoxFit.cover,),
          //              )),
          //           ),
          //         ),
          //         const SizedBox(height: 10,),
          //         Row(children: [IconButton(onPressed: (){
          //           pressedLikeOperation(e.postId);
          //         }, icon: const Icon(Icons.thumb_up_alt_outlined, color: Colors.lightBlue,),),
          //         const SizedBox(height: 4,),
          //         e.postLikedBys.length >= 2?
          //         Text('${userList.firstWhere((element) => element.id == e.postLikedBys.first.userId).name} and ${(e.postLikedBys.length -1).toString()} others liked this.'):
          //         e.postLikedBys.length == 1 ?
          //         Text('${userList.firstWhere((element) => element.id == e.postLikedBys.first.userId).name} liked this')
          //         :
          //         Container(),
          //         ],),
          //         const SizedBox(height: 10,),
          //       ],
          //     ),
          //   ),),
          // )).toList(),),
      ),),
    );
  }
}