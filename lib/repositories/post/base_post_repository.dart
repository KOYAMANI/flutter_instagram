import 'package:flutter_instagram_clone/models/models.dart';

abstract class BasePostRepository{
  Future<void> createPost({Post post});
  Future<void> createComment({Comment comment});
  Stream<List<Future<Post>>> getUserPosts({String userId});
  Stream<List<Future<Comment>>> getPostsComments({String postId});
  Future<List<Post>> getUserFeed({String userId});
}