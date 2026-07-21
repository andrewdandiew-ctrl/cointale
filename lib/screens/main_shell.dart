import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/cointale_bottom_nav.dart';
import 'club/club_screen.dart';
import 'coin/authenticity_screen.dart';
import 'coin/coin_detail_screen.dart';
import 'discover/discover_screen.dart';
import 'market/chat_screen.dart';
import 'market/list_coin_screen.dart';
import 'market/listing_detail_screen.dart';
import 'market/market_screen.dart';
import 'scan/scan_screen.dart';
import 'stories/stories_screen.dart';
import 'welcome_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  static const routeName = '/main';

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  NavTab _current = NavTab.discover;

  void _onNavTap(NavTab tab) {
    if (tab == NavTab.scan) {
      Navigator.of(context).pushNamed(ScanScreen.routeName);
      return;
    }
    setState(() => _current = tab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _current.index,
        children: [
          DiscoverScreen(onScan: () => _onNavTap(NavTab.scan)),
          const StoriesScreen(),
          const SizedBox.shrink(),
          MarketScreen(
            onListCoin: () =>
                Navigator.of(context).pushNamed(ListCoinScreen.routeName),
            onOpenListing: () => Navigator.of(context).pushNamed(
              ListingDetailScreen.routeName,
              arguments: MockData.listings.first,
            ),
            onOpenChat: () =>
                Navigator.of(context).pushNamed(ChatScreen.routeName),
          ),
          const ClubScreen(),
        ],
      ),
      bottomNavigationBar: CointaleBottomNav(
        current: _current,
        onTap: _onNavTap,
      ),
    );
  }
}
