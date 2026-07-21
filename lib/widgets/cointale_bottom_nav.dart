import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum NavTab { discover, stories, scan, market, club }

class CointaleBottomNav extends StatelessWidget {
  const CointaleBottomNav({
    super.key,
    required this.current,
    required this.onTap,
  });

  final NavTab current;
  final ValueChanged<NavTab> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.explore_outlined,
                label: 'Discover',
                selected: current == NavTab.discover,
                onTap: () => onTap(NavTab.discover),
              ),
              _NavItem(
                icon: Icons.menu_book_outlined,
                label: 'Stories',
                selected: current == NavTab.stories,
                onTap: () => onTap(NavTab.stories),
              ),
              _ScanButton(onTap: () => onTap(NavTab.scan)),
              _NavItem(
                icon: Icons.storefront_outlined,
                label: 'Market',
                selected: current == NavTab.market,
                onTap: () => onTap(NavTab.market),
              ),
              _NavItem(
                icon: Icons.groups_outlined,
                label: 'Club',
                selected: current == NavTab.club,
                onTap: () => onTap(NavTab.club),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.goldDark : AppColors.textMuted;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.translate(
        offset: const Offset(0, -16),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.goldLight, AppColors.gold],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.camera_alt, color: AppColors.navyDark, size: 26),
        ),
      ),
    );
  }
}
