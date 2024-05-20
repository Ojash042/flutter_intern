import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/api_project/events.dart';
import 'package:flutter_intern/api_project/models.dart';
import 'package:flutter_intern/api_project/states.dart';
import 'package:http/http.dart' as http;

class APIObserver extends BlocObserver{
  const APIObserver();
  
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change){
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
  }
}

class PostBloc extends Bloc<PostEvents, PostsState>{
  PostBloc():super(const PostsState()){
    on<PostFetched>((event,emit) => _onPostFetched(event,emit));
    on<PostAdded>((event, emit) =>_onPostAdded(event,emit));
    on<PostRemoved>((event, emit) => _onPostDeleted(event, emit),);
  }
  
  Future<List<Posts>> _fetchPosts() async {
    var response = await http.get(Uri.parse("https://dummyjson.com/posts"));
    List<Posts> posts = [];
    if(response.statusCode == 200){
      Iterable decoderPosts = jsonDecode(response.body)["posts"];
      posts = decoderPosts.map((e) => Posts.fromJson(e)).toList();
    }
    return posts;
  }
  
  Future<void> _onPostFetched(PostEvents events, Emitter<PostsState> emit) async{
    if(state.hasReachedMax) return;
    
    try{
      if(state.postStatus == LoadingStatus.initial){
        final posts = await _fetchPosts();
        emit(posts.isEmpty ? state.copyWith(hasReachedMax: true): 
        state.copyWith(
          postStatus: LoadingStatus.success,
          posts: List.of(state.posts)..addAll(posts),
          hasReachedMax: false,
          ));
      print(state.posts);
      }
    }
    catch(error){
      emit(state.copyWith(postStatus: LoadingStatus.failure));
    }
  }
  
  Future<void> _onPostAdded(PostAdded events, Emitter<PostsState> emit) async{
    List<Posts> currentListOfPosts = List.of(state.posts)..add(events.post);
    http.Response addPostResponse = await http.post(Uri.parse("https://dummyjson.com/posts/add",),
    headers: {'Content-Type': 'application/json'},
    //   'id': events.post.id,
    //   'title': events.post.title,
    //   'userId': events.post.userId,
    //   'body': events.post.body,
    //   'tags': jsonEncode(events.post.tags),
    //   'reactions': 0,
    // } 
    );
    emit(state.copyWith(
      postStatus: LoadingStatus.success,
      posts: currentListOfPosts,
      hasReachedMax: false,
    ));
    return;
  }
  
  Future<void> _onPostDeleted(PostRemoved event, Emitter<PostsState> emit) async{
    List<Posts> currentListOfPosts = List.of(state.posts)..removeWhere((element) => element.id == event.post.id);

    http.Response removePostResponse = await http.delete(Uri.parse('https://dummyjson.com/posts/${event.post.id}'));
    emit(state.copyWith(postStatus: LoadingStatus.success, posts: currentListOfPosts, hasReachedMax: false));
  }
}


class CommentBloc extends Bloc<CommentEvents, CommentState>{
  CommentBloc():super(const CommentState()){
    on<CommentsFetched>(_onCommentFetched);
  }

  Future<void> _onCommentFetched(CommentEvents events, Emitter<CommentState> emit) async{
      List<Comment> comments = List.empty(growable: true);
      http.Response responseComment = await http.get(Uri.parse('https://dummyjson.com/posts/${events.postId}/comments'));
      if(responseComment.statusCode == 200){ 
          Iterable decoderComments = jsonDecode(responseComment.body)["comments"];
          comments = decoderComments.map((e) => Comment.fromJson(e)).toList();
          emit(CommentState(commentStatus: LoadingStatus.success, comments: comments));
      }
    return;
  }
}

class SingularPostBloc extends Bloc<SingularPostEvents, SingularPostState>{
  final PostBloc postBloc;
  SingularPostBloc(this.postBloc):super(const SingularPostState()){
    on<SingularPostFetched>((event, emit) =>_onSingularPostFetched(event, emit));
  }
  
  void _onSingularPostFetched(SingularPostFetched event, Emitter<SingularPostState> emit) async{
    var post = postBloc.state.posts.firstWhereOrNull((element) => element.id == event.postId);
    if(post!=null){
      emit(SingularPostState(post: post, postStatus: LoadingStatus.success));
    } 
    else{
      emit(SingularPostState(post: post, postStatus: LoadingStatus.failure));
    }
    return;
  }
} 

class AuthorizationProvider extends Bloc<AuthorizedUserEvents, AuthorizedUserState>{
  AuthorizationProvider():super(const UnauthorizedState()){
    on<AuthorizedUserLogin>((event, emit) =>getAuthorization(event, emit));
  }

  void getAuthorization(AuthorizedUserLogin event, Emitter<AuthorizedUserState> emit) async{
    String jsonString = await rootBundle.loadString('assets/api_data.json');
    String authToken = json.decode(jsonString)["user_token"];
    final authResponse = await http.get(
      Uri.parse("https://dummyjson.com/auth/me"),
      headers: {
        'Authorization': '$authToken',
      }
      );
    if(authResponse.statusCode == 200){
      final Map<String,dynamic> data = json.decode(authResponse.body);
      Users user = Users.fromJson(data);
      emit(LoggedInState(user: user, authToken: authToken));
      return;
    }
    emit(const UnauthorizedState());
  }  
  
}