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
import 'package:flutter_intern/project/locator.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:flutter_intern/project/technical_models.dart' as TModels;
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:humanizer/humanizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';


class CustomThumbUpIcon extends StatelessWidget{
  const CustomThumbUpIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
      child: const Center(child: Icon(cupertino.CupertinoIcons.hand_thumbsup_fill, color: Colors.white, size: 14,),),
    );
  }  
}

class LandingPage extends StatefulWidget{
  const LandingPage({super.key});

  @override
  State<LandingPage> createState()=> _LandingPageState();

}

class _LandingPageState extends State<LandingPage>{

  List<UserData> userList = [];
  List<UserDetails> userDetailsList = [];
  List<TModels.UserPost> userPosts = List.empty(growable: true);
  //TModels.UserPost userPost = TModels.UserPost();

  int minUser = 3; 

  String getPrefixText(List<TModels.PostLikedBy> postLikedBy){
    return postLikedBy.isEmpty ?  "No one liked this" : postLikedBy.length==1 ? "1 person liked this." : '${postLikedBy.length} people liked this.';
  }

  Future<void> addPost(TModels.UserPost userPost) async{
      userPost.postId = context.read<UserPostBloc>().state.userPosts!.length +1;
      userPost.userId = context.read<AuthBloc>().state.userData!.id;
      context.read<UserPostBloc>().add(UserPostAddPostEvent(userPost: userPost));
}
  

  Widget createPostModal(BuildContext buildContext){ 

    int imagesCounter = 0;
    TModels.UserPost userPost = TModels.UserPost();
    List<TModels.PostLikedBy> postLikedBy = List.empty(growable: true);
    List<TModels.Image> images = List.empty(growable: true);
    userPost.postLikedBys = postLikedBy;
    userPost.images = images;
    int forceUpdateVar = 0;

    TextEditingController titleController = TextEditingController();
    //TextEditingController descriptionController = TextEditingController(); 
      return BlocProvider<UserPostBloc>(
        create: (_) => UserPostBloc(), 
        child: BlocBuilder<AuthBloc, AuthStates>(
          builder:(context, authState) => StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                  bottomSheet: BottomSheet(
                    onClosing: (){},
                    enableDrag: true,
                    showDragHandle: true,
                    dragHandleColor: Colors.grey,
                    backgroundColor: Colors.white,
                    builder: (context) =>  Padding(
                      padding: const EdgeInsets.symmetric(vertical:15.0, horizontal: 24),
                      child: Row(children: [
                          Transform(alignment: Alignment.center,transform: Matrix4.identity()..scale(-1.0,-1.0,-1.0), 
                          child: IconButton(icon: const Icon(Icons.photo_library_outlined, color: Colors.greenAccent,),
                           onPressed: () async{
                            final ImagePicker _imagePicker = ImagePicker();
                            final XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
                            String? fileName;
                            var directory = await getApplicationDocumentsDirectory();
                            String path = directory.path;
                            if(pickedImage != null){
                              var arr = pickedImage.name.split('.');
                              fileName = '$path/${arr.sublist(0, arr.length-1).join('.')}${Random().nextInt(10000) + 1000}${arr.last}'; 
                              
                              setState((){
                                imagesCounter++;
                                File(pickedImage.path).copy(fileName!);
                                TModels.Image image = TModels.Image();
                                image.id = Random().nextInt(10000) + 1000;
                                image.isNetworkUrl = false;
                                image.url = fileName;
                                userPost.images.add(image);
                              });
                            }
                           },)),
                          IconButton(icon: const Icon(cupertino.CupertinoIcons.paperclip, color: Colors.deepPurpleAccent), 
                          onPressed: (){
                              var _ = showDialog(context: context, builder: (builder) {
                              TextEditingController imageController = TextEditingController();
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: AlertDialog(
                                  title: const Text("Enter Image Url"),
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(1))),
                                  content: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.15,
                                    child: Column( children: [ SizedBox(
                                          //height: MediaQuery.of(context).size.height * 0.2,
                                          width: MediaQuery.of(context).size.width * 0.6,
                                          child: TextField(
                                            controller: imageController,
                                            decoration: const InputDecoration(
                                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.zero), 
                                            gapPadding: 3.0), 
                                            hintText: "Image Url..."),)),
                                          const Spacer(),
                                          FilledButton(onPressed: (){
                                            setState(() {
                                              imagesCounter++;
                                              TModels.Image image = TModels.Image();
                                              image.id = Random().nextInt(10000) + 1000;
                                              image.isNetworkUrl = true;
                                              image.url = imageController.text;
                                              userPost.images.add(image);
                                            });
                                            Navigator.of(context).pop();
                                          }, style: const ButtonStyle(
                                          backgroundColor: WidgetStatePropertyAll(Colors.blueAccent), 
                                          shape: WidgetStatePropertyAll(LinearBorder())), child: const Text("Submit"),
                                          )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                            Future.delayed(Duration.zero, (){
                              setState(() {  
                                forceUpdateVar = Random().nextInt(1290);
                              });
                            });
                          },),
                        ],)
                    ),),
                  appBar: AppBar(
                      leading: IconButton(icon: const Icon(cupertino.CupertinoIcons.xmark),
                      onPressed: (){Navigator.of(context).pop();},
                      ), 
                    centerTitle: true,
                    title: const Text("Create a post"),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: FilledButton(onPressed: (){ 
                          setState(() { 
                                    imagesCounter++;              
                                    userPost.userId = authState.userData!.id;
                                    userPost.postId = Random().nextInt(10000) + 1000;
                                    userPost.createdAt = DateTime.now().toIso8601String();
                                    userPost.title = titleController.text;
                                    userPost.description = "";
                                    userPost.postLikedBys = List.empty(growable: true);
                                    addPost(userPost);
                                  });
                          Navigator.of(context).pop();
                        }, 
                        style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blueAccent), 
                        shape: WidgetStatePropertyAll(LinearBorder())), child: const Text("Post"),),
                      )
                    ],),
                  body: BlocConsumer<UserPostBloc, UserPostStates>(
                    listener: (context, state) =>{},
                    builder: (context, state) => Center(
                      child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return SingleChildScrollView(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 40,
                              child: SingleChildScrollView(child: Column(children: [ 
                                //Container(),
                                //const SizedBox(height: 30,),
                                // const Text("Create a new Post"),
                                const SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.only(left:8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        CircleAvatar(backgroundImage: FileImage(File(authState.userDetails!.basicInfo.profileImage.imagePath)),),
                                        const SizedBox(width: 10,),
                                        Text(authState.userData!.name, style: const TextStyle(fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                    Wrap(spacing: 8, runSpacing: 8,
                                    children: userPost.images.map((e) => (e.isNetworkUrl) ? Image.network(e.url, height: 128, width: 96,) : Image.file(File(e.url), height: 128, width:  96,)).toList(),),
                                    SizedBox(
                                      height: MediaQuery.sizeOf(context).height * 0.6,
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      child: TextFormField(
                                        controller: titleController,
                                        decoration: const InputDecoration(
                                          hintText: "Share your thoughts...", border: InputBorder.none), maxLines: null,)),
                                    ],),
                                ),
                                ],)),
                              ),
                          );
                          }
                        ),
                      ),
                  ),
                  );
            }
          ),
        ),
      );
  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() { 
    });
  }
  
  @override
  void didUpdateWidget(covariant LandingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() { 
    });
  }
   
  @override
  void dispose() {
    super.dispose();
    locator<UserListBloc>().close();
  } 

  
  @override
  void initState() {
    super.initState();
    //context.read<UserListBloc>().add(UserListInitialize());
    //locator.get<UserListBloc>().add(UserListInitialize());
    if(locator<UserListBloc>().state is UserListEmpty){ 
      locator<UserListBloc>().add(UserListInitialize());
    } 
  } 

  Future<void> pressedLikeOperation(int postId, String loggedInEmail) async{ 
    int userId = context.read<AuthBloc>().state.userData!.id; 
    context.read<UserPostBloc>().add(UserPostLikePostEvent(postId: postId, userId: userId));
  } 
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthStates>(
      builder: (BuildContext context, state) => BlocBuilder<UserListBloc, UserListStates>(
        builder: (context, userListState) {
          userDetailsList = userListState.userDetailsList ?? List.empty();
          userList = userListState.userDataList ?? List.empty();
          return BlocConsumer<UserPostBloc, UserPostStates>(
          listener: (context, userPostState) {
            userPosts = (state is! UserPostEmpty) ? userPostState.userPosts! : List.empty();
          },
            builder: (context, userPostState) {
              userPosts = userPostState.userPosts ?? List.empty();
            return Scaffold(
              bottomNavigationBar: (state is AuthorizedAuthState) ? const CommonNavigationBar(): const UnauthorizedNavigationBar(),
              appBar: AppBar(
                backgroundColor: Colors.white,
                //flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xffabb5ff), Color(0xfff6efe9)])),),
                centerTitle: false,
                title:  Text("Project", style: GoogleFonts.quicksand(color: Colors.lightBlue, fontSize: 24, fontWeight: FontWeight.bold),),),
                      body: Container(
                      color: Colors.grey[200],
                        child: SingleChildScrollView(
                          child: userList.length < minUser? Container(): Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Column(
                              children: [
                                (state is AuthorizedAuthState) ? Card(
                                  shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                  color: Colors.white,
                                  elevation: 0,
                                  child: InkWell(
                                  onTap: () => showDialog(context: context, builder: (context) => createPostModal(context),),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(backgroundImage: FileImage(File(state.userDetails!.basicInfo.profileImage.imagePath)),),
                                            const SizedBox(width: 20,),
                                            const Center(child: Text("Share your thoughts...", style: TextStyle(fontWeight: FontWeight.w200),)),
                                            const Spacer(),
                                            const Icon(Icons.image_outlined, color: Color(0xff62af66))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),) : Container(),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: userPosts.where((element) => element.postId>0).length,
                                  itemBuilder: (context, index){
                                  var e = userPosts.where((element)=> element.postId>0).elementAt(index);
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(0)),
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
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(userList.firstWhereOrNull((element) => element.id == e.userId)!.name, 
                                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: /* Color(0xffabb5ff) */ Colors.black),),
                                                      Text(
                                                        const ApproximateTimeTransformation(granularity: Granularity.primaryUnit, round: true, isRelativeToNow: true)
                                                        .transform(Duration(microseconds: DateTime.parse(e.createdAt).microsecondsSinceEpoch - DateTime.now().microsecondsSinceEpoch), 'en')
                                                      )
                                                    ],
                                                  ), 
                                                ],
                                              )),
                                            //Center(child: SizedBox(width: MediaQuery.of(context).size.width * 0.7 ,child: const Divider())),
                                            const SizedBox(height: 10,),
                                            Text(e.title, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),),
                                            const SizedBox(height: 5,),
                                            SizedBox(
                                              height: 300 * min(4, e.images.length.toDouble()) / 3,
                                              width: MediaQuery.of(context).size.height - 40,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: PhotoGrid(images: e.images, onImageClicked: (idx){
                                                }, onExpandClicked: (){},),
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
                                                        pressedLikeOperation(e.postId, state.userData!.email);
                                                        }, 
                                                        icon: (state is AuthorizedAuthState && e.postLikedBys.map((e) => e.userId).toList().contains(state.userData!.id)) ? 
                                                        const Icon(cupertino.CupertinoIcons.hand_thumbsup_fill, color: Colors.blueAccent,) :const Icon(cupertino.CupertinoIcons.hand_thumbsup, color: Colors.grey,),),
                                                        const Text("Like")
                                                      ],
                                                    ) 
                                                  ],
                                                ),
                                             Row(
                                               children: [
                                                 IconButton(onPressed: (){}, icon: const Icon(cupertino.CupertinoIcons.bubble_right, color: Colors.grey,)),
                                                 const Text("Comment"),
                                               ],
                                             ),
                                             Row(
                                               children: [
                                                 IconButton(onPressed: (){}, icon: const Icon(cupertino.CupertinoIcons.share_up, color: Colors.grey,)),
                                                 const Text("Share"),
                                               ],
                                             ),
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
          },
        );
        },
      ),
    );
  } 
}