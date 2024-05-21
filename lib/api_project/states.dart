import 'package:equatable/equatable.dart';
import 'package:flutter_intern/api_project/models.dart';

enum LoadingStatus{initial, loading, success, failure}

class PostsState extends Equatable{

  const PostsState({
    this.postStatus = LoadingStatus.initial,
    this.posts = const [],
    this.hasReachedMax =false,
    required this.pageNo,
    });

  PostsState copyWith({
    LoadingStatus? postStatus,
    List<Posts>? posts,
    bool? hasReachedMax,
    int pageNo = 0,
  }){
    return PostsState(
      postStatus: postStatus?? this.postStatus,
      posts: posts?? this.posts,
      hasReachedMax: hasReachedMax?? this.hasReachedMax,
      pageNo: pageNo,
    );
  }
  final LoadingStatus postStatus; 
  final List<Posts> posts;
  final bool hasReachedMax;
  final int pageNo;
  
  @override
  List<Object> get props => [postStatus, posts, hasReachedMax];

}

class SingularPostState extends Equatable{

  const SingularPostState({this.post, this.postStatus = LoadingStatus.initial});

  final Posts? post;
  final LoadingStatus postStatus;
  
  @override
  List<Object?> get props => [post, postStatus];

}

class CommentState extends Equatable{
  const CommentState({
    this.commentStatus = LoadingStatus.initial, 
    this.comments = const [],
    this.hasReachedMax = false}); 
  final LoadingStatus commentStatus;
  final List<Comment> comments;
  final bool hasReachedMax;
  
  @override
  List<Object> get props => [commentStatus, comments, hasReachedMax];

}

class UsersState extends Equatable{
  const UsersState({required this.loadingStatus, required this.user}); 
  final LoadingStatus loadingStatus;
  final Users user;
  
  @override
  List<Object?> get props => [];

}

class AuthorizedUserState extends Equatable{
  const AuthorizedUserState({
    this.user,
    this.isLoggedIn = false,
    this.authToken,
    this.loginError = false,
    }); 
  final String? authToken;
  final bool isLoggedIn;
  final Users? user;
  final bool loginError;
  
  @override
  List<Object?> get props => [loginError,authToken,user, isLoggedIn];

}

class LoggedInState extends AuthorizedUserState{
  final Users user;
  final String authToken;
  const LoggedInState({required this.user, required this.authToken}):
  super(authToken: authToken,user: user, isLoggedIn: true, loginError: false);
}

class UnauthorizedState extends AuthorizedUserState{
  final bool loginError;
  const UnauthorizedState({required this.loginError}):super(user: null, isLoggedIn: false, authToken: null, loginError: loginError);
}

class UnknownAuthState extends AuthorizedUserState{ }

class LoadingLogInState extends AuthorizedUserState{
  const LoadingLogInState():super(user: null, isLoggedIn: false, authToken: null, loginError: false,);
}