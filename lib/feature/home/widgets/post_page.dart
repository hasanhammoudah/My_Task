import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_progress_soft/core/widgets/app_text_form_field.dart';
import 'package:task_progress_soft/feature/home/logic/cubit/posts_cubit.dart';
import 'package:task_progress_soft/feature/home/logic/cubit/posts_state.dart';

class PostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postCubit = context.read<PostCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        leading: const SizedBox.shrink(),
        excludeHeaderSemantics: false,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppTextFormField(
              hintText: 'Search',
              onChanged: (value) {
                if (value.isEmpty) {
                  postCubit.fetchPosts();
                } else {
                  postCubit.searchPosts(value);
                }
              },
              validator: (String? d) {},
            ),
          ),
          Expanded(
            child: BlocBuilder<PostCubit, PostState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.error.isNotEmpty) {
                  return Center(child: Text('Error: ${state.error}'));
                } else if (state.filteredPosts.isEmpty) {
                  return const Center(child: Text('No posts found.'));
                } else {
                  return ListView.builder(
                    itemCount: state.filteredPosts.length,
                    itemBuilder: (context, index) {
                      final post = state.filteredPosts[index];
                      return ListTile(
                        title: Text(post.title),
                        subtitle: Text(post.body),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
