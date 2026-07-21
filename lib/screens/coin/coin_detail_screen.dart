import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shared_widgets.dart';

class CoinDetailScreen extends StatelessWidget {
  const CoinDetailScreen({
    super.key,
    required this.coin,
    required this.onVerify,
  });

  static const routeName = '/coin';

  final Coin coin;
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    const CoinHero(),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            CircleIconButton(
                              icon: Icons.arrow_back,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            const Spacer(),
                            const CircleIconButton(icon: Icons.bookmark_border),
                            const SizedBox(width: 8),
                            const CircleIconButton(icon: Icons.share_outlined),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              'Identified · ${coin.matchPercent}% match',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coin.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          PillTag(label: '🇺🇸 ${coin.country}'),
                          PillTag(label: coin.composition),
                          PillTag(label: coin.mint),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _MarketDataCard(coin: coin),
                      const SizedBox(height: 28),
                      Text(
                        'Watch its story',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      _StoryVideoThumbnail(coin: coin),
                      const SizedBox(height: 28),
                      Text(
                        coin.provenanceTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Every Morgan dollar carries a piece of American history. '
                        'Minted after the Comstock Lode discovery flooded the nation '
                        'with silver, this coin spent decades in circulation before '
                        'finding its way to your collection.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.6,
                            ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).padding.bottom + 16,
            child: Row(
              children: [
                Expanded(
                  child: NavyButton(
                    label: 'Add to collection',
                    icon: Icons.add,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GoldButton(
                    label: 'Verify it\'s real',
                    icon: Icons.verified_user_outlined,
                    onPressed: onVerify,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MarketDataCard extends StatelessWidget {
  const _MarketDataCard({required this.coin});

  final Coin coin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
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
      child: Row(
        children: [
          _MarketStat(
            value: coin.marketValueRange,
            label: 'market value',
            highlight: true,
          ),
          _MarketStat(value: coin.mintage, label: 'minted'),
          _MarketStat(value: coin.rarity, label: 'rarity'),
        ],
      ),
    );
  }
}

class _MarketStat extends StatelessWidget {
  const _MarketStat({
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
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _StoryVideoThumbnail extends StatelessWidget {
  const _StoryVideoThumbnail({required this.coin});

  final Coin coin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF5D4037), Color(0xFF3E2723)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 16,
            top: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                coin.storyDuration,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          const Center(
            child: Icon(Icons.play_circle_fill, color: Colors.white, size: 52),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coin.storyTitle,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  coin.storySubtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
