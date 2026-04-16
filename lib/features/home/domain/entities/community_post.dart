class CommunityPost {
  final String userName;
  final String userImage;
  final String timeAgo;
  final String location;
  final String postImage;
  final String content;
  final int likesCount;
  final int commentsCount;
  final bool isSaved;

  const CommunityPost({
    required this.userName,
    required this.userImage,
    required this.timeAgo,
    required this.location,
    required this.postImage,
    required this.content,
    required this.likesCount,
    required this.commentsCount,
    this.isSaved = false,
  });
}
