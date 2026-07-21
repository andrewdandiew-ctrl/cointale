import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shared_widgets.dart';

class ListCoinScreen extends StatefulWidget {
  const ListCoinScreen({super.key});

  static const routeName = '/list-coin';

  @override
  State<ListCoinScreen> createState() => _ListCoinScreenState();
}

class _ListCoinScreenState extends State<ListCoinScreen> {
  int _listingType = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: CircleIconButton(
          icon: Icons.close,
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text('List a Coin'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _PhotoSlot(label: 'OBVERSE', filled: true),
                const SizedBox(width: 12),
                _PhotoSlot(label: 'REVERSE', filled: true),
                const SizedBox(width: 12),
                _PhotoSlot(label: 'Add photo', filled: false),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.auto_fix_high, color: AppColors.success, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Auto-filled from your scan',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        Text(
                          '${MockData.tradeDollar.name} · Verified 92/100 attached',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('I want to...', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _TypeOption(
                    label: 'Sell',
                    selected: _listingType == 0,
                    onTap: () => setState(() => _listingType = 0),
                  ),
                  _TypeOption(
                    label: 'Sell or trade',
                    selected: _listingType == 1,
                    onTap: () => setState(() => _listingType = 1),
                  ),
                  _TypeOption(
                    label: 'Trade only',
                    selected: _listingType == 2,
                    onTap: () => setState(() => _listingType = 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Asking price', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Text(
                    '\$ 54',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'MARKET EST.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              letterSpacing: 0.5,
                            ),
                      ),
                      const Text(
                        '\$48 – \$62',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: AppColors.goldDark),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Fair price based on 214 recent deals for this coin',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'How buyers reach you',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _ToggleRow(
              icon: Icons.chat_bubble_outline,
              iconColor: AppColors.gold,
              title: 'In-app messages',
              subtitle: 'Buyers contact you in chat — no payment in app',
              value: true,
            ),
            const SizedBox(height: 8),
            _ToggleRow(
              icon: Icons.location_on_outlined,
              iconColor: AppColors.purple,
              title: 'Meet at club events',
              subtitle: 'Show as available at Bay Area meetups',
              value: true,
            ),
            const SizedBox(height: 32),
            GoldButton(
              label: 'Publish Listing',
              icon: Icons.sell_outlined,
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _PhotoSlot extends StatelessWidget {
  const _PhotoSlot({required this.label, required this.filled});

  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: filled ? Colors.grey.shade200 : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: filled
                ? null
                : Border.all(color: AppColors.textMuted, style: BorderStyle.solid),
          ),
          child: filled
              ? Stack(
                  children: [
                    Center(
                      child: Icon(Icons.monetization_on, size: 40, color: Colors.grey.shade400),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          label,
                          style: const TextStyle(color: Colors.white, fontSize: 9),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined, color: AppColors.textMuted),
                    const SizedBox(height: 4),
                    Text(label, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
        ),
      ),
    );
  }
}

class _TypeOption extends StatelessWidget {
  const _TypeOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.navy : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (_) {},
            activeTrackColor: AppColors.gold,
            activeThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
