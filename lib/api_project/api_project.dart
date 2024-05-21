
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/api_project/bloc_provider.dart';
import 'package:flutter_intern/api_project/events.dart';
import 'package:flutter_intern/api_project/login_screen.dart';
import 'package:flutter_intern/api_project/misc.dart';
import 'package:flutter_intern/api_project/models.dart';
import 'package:flutter_intern/api_project/posts_details_page.dart';
import 'package:flutter_intern/api_project/states.dart';
import 'package:flutter_intern/api_project/user_details.dart';
//import 'package:http/http.dart' as http;

void main(List<String> args) {
  Bloc.observer = const APIObserver();
  runApp(
    MultiBlocProvider(providers:
    [
      BlocProvider(create: (_) => AuthorizationProvider()..add(UnknownAuth())),
      BlocProvider(create: (_) => PostBloc()..add(PostFetched()))
    ], 
      child: const App(),
     )
    );
}

class App extends StatelessWidget{

  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent)),
    routes: {
      "/": (context) => const HomePage(),
      "/init": (context) => const InitialContainer(),
      "/login": (context) => LoginPage(),
    },
    initialRoute: '/init',
    onGenerateRoute: (settings){
      if(settings.name!.startsWith('/posts/')){
        var postId = settings.name!.split('/').last;
        final postBloc = BlocProvider.of<PostBloc>(context);
        return MaterialPageRoute(builder: (context) => 
        MultiBlocProvider(providers: [
          BlocProvider(create: (_) => SingularPostBloc(postBloc)..add(SingularPostFetched(postId: int.parse(postId)))),
          BlocProvider(create: (_) => CommentBloc()..add(CommentsFetched(postId: int.parse(postId))))
        ], 
        child: PostPageDetails(postId: int.parse(postId),))
        // MultiBlocProvider(
        //   providers: [BlocProvider(
        //     create: (_) => SingularPostBloc(postBloc)..add(SingularPostEvents()),
        //     child: PostPageDetails(postId: int.parse(postId),)),
        // ));
    );}
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

class InitialContainer extends StatefulWidget{
  const InitialContainer({super.key});
  @override
  State<InitialContainer> createState() {
  return _InitialContainerState();
  }
}

class _InitialContainerState extends State<InitialContainer>{
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
    final authorizationProvider = BlocProvider.of<AuthorizationProvider>(context);
    final initialState = authorizationProvider.state;
    if (initialState is LoggedInState) {
      Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
    } if(initialState is UnauthorizedState) {
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    }
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthorizationProvider, AuthorizedUserState>(listener:(context, state) {
      if(state is LoggedInState){
        Navigator.popAndPushNamed(context, "/");
      }
      if(state is UnauthorizedState) {
        Navigator.popAndPushNamed(context, "/login");
      }
    },
    child: const Scaffold(body: Center(child: CircularProgressIndicator()),),
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
  ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    controller.addListener(() { 
      if(controller.position.pixels == controller.position.maxScrollExtent){
        BlocProvider.of<PostBloc>(context).add(PostExtraRetrieved());
      }
    if (controller.position.userScrollDirection == ScrollDirection.reverse) {
      controller.position.didEndScroll();
    }
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const CommonAppBar(),
      drawer: LoggedInDrawer(),
      body: 
      BlocBuilder<AuthorizationProvider, AuthorizedUserState>(builder: (context, authState){
       return BlocBuilder<PostBloc, PostsState>(
        builder: (context, state){
        if(state.postStatus == LoadingStatus.initial){
          return const Center(child: CircularProgressIndicator());
        }
        else{
        return RefreshIndicator(
        onRefresh: (){
          BlocProvider.of<PostBloc>(context).add(PostFetched());
          return Future.delayed(Duration.zero);},
          child: Stack(
            children: [ 
              SingleChildScrollView(
              controller: controller,
              child: Column(
                children: [
                    OutlinedButton(onPressed: (){
                      showAddPostModal(context, authState);
                }, child: 
                const Row(children: [
                  Icon(Icons.add_card), 
                  SizedBox(width: 10,), 
                  Text("Add a post")],)),
                  Column(
                  children: state.posts.map((e) => GestureDetector(
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
                              child: Text(tag),
                            ),),
                          )).toList(),),
                          const SizedBox(height: 10,),
                          Text(e.body?? ""),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                            Icon(Icons.thumb_up_alt_sharp, color: Theme.of(context).highlightColor,),
                            const SizedBox(height: 10,), Text("${e.reactions > 0 ? e.reactions : "No one"} ${e.reactions == 0 ? "" : e.reactions == 1 ? "Person" : "People"} liked this"),
                            (authState.isLoggedIn && authState.user!.id == e.userId)? 
                            IconButton(
                              onPressed: (){BlocProvider.of<PostBloc>(context).add(PostRemoved(post: e));},
                              icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error,)): Container(),
                             ],),
                          const SizedBox(height: 20)
                        ],),
                      ),
                    ),
                  )).toList()
                  ),
                          ],
              ),
                    ),
              if(state.postStatus == LoadingStatus.loading)
                const Center(
                child: Card(
                elevation: 5,
                color: Colors.white,
                child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        );

        }
      }
      );},)
      
      ); 
  }

  Future<dynamic> showAddPostModal(BuildContext context, AuthorizedUserState authState) {
    return showDialog(context: context, builder: (context){

              List<String> tags = List.empty(growable: true);
              TextEditingController tagController = TextEditingController();
              TextEditingController titleController = TextEditingController();
              TextEditingController bodyController = TextEditingController();

              return StatefulBuilder(
                builder: (context, setState) {
                  return Scaffold(
                    body: SingleChildScrollView(
                    child: 
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: authState.isLoggedIn ? Column(children: [
                        Align(alignment: Alignment.topRight, child: Icon(Icons.close, color: Theme.of(context).colorScheme.error,),),
                        const SizedBox(height: 30,),
                        Row(children: tags.map((e) => Card(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(e),
                        ),)).toList(),),
                        const SizedBox(height: 30,),
                        TextField(decoration: InputDecoration(
                          hintText: "Enter tags",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2.0,))),
                          controller: tagController,
                          onSubmitted: (value){
                            setState(() {  
                              tags.add(value);
                             });
                             tagController.clear(); 
                             },
                          ),
                        const SizedBox(height: 30,),
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(hintText: "Enter title"),),
                        const SizedBox(height: 30,),
                        TextField(controller: bodyController,
                        maxLines: null,
                        minLines: 5,
                        decoration: const InputDecoration(hintText: "Enter body",),
                        ),
                        const SizedBox(height: 30,),
                        OutlinedButton(onPressed: (){
                  
                        Posts post = Posts(
                          id: Random().nextInt(10000) +1000,
                          userId: authState.user!.id, 
                          reactions: 0,
                          title: titleController.text,
                          body: bodyController.text,
                          tags: tags,
                         );
                  
                          BlocProvider.of<PostBloc>(context).add(PostAdded(post: post));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [const Text("Post submitted successfully"), OutlinedButton(onPressed: (){Navigator.pop(context);}, child: const Text("Go back!"))],
                          )));
                        }, child: const Text("Submit")),
                      ],):Column(children: [
                        Align(alignment: Alignment.topRight, child: Icon(Icons.close, color: Theme.of(context).colorScheme.error,),),
                        const SizedBox(height: 30,),
                        const Center(child: Text("You need to be logged in to post"),),
                      ],),
                    ),
                  ),
                                );
                }
              );
          });
  } 
}