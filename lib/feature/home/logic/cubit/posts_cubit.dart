import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:task_progress_soft/feature/home/data/models/post_models.dart';
import 'package:task_progress_soft/feature/home/logic/cubit/posts_state.dart';


class PostCubit extends Cubit<PostState> {
  final Dio _dio;
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  PostCubit(this._dio) : super(PostState(
    posts: [],
    filteredPosts: [],
    isLoading: false,
    error: '',
  ));

  Future<void> fetchPosts() async {
    try {
      emit(state.copyWith(isLoading: true));
      final response = await _dio.get('$baseUrl/posts');
      final List<Post> posts = (response.data as List)
          .map((post) => Post.fromJson(post))
          .toList();
      emit(state.copyWith(
        posts: posts,
        filteredPosts: posts,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void searchPosts(String query) {
    final lowerCaseQuery = query.toLowerCase();
    final filteredPosts = state.posts.where((post) {
      return post.title.toLowerCase().contains(lowerCaseQuery) ||
             post.body.toLowerCase().contains(lowerCaseQuery);
    }).toList();

    emit(state.copyWith(
      filteredPosts: filteredPosts,
      isLoading: false,
    ));
  }
}
