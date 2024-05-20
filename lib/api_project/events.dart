import 'package:equatable/equatable.dart';
import 'package:flutter_intern/api_project/models.dart';



class PostEvents extends Equatable{

  @override
  List<Object> get props => [];

}

class PostFetched extends PostEvents{}

class PostAdded extends PostEvents{

  final Posts post;
  PostAdded({required this.post});

}

class PostEdited extends PostEvents{}

class PostRemoved extends PostEvents{

  final Posts post;

  PostRemoved({required this.post});

}

class SingularPostEvents extends Equatable{
  @override
  List<Object?> get props => [];
}

class SingularPostFetched extends SingularPostEvents{
  final int postId;

  SingularPostFetched({required this.postId});

}

class CommentEvents extends Equatable{
  const CommentEvents({required this.postId});
  final int postId;
  @override
  List<Object?> get props => [postId];
}

class CommentsFetched extends CommentEvents{
  const CommentsFetched({required super.postId});
}

class CommentsAdded extends CommentEvents{
  const CommentsAdded({required super.postId});
}

class CommentsRemoved extends CommentEvents{
  const CommentsRemoved({required super.postId});
}

class CommentsUpdated extends CommentEvents{
  const CommentsUpdated({required super.postId});
}

class UsersEvents extends Equatable{
  @override
  List<Object?> get props => [];
}

class UserFetched extends UsersEvents{}

class AuthorizedUserEvents extends Equatable{

  @override
  List<Object?> get props => [];
}

class AuthorizedUserLogin extends AuthorizedUserEvents{}