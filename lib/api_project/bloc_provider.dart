import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intern/api_project/events.dart';
import 'package:flutter_intern/api_project/models.dart';
import 'package:flutter_intern/api_project/states.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  PostBloc():super(const PostsState(pageNo: 0)){
    on<PostFetched>((event,emit) => _onPostFetched(event,emit));
    on<PostAdded>((event, emit) =>_onPostAdded(event,emit));
    on<PostRemoved>((event, emit) => _onPostDeleted(event, emit),);
    on<PostExtraRetrieved>((event, emit) => _onExtraPostsRetrieved(event, emit));
  }
  
  
  
  Future<List<Posts>> _fetchPosts(int skip) async {
    var response = await http.get(Uri.parse("https://dummyjson.com/posts?limit=10&skip=$skip"));
    List<Posts> posts = [];
    if(response.statusCode == 200){
      Iterable decoderPosts = jsonDecode(response.body)["posts"];
      posts = decoderPosts.map((e) => Posts.fromJson(e)).toList();
    }
    return posts;
  }
  
  Future<void> _onExtraPostsRetrieved(PostExtraRetrieved event, Emitter<PostsState> emit) async{
    if(state.hasReachedMax) return;
    emit(PostsState(pageNo: state.pageNo, hasReachedMax: false, posts: state.posts, postStatus: LoadingStatus.loading));
    var retrievedPosts =  await _fetchPosts(state.pageNo * 10);
    var posts = state.posts;
    posts.addAll(retrievedPosts);
    if(retrievedPosts.isEmpty){
      emit(PostsState(pageNo: state.pageNo +1, hasReachedMax: true, posts: posts, postStatus: LoadingStatus.success)); 
    } 
    else{
       emit(PostsState(pageNo: state.pageNo+1, hasReachedMax: false, posts: posts, postStatus: LoadingStatus.success));
    }
    }
  
  Future<void> _onPostFetched(PostEvents events, Emitter<PostsState> emit) async{
    if(state.hasReachedMax) return;
    
    try{
      if(state.postStatus == LoadingStatus.initial){
        final posts = await _fetchPosts(0);
        emit(posts.isEmpty ? state.copyWith(hasReachedMax: true): 
        state.copyWith(
          postStatus: LoadingStatus.success,
          posts: List.of(state.posts)..addAll(posts),
          hasReachedMax: false,
          pageNo: 0
          ));
      }
      else{
        final posts = await _fetchPosts(0);
        emit(PostsState(
          pageNo: 0,
          hasReachedMax: false, posts: posts, postStatus: LoadingStatus.success));
        // emit(posts.isEmpty
        //     ? state.copyWith(hasReachedMax: true)
        //     : state.copyWith(
        //         postStatus: LoadingStatus.success,
        //         posts: List.of(state.posts)..addAll(posts),
        //         hasReachedMax: false,
        //       ));
      }
    }
    catch(error){
      emit(state.copyWith(postStatus: LoadingStatus.failure));
    }
  }
  
  Future<void> _onPostAdded(PostAdded events, Emitter<PostsState> emit) async{
    List<Posts> currentListOfPosts = List.of(state.posts)..add(events.post);
    await http.post(Uri.parse("https://dummyjson.com/posts/add",),
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

    await http.delete(Uri.parse('https://dummyjson.com/posts/${event.post.id}'));
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
  AuthorizationProvider():super(const UnauthorizedState(loginError: false)){
    on<AuthorizedUserLogin>((event, emit) =>_loginUser(event, emit));
    on<AuthorizedUserLogout>((event, emit) =>  _logoutUser(event, emit));
    on<UnknownAuth>((event, emit) => _unknownLoginEvent(event, emit));
  }  

  void _unknownLoginEvent(UnknownAuth event, Emitter<AuthorizedUserState> emit) async{
    emit(UnknownAuthState()); 
    add(AuthorizedUserLogin(loginError: false));
  }

  Future<Map<String, dynamic>> generateToken(String? username, String? password) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    LoginUserModel userRequest = const LoginUserModel(username: "", password: "", expiresInMins: 30);
    if(username != null && password !=null){
      userRequest = LoginUserModel(username: username, password: password, expiresInMins: 540);
    }

    http.Response response = await http.post(Uri.parse("https://dummyjson.com/auth/login"), 
    headers:{
      'Content-Type': "application/json", 
    },
    body: jsonEncode({
      "username": username,
      "password": password,
      "expiresInMins": 540,
    })
    );
    if(response.statusCode == 200){
      String token = json.decode(response.body)["token"];
      sharedPreferences.setString("validTime", DateTime.now().add(const Duration(minutes: 540)).toIso8601String());
      sharedPreferences.setString("username", username!);
      sharedPreferences.setString("password", password!); 
      sharedPreferences.setString("token", token);
      final authResponse = await http.get(
      Uri.parse("https://dummyjson.com/auth/me"),
      headers: {
        'Authorization': token,
      }
      );
    if(authResponse.statusCode == 200){
      final Map<String,dynamic> data = json.decode(authResponse.body);
      Users user = Users.fromJson(data);
      return {"user": user,
        "authToken": token,
      };
    }
  }
      sharedPreferences.remove("validTime");
      sharedPreferences.remove("username");
      sharedPreferences.remove("password");
      sharedPreferences.remove("token");
      return {
        "user": null,
        "authToken": "",
      };
  
  }

  void _loginUser(AuthorizedUserLogin event, Emitter<AuthorizedUserState> emit) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    DateTime? validTime =  sharedPreferences.getString("validTime") != null ? DateTime.parse(sharedPreferences.getString("validTime")!) : null;
    Map<String, dynamic> result;
    emit(const LoadingLogInState());
    if(validTime == null || DateTime.now().millisecondsSinceEpoch> validTime.millisecondsSinceEpoch){
     result = await generateToken(event.username, event.password);
    }    
    else{
      String? username = sharedPreferences.getString("username");
      String? password = sharedPreferences.getString("password");
      result =  await generateToken(username, password);
    }
    if(result["user"] != null){
      emit(LoggedInState(user: result["user"], authToken: result["authToken"]));
      return;
    }
    emit(UnauthorizedState(loginError: event.loginError));
    } 
    
    void _logoutUser(AuthorizedUserLogout event, Emitter<AuthorizedUserState> emit) async{
      emit(const UnauthorizedState(loginError: false));
    }
}