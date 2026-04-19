import 'dart:io';

import 'package:flutter/material.dart';
import 'package:travel_talk/features/auth/data/repositories/user_repository.dart';
import 'package:travel_talk/features/posts/domain/entities/user_post.dart';

import '../../../../core/theme/app_colors.dart';

class FirestorePostCard extends StatelessWidget {
  final UserPost post;

  const FirestorePostCard({super.key, required this.post});

  String _formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'Just now';

    final difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) return '${difference.inHours} hours ago';
    if (difference.inDays < 7) return '${difference.inDays} days ago';

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    final userRepository = UserRepository();

    return FutureBuilder<Map<String, dynamic>?>(
      future: userRepository.getUserById(post.userId),
      builder: (context, snapshot) {
        final userData = snapshot.data;

        final String userName =
            (userData?['name'] as String?)?.trim().isNotEmpty == true
            ? userData!['name'] as String
            : 'Unknown User';

        final String photoUrl = (userData?['photoUrl'] as String?) ?? '';
        final String location =
            (userData?['bio'] as String?)?.trim().isNotEmpty == true
            ? userData!['bio'] as String
            : 'Travel Talk User';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 18,
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
                timeAgo: _formatTimeAgo(post.createdAt),
              ),
              const SizedBox(height: 14),
              _PostLocationChip(location: location),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _buildPostImage(),
              ),
              const SizedBox(height: 14),
              Text(
                post.description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              const _PostActions(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPostImage() {
    if (post.imagePath.isEmpty) {
      return Container(
        width: double.infinity,
        height: 180,
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

    final file = File(post.imagePath);

    return Image.file(
      file,
      width: double.infinity,
      height: 180,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: double.infinity,
          height: 180,
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
          radius: 20,
          backgroundColor: Colors.purple.shade100,
          backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
          child: photoUrl.isEmpty
              ? const Icon(Icons.person, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
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
        const Icon(
          Icons.bookmark_border_rounded,
          color: AppColors.textSecondary,
          size: 22,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F8FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_on_rounded,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: 4),
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

class _PostActions extends StatelessWidget {
  const _PostActions();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(
          Icons.favorite_border_rounded,
          size: 20,
          color: AppColors.textSecondary,
        ),
        SizedBox(width: 6),
        Text(
          '0',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 20),
        Icon(
          Icons.mode_comment_outlined,
          size: 20,
          color: AppColors.textSecondary,
        ),
        SizedBox(width: 6),
        Text(
          '0',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacer(),
        Icon(Icons.share_outlined, size: 20, color: AppColors.textSecondary),
      ],
    );
  }
}
