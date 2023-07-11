import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_3/models/post.dart';
import 'package:riverpod_3/state/post_state.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("API with Riverpod"),
      ),
      body: Center(
        child: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
          PostState state =  ref.watch(postsProvider);
          print(state.runtimeType);
          if(state is InitialPostState){
            return Text("Perss FAB to Fetch Data");
          }
          if(state is PostsLoadingPostState){
            return CircularProgressIndicator();
          }
          if(state is ErrorPostsState){
            return Text(state.message);
          }
          if(state is PostsLoadedPostState){
            return _buildListView(state);
          }
          return Text("Nothing Found");
        },

        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(postsProvider.notifier).fetchPosts();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

ListView _buildListView(PostsLoadedPostState state){
  
  return ListView.builder(
    itemCount: state.posts.length,
      itemBuilder: (context, index){
      Post post = state.posts[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(
              post.id.toString(),
            ),
          ),
          title: Text(post.title),
        );
  });
}