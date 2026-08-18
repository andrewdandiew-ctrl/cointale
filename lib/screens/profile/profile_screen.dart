import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shared_widgets.dart';
import '../auth/sign_in_screen.dart';
import '../welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    CircleIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    if (FirebaseAuth.instance.currentUser == null)
                      TextButton.icon(
                        onPressed: () => Navigator.of(
                          context,
                        ).pushNamed(SignInScreen.routeName),
                        icon: const Icon(Icons.login, size: 18),
                        label: const Text('Sign in or sign up'),
                      )
                    else
                      TextButton.icon(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              WelcomeScreen.routeName,
                              (_) => false,
                            );
                          }
                        },
                        icon: const Icon(Icons.logout, size: 18),
                        label: const Text('Sign out'),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.goldLight, AppColors.gold],
                      ),
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _SignedInUserName(),
                  const SizedBox(height: 4),
                  const PillTag(label: 'Master Collector'),
                  const SizedBox(height: 24),
                  const _ProfileStats(),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Recent Badges',
              actionLabel: 'View all',
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                children: const [
                  _BadgeItem(
                    icon: Icons.auto_awesome,
                    label: 'First Scan',
                    color: AppColors.gold,
                  ),
                  _BadgeItem(
                    icon: Icons.history_edu,
                    label: 'Historian',
                    color: AppColors.purple,
                  ),
                  _BadgeItem(
                    icon: Icons.verified_user,
                    label: 'Eagle Eye',
                    color: AppColors.success,
                  ),
                  _BadgeItem(
                    icon: Icons.groups,
                    label: 'Club Member',
                    color: AppColors.navy,
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Story Bookmarks',
              actionLabel: 'See all',
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final video = MockData.storyVideos[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: _BookmarkCard(video: video),
              );
            }, childCount: MockData.storyVideos.length),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _SignedInUserName extends StatelessWidget {
  const _SignedInUserName();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Text('user', style: Theme.of(context).textTheme.headlineMedium);
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        final firestoreName = snapshot.data?.data()?['name'] as String?;
        final name = firestoreName?.trim().isNotEmpty == true
            ? firestoreName!
            : (user.displayName?.trim().isNotEmpty == true
                  ? user.displayName!
                  : 'Collector');
        return Text(name, style: Theme.of(context).textTheme.headlineMedium);
      },
    );
  }
}

class _ProfileStats extends StatelessWidget {
  const _ProfileStats();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        children: [
          _StatItem(value: '42', label: 'coins owned'),
          _StatItem(
            value: '\$3,240',
            label: 'collection value',
            highlight: true,
          ),
          _StatItem(value: '12', label: 'badges'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    this.highlight = false,
  });

  final String value;
  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: highlight ? AppColors.goldDark : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _BadgeItem extends StatelessWidget {
  const _BadgeItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  const _BookmarkCard({required this.video});

  final StoryVideo video;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: video.gradient),
            ),
            child: const Center(
              child: Icon(
                Icons.play_circle_fill,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${video.duration} · ${video.category}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
