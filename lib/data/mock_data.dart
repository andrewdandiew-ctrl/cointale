import 'package:flutter/material.dart';

import '../models/models.dart';

abstract final class MockData {
  static const userName = 'Daniel';

  static const morganDollar = Coin(
    id: '1921-morgan',
    name: '1921 Morgan Silver Dollar',
    shortName: '1921 Morgan Dollar',
    country: 'United States',
    material: 'Silver',
    composition: '90% Silver',
    mint: 'Philadelphia Mint',
    matchPercent: 98,
    marketValueLow: 38,
    marketValueHigh: 62,
    mintage: '44.6M',
    rarity: 'R-2',
    storyTitle: 'Silver from the Comstock Lode',
    storySubtitle: 'How one mine flooded America with silver dollars',
    storyDuration: '3:05',
    provenanceTitle: 'A century in your hand',
    authenticityScore: 94,
  );

  static const tradeDollar = Coin(
    id: '1873-trade',
    name: '1873 Trade Dollar',
    shortName: '1873 Trade Dollar',
    country: 'United States',
    material: 'Silver',
    composition: '90% Silver',
    mint: 'San Francisco Mint',
    matchPercent: 92,
    marketValueLow: 48,
    marketValueHigh: 62,
    mintage: '703k',
    rarity: 'R-4',
    storyTitle: 'Trade across the Pacific',
    storySubtitle: 'The dollar built for commerce with China',
    storyDuration: '4:12',
    provenanceTitle: 'Minted for export',
    authenticityScore: 92,
  );

  static const physicalChecks = [
    PhysicalCheck(
      title: 'Weight',
      detail: '26.71 g · expected 26.73 g',
      icon: Icons.scale_outlined,
      status: CheckStatus.pass,
    ),
    PhysicalCheck(
      title: 'Diameter',
      detail: '38.1 mm · exact match',
      icon: Icons.straighten,
      status: CheckStatus.pass,
    ),
    PhysicalCheck(
      title: 'Edge reeding',
      detail: '189 reeds counted · correct pattern',
      icon: Icons.blur_circular,
      status: CheckStatus.pass,
    ),
    PhysicalCheck(
      title: 'Relief depth',
      detail: "Slight wear on eagle's breast — common",
      icon: Icons.warning_amber_rounded,
      status: CheckStatus.warn,
    ),
    PhysicalCheck(
      title: 'Magnetic response',
      detail: 'Non-magnetic · consistent with 90% silver',
      icon: Icons.attractions_outlined,
      status: CheckStatus.pass,
    ),
  ];

  static const storyVideos = [
    StoryVideo(
      id: 'titanic',
      title: 'The Penny That Stayed with the Titanic',
      category: 'Shipwrecks',
      duration: '6:12',
      views: '892k views',
      gradient: [Color(0xFF1A3A5C), Color(0xFF0D2137)],
    ),
    StoryVideo(
      id: 'gold-rush',
      title: 'Gold Rush in a Pocket: the 1849 Double Eagle',
      category: 'Gold Rush',
      duration: '4:48',
      views: '506k views',
      gradient: [Color(0xFF8B6914), Color(0xFF5C4A0E)],
    ),
  ];

  static const storyCategories = [
    'All',
    'Ancient',
    'Shipwrecks',
    'Gold Rush',
    'World',
  ];

  static const eraCards = [
    EraCard(title: 'Ancient Rome', subtitle: '240 stories', color: Color(0xFF8D6E63)),
    EraCard(title: 'Colonial America', subtitle: '186 stories', color: Color(0xFF5D4037)),
    EraCard(title: 'World War II', subtitle: '142 stories', color: Color(0xFF455A64)),
    EraCard(title: 'Gold Rush', subtitle: '98 stories', color: Color(0xFF8B6914)),
  ];

  static const clubs = [
    Club(
      id: 'fallen-empires',
      name: 'Coins of Fallen Empires',
      members: 1240,
      subtitle: '1,240 members · \$214k value',
      schedule: 'Meets Tuesday',
      isOnline: true,
      icon: Icons.fort,
      iconColor: Color(0xFF8D6E63),
    ),
    Club(
      id: 'bay-area',
      name: 'Bay Area Numismatics',
      members: 1240,
      subtitle: '1,240 members · meetup',
      schedule: 'Saturday',
      isOnline: true,
      icon: Icons.account_balance,
      iconColor: Color(0xFF7B68EE),
    ),
    Club(
      id: 'young-collectors',
      name: 'Young Collectors (13–18)',
      members: 3860,
      subtitle: '3,860 members · mentor program',
      schedule: '',
      isOnline: true,
      icon: Icons.school_outlined,
      iconColor: Color(0xFF26A69A),
    ),
  ];

  static const listings = [
    MarketListing(
      id: 'listing-1',
      coin: morganDollar,
      price: 54,
      verified: true,
      tradeOk: true,
      listedDaysAgo: 3,
      distance: '1.2 mi',
    ),
    MarketListing(
      id: 'listing-2',
      coin: tradeDollar,
      price: 54,
      verified: true,
      tradeOk: false,
      listedDaysAgo: 1,
      distance: '3.4 mi',
    ),
  ];

  static const seller = Seller(
    name: 'Jordan Lee',
    club: 'Bay Area Numismatics',
    memberSince: 2024,
    rating: 4.9,
    deals: 38,
    responseTime: '~1h',
    verifiedPercent: 100,
    isTrusted: true,
    isOnline: true,
  );
}
