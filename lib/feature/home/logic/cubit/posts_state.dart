
import 'package:task_progress_soft/feature/home/data/models/post_models.dart';

class PostState {
  final List<Post> posts;
  final List<Post> filteredPosts;
  final bool isLoading;
  final String error;

  PostState({
    required this.posts,
    required this.filteredPosts,
    required this.isLoading,
    required this.error,
  });

  PostState copyWith({
    List<Post>? posts,
    List<Post>? filteredPosts,
    bool? isLoading,
    String? error,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      filteredPosts: filteredPosts ?? this.filteredPosts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
