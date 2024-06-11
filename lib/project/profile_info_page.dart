import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart' as cupertino show CupertinoIcons;
import 'package:bootstrap_icons/bootstrap_icons.dart' as bs_icons;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_bloc.dart';
import 'package:flutter_intern/project/bloc/auth_states.dart';
import 'package:flutter_intern/project/bloc/user_list_bloc.dart';
import 'package:flutter_intern/project/bloc/user_list_states.dart';
import 'package:flutter_intern/project/bloc/user_post_bloc.dart';
import 'package:flutter_intern/project/bloc/user_post_event.dart';
import 'package:flutter_intern/project/bloc/user_post_states.dart';
import 'package:flutter_intern/project/locator.dart';
import 'package:flutter_intern/project/misc.dart';
import 'package:flutter_intern/project/models.dart';
import 'package:flutter_intern/project/technical_models.dart' as TModels;
import 'package:humanizer/humanizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

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


class ProfileInfoPage extends StatefulWidget{
  final String id;
  ProfileInfoPage({super.key, required this.id});
  final GlobalKey<_ProfileInfoPageState> profileInfoKey = GlobalKey<_ProfileInfoPageState>();

@override
  State<StatefulWidget> createState() {
    return _ProfileInfoPageState(profileInfoKey);
  }
}
enum UserGender{male, female}

class _ProfileInfoPageState extends State<ProfileInfoPage>{

  GlobalKey<_ProfileInfoPageState> profileInfoKey = GlobalKey<_ProfileInfoPageState>();
  _ProfileInfoPageState(profileInfoKey);
  UserData? currentUser;
  UserDetails? currentUserDetails;
  late List<UserData> userDataList;
  late List<UserDetails> userDetailsList;
  bool isEditMode = false;
  List<TModels.UserPost> userPosts = List.empty(growable: true);
  List<Widget> action = [];
  void saveData(List<UserDetails> userDetailsList) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() { 
      String? encodedString = jsonEncode(userDetailsList.map((e) => e.toJson()).toList()); 
      sharedPreferences.setString("user_details", encodedString);
    });
    
  }

  String getPrefixText(List<TModels.PostLikedBy> postLikedBy){
    return postLikedBy.isEmpty ?  "No one liked this" : postLikedBy.length==1 ? "1 person liked this." : '${postLikedBy.length} people liked this.';
  }    
 
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //getDataFromSharedPrefs().then((value) => setState(() { }));
    WidgetsBinding.instance.addPostFrameCallback((_){
      setState(() { 
      });
    });
  }

  @override
  void didUpdateWidget(covariant ProfileInfoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_){
      setState(() { });
    });
  } 
  
  @override
  void dispose() {
    super.dispose();
    closeUserPostLocator();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
    setState(() {});
      //getDataFromSharedPrefs().then((value) => setState(() {  }));
    WidgetsBinding.instance.addPostFrameCallback((_){
      setState(() {
      IconButton  todoButton = IconButton(onPressed: (){Navigator.of(context).pushNamed('/todos');}, icon: const Icon(Icons.check_box_outlined));
      action.add(todoButton);
      });
    });
    }); 
  }
  Future<void> pressedLikeOperation(int postId) async{
      int userId  = context.read<AuthBloc>().state.userData!.id;
      context.read<UserPostBloc>().add(UserPostLikePostEvent(postId: postId, userId: userId));
    }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthStates>(
        builder: (context, authState) {
          return BlocBuilder<UserPostBloc, UserPostStates>(
            builder: (context, userPostState) {
              if(userPostState is UserPostEmpty){
                return const Scaffold(appBar: CommonAppBar(), body: Center(child: CircularProgressIndicator(),));
              }
              int userId  = context.read<AuthBloc>().state.userData!.id;
              userPosts = mounted ? context.read<UserPostBloc>().state.userPosts!.where((element) => element.userId == userId).toList() : List.empty(growable: true); 
              return (BlocBuilder<UserListBloc, UserListStates>(
                builder: (context, state) {

                  bool isCurrentUserLoggedInUser = BlocProvider.of<AuthBloc>(context).state.userData!.id == int.parse(widget.id);
                  if(isCurrentUserLoggedInUser){
                    currentUser = state.userDataList!.firstWhere((e) => e.id == BlocProvider.of<AuthBloc>(context).state.userData!.id);
                    currentUserDetails = state.userDetailsList!.firstWhere((e) => e.id == BlocProvider.of<AuthBloc>(context).state.userDetails!.id); 
                  }
                  else{
                    currentUser = state.userDataList!.firstWhere((e) => e.id == int.parse(widget.id));
                    currentUserDetails = state.userDetailsList!.firstWhere((e) => e.id == int.parse(widget.id));
                  }
                  return Scaffold(
                    appBar: CommonAppBar(actions: action,),
                              bottomNavigationBar: const CommonNavigationBar(),
                              // drawer: const LoggedInDrawer(),
                              body: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Card(
                                      shape: const LinearBorder(),
                                        color:  Colors.white,
                                        elevation: 0,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Stack(alignment: Alignment.bottomLeft,
                                              clipBehavior: Clip.antiAlias,
                                              children: [
                                                SizedBox(width: MediaQuery.of(context).size.width - 40, height: 210, child: Padding(
                                                  padding: const EdgeInsets.all(16),
                                                  child: Image.file(File(currentUserDetails!.basicInfo.coverImage.imagePath), fit: BoxFit.fill,),
                                                  ),),
                                                 Padding(padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                                                 child: Container(decoration: const BoxDecoration(border:  Border(
                                                  top: BorderSide(color: Colors.transparent, width: 1.5),
                                                  bottom: BorderSide(color: Colors.transparent, width: 1.5),
                                                  left: BorderSide(color: Colors.transparent, width: 1.5),
                                                  right: BorderSide(color: Colors.transparent, width: 1.5),
                                                 ),),
                                                 height: 120, width: 120, 
                                                 child: CircleAvatar(backgroundColor: Colors.white, radius: 0,child: CircleAvatar(radius: 55, backgroundImage: FileImage(File(currentUserDetails!.basicInfo.profileImage.imagePath)))),
                                                 ),
                                                 )
                                              ],),
                                            ),
                                          const SizedBox(height: 10,),

                                          Padding( padding: const EdgeInsets.symmetric(horizontal: 32),
                                          child: Text(currentUser!.name, style:const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),), 
                                          ),
                                          const SizedBox(height: 10,),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 32.0),
                                            child: Text(currentUserDetails!.basicInfo.summary),
                                          ),
                                        const SizedBox(height: 15,), 
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Flex(
                                            direction: Axis.horizontal,
                                            children: [
                                              isCurrentUserLoggedInUser ? FilledButton.icon(
                                                style: const ButtonStyle(
                                                  backgroundColor: WidgetStatePropertyAll(Colors.blueAccent),
                                                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                                                  ),
                                                icon: const Icon(Icons.add),
                                                onPressed: (){},
                                                label: const Text("Add to Story"), 
                                              ) : 
                                              Padding(
                                                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.09),
                                                child: FilledButton.icon(
                                                  style: blueFilledButtonStyle.copyWith(fixedSize: WidgetStatePropertyAll(
                                                    Size.fromWidth(MediaQuery.of(context).size.width * 0.65))),
                                                  onPressed: (){},
                                                  icon: const Icon(bs_icons.BootstrapIcons.chat_dots_fill),
                                                  label: const Text("Message"),
                                                  ),
                                              ),
                                              const Spacer(),
                                              isCurrentUserLoggedInUser? FilledButton.icon(onPressed: (){
                                                Navigator.of(context).pushNamed('/editDetails');
                                              }, 
                                              style: ButtonStyle(
                                              fixedSize: WidgetStatePropertyAll(Size.fromWidth(MediaQuery.of(context).size.width * 0.35)),
                                              shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)))),
                                                iconColor: WidgetStatePropertyAll(isEditMode ? Colors.blueAccent: Colors.white),
                                                backgroundColor:  WidgetStatePropertyAll(isEditMode ? Colors.grey[100] :Colors.grey[300]) ),
                                                icon: const Icon(Icons.edit, color: Colors.black,),
                                                label: const Text("Edit", style: TextStyle(color: Colors.black)),
                                              ) : Container(),
                                            const Spacer(),
                                             IconButton(
                                              icon: const Icon(Icons.more_horiz),
                                              style: ButtonStyle(
                                                fixedSize: WidgetStatePropertyAll(Size.fromWidth(MediaQuery.of(context).size.width * 0.1),),
                                                backgroundColor: WidgetStatePropertyAll(Colors.grey[300]), shape: const WidgetStatePropertyAll(
                                                RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))))),
                                              onPressed: (){},)
                                            ],
                                          ),
                                        ),
                                          const SizedBox(height: 20,),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Card(
                                      color: Colors.white,
                                      elevation: 0,
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
                                      child: InkWell(
                                      borderRadius: const BorderRadius.all(Radius.zero),
                                        onTap: (){Navigator.of(context).pushNamed('/editDetails');},
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                          const SizedBox(height: 10,),
                                          const Padding(padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                                          child: Text("Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                          ),
                                          const Divider(thickness: 0.3,),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Row(children: [currentUserDetails!.basicInfo.gender == "Male"? const Icon(Icons.male_outlined) : const Icon(Icons.female_outlined), const SizedBox(width: 10,), Text(currentUserDetails!.basicInfo.gender)],),
                                          ),
                                          const SizedBox(height: 10,),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Row(children: [const Icon(Icons.cake_outlined), const SizedBox(width: 10,), Text(currentUserDetails!.basicInfo.dob)],),
                                          ),
                                          const SizedBox(height: 10,),
                                          const Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Row(children: [Icon(Icons.more_horiz), SizedBox(width: 10,), Text("See More details")],),
                                          ),
                                          const SizedBox(height: 20,),
                                          Container(width: MediaQuery.of(context).size.width * 0.7,
                                          decoration: BoxDecoration(
                                            color: Colors.blue[200], 
                                          ),)
                                          ],),
                                      ),
                                    ),
                                    ListView.builder(
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
                                                                CircleAvatar(backgroundImage: FileImage(File(authState.userDetails!.basicInfo.profileImage.imagePath)),),
                                                                const SizedBox(width: 10,),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(authState.userData!.name, 
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
                                                                      if(!authState.loggedInState){
                                                                        return;
                                                                      }
                                                                      pressedLikeOperation(e.postId);
                                                                      }, 
                                                                      icon: (authState is AuthorizedAuthState && e.postLikedBys.map((e) => e.userId).toList().contains(authState.userData!.id)) ? 
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
                                    ],),
                                ),
                              ),
                            );
                },
              )  
                      );
            });
        },
      );
  }
}