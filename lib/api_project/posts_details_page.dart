import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/api_project/bloc_provider.dart';
import 'package:flutter_intern/api_project/misc.dart';
import 'package:flutter_intern/api_project/states.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_intern/api_project/models.dart';

class PostPageDetails extends StatefulWidget{
  final int postId;
  const PostPageDetails({super.key, required this.postId});

  @override
  State<StatefulWidget> createState() => _PostPageDetailsState();

}

class _PostPageDetailsState extends State<PostPageDetails>{

  // late Posts post = const Posts();
  // late List<Comment> comments = List.empty(growable: true);
  // late Users user;
  // void fetchPost() async{
  //   http.Response responsePost = await http.get(Uri.parse('https://dummyjson.com/posts/${widget.postId}'));
  //   if(responsePost.statusCode == 200){
  //     setState(() {
  //       Map<String, dynamic> decoderPost = json.decode(responsePost.body);
  //       post  = Posts.fromJson(decoderPost);
  //     });
  //     
  //     else{
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${responseComment.statusCode.toString()}')));
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: const CommonAppBar(),
      body: 
      BlocBuilder<SingularPostBloc, SingularPostState>(builder: (context, postState){
        return BlocBuilder<CommentBloc, CommentState>(builder: (context, commentState){
        if(postState.postStatus == LoadingStatus.initial){
          return const Center(child: CircularProgressIndicator());
        }
        else{
            return SingleChildScrollView(child: Column(
              children: [
              Card(
              child: Column(children: [
              Text(postState.post?.title ?? "", style: Theme.of(context).textTheme.bodyLarge,),
              const SizedBox(height: 10,),
              Row(children : postState.post!.tags!.map((e) => Card(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(e),
              ),)).toList()),
              const SizedBox(height: 30,),
              Text(postState.post!.body ?? "",),
              const SizedBox(height: 30,),
              Row(children: [Icon(Icons.thumb_up_alt_sharp, color: Theme.of(context).highlightColor,), const SizedBox(height: 10,),
               Text("${postState.post!.reactions > 0 ? postState.post!.reactions : "Nobody"} ${postState.post!.reactions == 0?"": postState.post!.reactions == 1 ? "Person" : "People"} liked this"),
               const SizedBox(width: 10,),
               GestureDetector(
                onTap: (){showDialog(context: context, builder: (context){
                  return CommentsModal(comments: commentState.comments);
                });},
                child: Text('${commentState.comments.isNotEmpty ? commentState.comments.length : "Nobody"} ${commentState.comments.isEmpty? "": commentState.comments.length == 1 ? "person": "people"} commented')),
               ],),
              const SizedBox(height: 30,),
            ],),
          )
        ],
      ),);         
        }
      },);
      })
      
    );

}

class CommentsModal extends StatelessWidget {

  const CommentsModal({
    super.key,
    required this.comments,
  });

  final List<Comment> comments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:SingleChildScrollView(child: Column(children: [
      Align(alignment: Alignment.topRight, child: IconButton(icon: Icon(Icons.cancel, color: Theme.of(context).colorScheme.error,), onPressed: (){Navigator.pop(context);},),),
      const SizedBox(height: 30,),
      const Text("Comments: "),
      const SizedBox(height: 30,),
      comments.isEmpty? const Text("No comments available") :
      Column(children: comments.map((e) => Card(child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: (){Navigator.popAndPushNamed(context, '/users/${e.user!.id}');},
                child: Text(e.user!.username ?? ""))),
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(e.body?? ""),
          ),
        ],
      ),)).toList(),),
    ],),));
  }
}