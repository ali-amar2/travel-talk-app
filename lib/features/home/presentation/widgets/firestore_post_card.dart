import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_talk/features/auth/data/repositories/user_repository.dart';
import 'package:travel_talk/features/posts/data/repositories/post_repository.dart';
import 'package:travel_talk/features/posts/domain/entities/user_post.dart';
import '../../../../core/theme/app_colors.dart';

class FirestorePostCard extends StatefulWidget {
  final UserPost post;

  const FirestorePostCard({super.key, required this.post});

  @override
  State<FirestorePostCard> createState() => _FirestorePostCardState();
}

class _FirestorePostCardState extends State<FirestorePostCard> {
  final PostRepository _postRepository = PostRepository();
  bool _isLiking = false;

  String _formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'Just now';

    final difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) return '${difference.inHours} hours ago';
    if (difference.inDays < 7) return '${difference.inDays} days ago';

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  Future<void> _toggleLike() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || _isLiking) return;

    setState(() => _isLiking = true);

    try {
      await _postRepository.toggleLike(
        post: widget.post,
        userId: currentUser.uid,
      );
    } finally {
      if (mounted) {
        setState(() => _isLiking = false);
      }
    }
  }

  Future<void> _likeOnDoubleTap() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || _isLiking) return;

    final isLiked = await _postRepository.isPostLiked(
      postId: widget.post.id,
      userId: currentUser.uid,
    );

    if (!isLiked) {
      await _toggleLike();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRepository = UserRepository();
    final currentUser = FirebaseAuth.instance.currentUser;

    return FutureBuilder<Map<String, dynamic>?>(
      future: userRepository.getUserById(widget.post.userId),
      builder: (context, snapshot) {
        final userData = snapshot.data;

        final String userName =
            (userData?['name'] as String?)?.trim().isNotEmpty == true
            ? userData!['name'] as String
            : 'Unknown User';

        final String photoUrl = (userData?['photoUrl'] as String?) ?? '';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PostHeader(
                userName: userName,
                photoUrl: photoUrl,
                timeAgo: _formatTimeAgo(widget.post.createdAt),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (widget.post.location.trim().isNotEmpty)
                    _PostLocationChip(location: widget.post.location),
                  if (widget.post.category.trim().isNotEmpty)
                    _PostCategoryChip(category: widget.post.category),
                ],
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onDoubleTap: _likeOnDoubleTap,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: AspectRatio(
                    aspectRatio: 1.25,
                    child: _buildPostImage(),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.post.description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),
              Divider(height: 1, color: Colors.grey.withOpacity(0.14)),
              const SizedBox(height: 12),
              _PostActions(
                postId: widget.post.id,
                userId: currentUser?.uid,
                onLikeTap: _toggleLike,
                repository: _postRepository,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPostImage() {
    if (widget.post.imageUrl.isEmpty) {
      return Container(
        color: Colors.grey.shade300,
        child: const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey,
            size: 34,
          ),
        ),
      );
    }

    return Image.network(
      widget.post.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade300,
          child: const Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: Colors.grey,
              size: 34,
            ),
          ),
        );
      },
    );
  }
}

class _PostHeader extends StatelessWidget {
  final String userName;
  final String photoUrl;
  final String timeAgo;

  const _PostHeader({
    required this.userName,
    required this.photoUrl,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFFE9EEF6),
          backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
          child: photoUrl.isEmpty
              ? const Icon(Icons.person, color: Color(0xFF7F88A3))
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                timeAgo,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PostLocationChip extends StatelessWidget {
  final String location;

  const _PostLocationChip({required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F8FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_on_rounded,
            size: 15,
            color: AppColors.primary,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              location,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCategoryChip extends StatelessWidget {
  final String category;

  const _PostCategoryChip({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFFB26A00),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PostActions extends StatelessWidget {
  final String postId;
  final String? userId;
  final VoidCallback onLikeTap;
  final PostRepository repository;

  const _PostActions({
    required this.postId,
    required this.userId,
    required this.onLikeTap,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        StreamBuilder<bool>(
          stream: repository.watchIsPostLiked(postId: postId, userId: userId!),
          builder: (context, likedSnapshot) {
            final isLiked = likedSnapshot.data ?? false;

            return InkWell(
              onTap: onLikeTap,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isLiked
                      ? Colors.red.withOpacity(0.08)
                      : const Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      isLiked
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 20,
                      color: isLiked ? Colors.red : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    StreamBuilder<int>(
                      stream: repository.watchLikesCount(postId),
                      builder: (context, countSnapshot) {
                        final likesCount = countSnapshot.data ?? 0;

                        return Text(
                          '$likesCount likes',
                          style: TextStyle(
                            color: isLiked
                                ? Colors.red
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const Spacer(),
        const Icon(
          Icons.share_outlined,
          size: 20,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}
