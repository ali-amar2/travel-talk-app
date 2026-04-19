import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_talk/features/auth/data/repositories/user_repository.dart';
import 'package:travel_talk/features/auth/presentation/screens/login_screen.dart';
import 'package:travel_talk/features/home/presentation/widgets/firestore_post_card.dart';
import 'package:travel_talk/features/posts/data/repositories/post_repository.dart';
import 'package:travel_talk/features/posts/domain/entities/user_post.dart';
import 'package:travel_talk/features/profile/presentation/screens/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showLikedPosts = false;

  final UserRepository _userRepository = UserRepository();
  final PostRepository _postRepository = PostRepository();

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _openEditProfile({
    required String uid,
    required String name,
    required String bio,
    required String photoUrl,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          uid: uid,
          initialName: name,
          initialBio: bio,
          initialPhotoUrl: photoUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text('No user found')));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: SafeArea(
        child: StreamBuilder<Map<String, dynamic>?>(
          stream: _userRepository.watchUser(currentUser.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final userData = snapshot.data;

            final String name =
                (userData?['name'] as String?)?.trim().isNotEmpty == true
                ? userData!['name'] as String
                : (currentUser.displayName?.trim().isNotEmpty == true
                      ? currentUser.displayName!
                      : 'User Name');

            final String bio = (userData?['bio'] as String?) ?? '';
            final String photoUrl = (userData?['photoUrl'] as String?) ?? '';

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 110),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 135,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1296DB),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _CircleIconButton(
                                icon: Icons.logout_rounded,
                                onTap: _logout,
                              ),
                              _CircleIconButton(
                                icon: Icons.settings_rounded,
                                onTap: () => _openEditProfile(
                                  uid: currentUser.uid,
                                  name: name,
                                  bio: bio,
                                  photoUrl: photoUrl,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -34,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 31,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: photoUrl.isNotEmpty
                                ? NetworkImage(photoUrl)
                                : null,
                            child: photoUrl.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    size: 34,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 46),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0D1B3E),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    currentUser.email ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7F88A3),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bio.isEmpty ? 'No bio yet' : bio,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6D7690),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F1F5),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _TabButton(
                            title: 'My Posts',
                            isSelected: !_showLikedPosts,
                            onTap: () {
                              setState(() {
                                _showLikedPosts = false;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: _TabButton(
                            title: 'Liked Posts',
                            isSelected: _showLikedPosts,
                            onTap: () {
                              setState(() {
                                _showLikedPosts = true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _showLikedPosts
                      ? _buildLikedPosts(currentUser.uid)
                      : _buildMyPosts(currentUser.uid),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLikedPosts(String userId) {
    return StreamBuilder<List<UserPost>>(
      stream: _postRepository.watchLikedPosts(userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Text(
              'Failed to load liked posts: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: CircularProgressIndicator(),
          );
        }

        final posts = snapshot.data ?? [];

        if (posts.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.favorite_border_rounded,
                  size: 38,
                  color: Color(0xFF9AA3B2),
                ),
                SizedBox(height: 12),
                Text(
                  'No liked posts yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D1B3E),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Posts you like will appear here.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF7F88A3)),
                ),
              ],
            ),
          );
        }

        return Column(
          children: List.generate(
            posts.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index == posts.length - 1 ? 0 : 16,
              ),
              child: FirestorePostCard(post: posts[index]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMyPosts(String userId) {
    return StreamBuilder<List<UserPost>>(
      stream: _postRepository.watchUserPosts(userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Text(
              'Failed to load posts: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: CircularProgressIndicator(),
          );
        }

        final posts = snapshot.data ?? [];

        if (posts.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.post_add_rounded,
                  size: 38,
                  color: Color(0xFF9AA3B2),
                ),
                SizedBox(height: 12),
                Text(
                  'No posts yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D1B3E),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Your posts will appear here.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF7F88A3)),
                ),
              ],
            ),
          );
        }

        return Column(
          children: List.generate(
            posts.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index == posts.length - 1 ? 0 : 16,
              ),
              child: FirestorePostCard(post: posts[index]),
            ),
          ),
        );
      },
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.22), width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSelected
                ? const Color(0xFF0D1B3E)
                : const Color(0xFF7F88A3),
          ),
        ),
      ),
    );
  }
}
