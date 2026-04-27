import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/social_models.dart';

class SocialFeedService {
  static final SocialFeedService _instance = SocialFeedService._internal();
  factory SocialFeedService() => _instance;
  SocialFeedService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Create post
  Future<Post> createPost({
    required PostType type,
    required String content,
    PostVisibility visibility = PostVisibility.friends,
    List<String>? mediaUrls,
    List<String>? taggedUserIds,
    String? venueId,
    String? eventId,
    String? reviewId,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('posts').insert({
        'user_id': currentUser.id,
        'type': type.name,
        'content': content,
        'visibility': visibility.name,
        'media_urls': mediaUrls ?? [],
        'tagged_user_ids': taggedUserIds ?? [],
        'venue_id': venueId,
        'event_id': eventId,
        'review_id': reviewId,
      }).select('*, author:users!user_id(*)').single();

      return Post.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  // Get feed (user's and friends' posts)
  Future<List<Post>> getFeed({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase.rpc('get_social_feed', params: {
        'user_id_param': currentUser.id,
        'limit_param': limit,
        'offset_param': offset,
      });

      return (response as List)
          .map((item) => Post.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get user posts
  Future<List<Post>> getUserPosts({
    required String userId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('posts')
          .select('*, author:users!user_id(*), tagged_users:users!tagged_user_ids(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((item) => Post.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get post by ID
  Future<Post?> getPost(String postId) async {
    try {
      final response = await _supabase
          .from('posts')
          .select('*, author:users!user_id(*), comments(*)')
          .eq('id', postId)
          .maybeSingle();

      if (response == null) return null;

      return Post.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Update post
  Future<Post> updatePost({
    required String postId,
    String? content,
    PostVisibility? visibility,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (content != null) updates['content'] = content;
      if (visibility != null) updates['visibility'] = visibility.name;
      updates['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabase
          .from('posts')
          .update(updates)
          .eq('id', postId)
          .select('*, author:users!user_id(*)')
          .single();

      return Post.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }

  // Delete post
  Future<void> deletePost(String postId) async {
    try {
      await _supabase.from('posts').delete().eq('id', postId);
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  // Like post
  Future<void> likePost(String postId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('post_likes').insert({
        'post_id': postId,
        'user_id': currentUser.id,
      });
    } catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }

  // Unlike post
  Future<void> unlikePost(String postId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase
          .from('post_likes')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', currentUser.id);
    } catch (e) {
      throw Exception('Failed to unlike post: $e');
    }
  }

  // Get post likes
  Future<List<UserProfile>> getPostLikes(String postId) async {
    try {
      final response = await _supabase
          .from('post_likes')
          .select('user:users!user_id(*)')
          .eq('post_id', postId);

      return (response as List)
          .map((item) => UserProfile.fromSupabase(item['user'] as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Add comment
  Future<Comment> addComment({
    required String postId,
    required String content,
    String? parentCommentId,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase.from('comments').insert({
        'post_id': postId,
        'user_id': currentUser.id,
        'content': content,
        'parent_comment_id': parentCommentId,
      }).select('*, author:users!user_id(*)').single();

      return Comment.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  // Get comments
  Future<List<Comment>> getComments({
    required String postId,
    int limit = 50,
  }) async {
    try {
      final response = await _supabase
          .from('comments')
          .select('*, author:users!user_id(*)')
          .eq('post_id', postId)
          .is_('parent_comment_id', null)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((item) => Comment.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get comment replies
  Future<List<Comment>> getCommentReplies({
    required String commentId,
    int limit = 20,
  }) async {
    try {
      final response = await _supabase
          .from('comments')
          .select('*, author:users!user_id(*)')
          .eq('parent_comment_id', commentId)
          .order('created_at', ascending: true)
          .limit(limit);

      return (response as List)
          .map((item) => Comment.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Update comment
  Future<Comment> updateComment({
    required String commentId,
    required String content,
  }) async {
    try {
      final response = await _supabase.from('comments').update({
        'content': content,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', commentId).select('*, author:users!user_id(*)').single();

      return Comment.fromSupabase(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update comment: $e');
    }
  }

  // Delete comment
  Future<void> deleteComment(String commentId) async {
    try {
      await _supabase.from('comments').delete().eq('id', commentId);
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }

  // Like comment
  Future<void> likeComment(String commentId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('comment_likes').insert({
        'comment_id': commentId,
        'user_id': currentUser.id,
      });
    } catch (e) {
      throw Exception('Failed to like comment: $e');
    }
  }

  // Unlike comment
  Future<void> unlikeComment(String commentId) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase
          .from('comment_likes')
          .delete()
          .eq('comment_id', commentId)
          .eq('user_id', currentUser.id);
    } catch (e) {
      throw Exception('Failed to unlike comment: $e');
    }
  }

  // Share post
  Future<void> sharePost({
    required String postId,
    String? message,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      await _supabase.from('post_shares').insert({
        'post_id': postId,
        'user_id': currentUser.id,
        'message': message,
      });

      // Increment shares count
      await _supabase.rpc('increment_post_shares', params: {
        'post_id_param': postId,
      });
    } catch (e) {
      throw Exception('Failed to share post: $e');
    }
  }

  // Report post
  Future<void> reportPost({
    required String postId,
    required String reason,
    String? description,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return;

      await _supabase.from('post_reports').insert({
        'post_id': postId,
        'reporter_id': currentUser.id,
        'reason': reason,
        'description': description,
      });
    } catch (e) {
      throw Exception('Failed to report post: $e');
    }
  }

  // Get trending posts
  Future<List<Post>> getTrendingPosts({
    int limit = 20,
    Duration timeWindow = const Duration(days: 7),
  }) async {
    try {
      final since = DateTime.now().subtract(timeWindow).toIso8601String();

      final response = await _supabase.rpc('get_trending_posts', params: {
        'since_param': since,
        'limit_param': limit,
      });

      return (response as List)
          .map((item) => Post.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get venue posts
  Future<List<Post>> getVenuePosts({
    required String venueId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('posts')
          .select('*, author:users!user_id(*)')
          .eq('venue_id', venueId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((item) => Post.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get event posts
  Future<List<Post>> getEventPosts({
    required String eventId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('posts')
          .select('*, author:users!user_id(*)')
          .eq('event_id', eventId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((item) => Post.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get posts where user is tagged
  Future<List<Post>> getTaggedPosts({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase
          .from('posts')
          .select('*, author:users!user_id(*)')
          .contains('tagged_user_ids', [currentUser.id])
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((item) => Post.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Search posts
  Future<List<Post>> searchPosts({
    required String query,
    int limit = 20,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _supabase.rpc('search_posts', params: {
        'search_query': query,
        'user_id_param': currentUser.id,
        'limit_param': limit,
      });

      return (response as List)
          .map((item) => Post.fromSupabase(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
