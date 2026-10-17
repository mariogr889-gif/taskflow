import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'posts_service.dart';
import 'post.dart';
import 'package:http/http.dart' as http;

class PostsState {
  final List<Post> posts;
  final bool isLoading;
  final bool isFetchingNextPage;
  final int currentPage;
  final bool hasMore;
  final String? errorMessage;

  const PostsState({
    this.posts = const [],
    this.isLoading = false,
    this.isFetchingNextPage = false,
    this.currentPage = 1,
    this.hasMore = true,
    this.errorMessage,
  });

  PostsState copyWith({
    List<Post>? posts,
    bool? isLoading,
    bool? isFetchingNextPage,
    int? currentPage,
    bool? hasMore,
    String? errorMessage,
  }) {
    return PostsState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      isFetchingNextPage: isFetchingNextPage ?? this.isFetchingNextPage,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
    );
  }
}

class PostsNotifier extends Notifier<PostsState> {
  late final PostsService _service;

  @override
  PostsState build() {
    _service = ref.read(postsServiceProvider);
    // Disparamos la carga inicial de manera asíncrona después de que el build termine
    Future.microtask(() => fetchInitialPosts());
    return const PostsState(isLoading: true);
  }

  Future<void> fetchInitialPosts() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final newPosts = await _service.getPosts(page: 1, limit: 15);
      state = state.copyWith(
        posts: newPosts,
        isLoading: false,
        currentPage: 1,
        hasMore: newPosts.length == 15,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> fetchNextPage() async {
    if (state.isFetchingNextPage || !state.hasMore || state.isLoading) return;

    state = state.copyWith(isFetchingNextPage: true);
    final nextPage = state.currentPage + 1;

    try {
      final newPosts = await _service.getPosts(page: nextPage, limit: 15);
      state = state.copyWith(
        posts: [...state.posts, ...newPosts],
        isFetchingNextPage: false,
        currentPage: nextPage,
        hasMore: newPosts.length == 15,
      );
    } catch (e) {
      state = state.copyWith(isFetchingNextPage: false);
    }
  }

  Future<void> refresh() async {
    await fetchInitialPosts();
  }
}

final postsServiceProvider = Provider<PostsService>((ref) {
  return PostsService(http.Client());
});

final postsNotifierProvider = NotifierProvider<PostsNotifier, PostsState>(() {
  return PostsNotifier();
});