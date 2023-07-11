import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_3/services/http_get_service.dart';
import '../models/post.dart';

final postsProvider = StateNotifierProvider<PostsNotifier, PostState>(
  (ref) => PostsNotifier(),
);

@immutable
abstract class PostState {}

class InitialPostState extends PostState {}

class PostsLoadingPostState extends PostState {}

class PostsLoadedPostState extends PostState {
  @override
  late final List<Post> posts;
  PostsLoadedPostState({
    required this.posts,
  });
}

class ErrorPostsState extends PostState {
  @override
  late final String message;
  ErrorPostsState({
    required this.message,
  });

}

class PostsNotifier extends StateNotifier<PostState> {
  @override
  PostsNotifier() : super(InitialPostState());
  final HttpGetPost _httpGetPost = HttpGetPost();

  fetchPosts() async {
    try {
      state = PostsLoadingPostState();
      List<Post> posts = await _httpGetPost.getPosts();
      state = PostsLoadedPostState(posts: posts);
    } catch (e) {
      state = ErrorPostsState(message: e.toString());
    }
  }
}
