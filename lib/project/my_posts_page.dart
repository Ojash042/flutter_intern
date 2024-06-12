import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_states.dart';
import 'package:flutter_intern/project/bloc/user_list_bloc.dart';
import 'package:flutter_intern/project/bloc/user_list_events.dart';
import 'package:flutter_intern/project/bloc/user_list_states.dart';
import 'package:flutter_intern/project/bloc/user_post_bloc.dart';
import 'package:flutter_intern/project/bloc/user_post_event.dart';
import 'package:flutter_intern/project/bloc/user_post_states.dart';
import 'package:flutter_intern/project/utils.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:flutter_intern/project/technical_models.dart' as TModels;
import 'package:humanizer/humanizer.dart';


class PhotoGrid extends StatefulWidget {
  final int maxImages;
  final List<TModels.Image> images;
  final Function(int) onImageClicked;
  final Function onExpandClicked;

  PhotoGrid({required this.images, required this.onImageClicked, required this.onExpandClicked,
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
    int numImages = widget.images.length;
    return List<Widget>.generate(min(numImages, widget.maxImages), (index) {
      String imageUrl = widget.images[index].url;

      // If its the last image
      if (index == widget.maxImages - 1) {
        // Check how many more images are left
        int remaining = numImages - widget.maxImages;

        // If no more are remaining return a simple image widget
        if (remaining == 0) {

          return GestureDetector(
            child:  widget.images.elementAt(index).isNetworkUrl ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ):
            Image.file(File(imageUrl), fit: BoxFit.cover,),
            onTap: () => widget.onImageClicked(index),
          );
        } else {
          // Create the facebook like effect for the last image with number of remaining  images
          return GestureDetector(
            onTap: () => widget.onExpandClicked(),
            child: Stack(
              fit: StackFit.expand,
              children: [
                widget.images.elementAt(index).isNetworkUrl ? Image.network(imageUrl, fit: BoxFit.cover) : Image.file(File(imageUrl), fit: BoxFit.cover,),
                Positioned.fill(child: Container(alignment: Alignment.center, color: Colors.black54, child: 
                Text('+$remaining',style: const TextStyle(fontSize: 32),),
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        return GestureDetector(
          child: widget.images.elementAt(index).isNetworkUrl ? Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ) : Image.file(File(imageUrl), fit: BoxFit.cover,),
          onTap: () => widget.onImageClicked(index),
        );
      }
    });
  }
}

class MyPostsPage extends StatefulWidget{
  const MyPostsPage({super.key});

  @override
  State<MyPostsPage> createState() {
    return _MyPostsPageState();
  }
}

class _MyPostsPageState extends State<MyPostsPage>{
  late List<UserData> userList = List.empty(growable: true);
  late List<TModels.UserPost> userPosts = List.empty(growable: true);

  Future<void> pressedLikeOperation(int postId) async{
    int userId  = context.read<AuthBloc>().state.userData!.id;
    context.read<UserPostBloc>().add(UserPostLikePostEvent(postId: postId, userId: userId));
  }
 
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserListBloc>(context).add(UserListInitialize());

  } 

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthStates>(
      builder: (context, state) => BlocListener<UserListBloc, UserListStates>(
        listener: (context, userListState){
          userList = userListState.userDataList!;
        } ,
        child: BlocConsumer<UserPostBloc, UserPostStates>(
        listener: (context, userPostState) {
          int userId  = context.read<AuthBloc>().state.userData!.id;
          userPosts = mounted ? context.read<UserPostBloc>().state.userPosts!.where((element) => element.userId == userId).toList() : List.empty(growable: true); 
        },
          builder: (BuildContext context, UserPostStates userPostState) => Scaffold(
            appBar:const CommonAppBar(),
            body: SingleChildScrollView(child: 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: userPosts.length,
                itemBuilder: (context, index){
                var e = userPosts.elementAt(index);
                return SizedBox(width: MediaQuery.of(context).size.width,
                child: Card(
                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  color: Colors.white,
                  child: Padding(padding: const EdgeInsets.only(left: 14.0, top: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                      GestureDetector(
                        onTap: ()=> Navigator.pushNamed(context, '/profileInfo/${e.userId}'),
                        child: Row(
                          children: [
                            CircleAvatar(backgroundImage: FileImage(File(state.userDetails!.basicInfo.profileImage.imagePath)),),
                            const SizedBox(width: 10,),
                            Column(mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userList.firstWhereOrNull((element) => element.id == e.userId)!.name, 
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: /* Color(0xffabb5ff) */ Colors.black),),
                              Text(
                                const ApproximateTimeTransformation(granularity: Granularity.primaryUnit, round: true, isRelativeToNow: true)
                                .transform(Duration(microseconds: DateTime.parse(e.createdAt).microsecondsSinceEpoch - DateTime.now().microsecondsSinceEpoch), 'en')
                                )
                              ],), 
                            ],)),
                                            //Center(child: SizedBox(width: MediaQuery.of(context).size.width * 0.7 ,child: const Divider())),
                            const SizedBox(height: 10,),
                            Text(e.title, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),),
                            const SizedBox(height: 5,),
                            SizedBox(
                              height: 300 * min(4, e.images.length.toDouble()) / 3,
                              width: MediaQuery.of(context).size.height - 40,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: PhotoGrid(images: e.images, onImageClicked: (idx){}, onExpandClicked: (){},),
                                )),
                                const SizedBox(height: 10,),
                                Row(children: [
                                  Stack(children: [
                                    Container(padding: const EdgeInsets.only(left: 14), child: const Icon(cupertino.CupertinoIcons.heart_circle_fill, color: Colors.pinkAccent, size: 22,)),
                                    const CustomThumbUpIcon(),
                                    ],),
                                    const SizedBox(width: 10,), 
                                    Text(getPrefixText(e.postLikedBys), style: const TextStyle(fontWeight: FontWeight.w300) ,),
                                ],),
                                const Divider(thickness: 0.5,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(onPressed: (){
                                            if(!state.loggedInState){
                                              return;
                                            }
                                            pressedLikeOperation(e.postId);
                                          }, 
                                          icon: (state is AuthorizedAuthState && e.postLikedBys.map((e) => e.userId).toList().contains(state.userData!.id)) ? 
                                          const Icon(cupertino.CupertinoIcons.hand_thumbsup_fill, color: Colors.blueAccent,) :const Icon(cupertino.CupertinoIcons.hand_thumbsup, color: Colors.grey,),),
                                          const Text("Like")
                                      ],) 
                                    ],),
                                    Row(
                                      children: [
                                        IconButton(onPressed: (){}, icon: const Icon(cupertino.CupertinoIcons.bubble_right, color: Colors.grey,)),
                                        const Text("Comment"),
                                    ],),
                                    Row(
                                      children: [
                                        IconButton(onPressed: (){}, icon: const Icon(cupertino.CupertinoIcons.share_up, color: Colors.grey,)),
                                        const Text("Share"),
                                        ],),
                                    ],),
                                    const SizedBox(height: 10,)
                                    ],),
                                    ),
                                    ));
                              }),
            ),),
          ),
        ),
      ),
    );
  }
}