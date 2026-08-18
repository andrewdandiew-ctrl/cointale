import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shared_widgets.dart';
import '../coin/coin_detail_screen.dart';
import '../profile/profile_screen.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key, required this.onScan});

  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _UserGreeting(),
                        const SizedBox(height: 4),
                        Text(
                          'Discover',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(
                      context,
                    ).pushNamed(ProfileScreen.routeName),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.gold.withValues(alpha: 0.8),
                            AppColors.goldDark,
                          ],
                        ),
                      ),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _ScanCtaCard(onScan: onScan),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 28)),
          const SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Story of the day',
              trailing: 'Ancient Rome',
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _StoryOfDayCard(
                onTap: () => Navigator.of(context).pushNamed(
                  CoinDetailScreen.routeName,
                  arguments: MockData.morganDollar,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _StatsBar(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 28)),
          const SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Explore by era',
              actionLabel: 'See all',
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: MockData.eraCards.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return _EraCardWidget(era: MockData.eraCards[index]);
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _UserGreeting extends StatelessWidget {
  const _UserGreeting();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    if (user == null) {
      return Text('Good morning, user', style: textStyle);
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
        return Text('Good morning, $name', style: textStyle);
      },
    );
  }
}

class _ScanCtaCard extends StatelessWidget {
  const _ScanCtaCard({required this.onScan});

  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FOUND A COIN?\nPoint. Snap. Discover its past.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Material(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    onTap: onScan,
                    borderRadius: BorderRadius.circular(24),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: AppColors.navyDark,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Scan a coin',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navyDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: Center(
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.grey.shade300, Colors.grey.shade600],
                  ),
                ),
                child: Icon(Icons.monetization_on, color: Colors.grey.shade200),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryOfDayCard extends StatelessWidget {
  const _StoryOfDayCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6D4C41), Color(0xFF3E2723)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: 20,
              child: Icon(
                Icons.monetization_on,
                size: 120,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '4:32',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 48,
                  ),
                  const Spacer(),
                  const Text(
                    'The Denarius That Paid Rome\'s Legions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const AvatarStack(count: 3, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        '128k watching this week',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  const _StatsBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          _StatItem(value: '12.4k', label: 'coins ID\'d today'),
          _StatItem(value: '98.2%', label: 'ID accuracy', highlight: true),
          _StatItem(value: '3.1M', label: 'stories watched'),
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

class _EraCardWidget extends StatelessWidget {
  const _EraCardWidget({required this.era});

  final EraCard era;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: era.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            era.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            era.subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
