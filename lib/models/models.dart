import 'package:flutter/material.dart';

class Coin {
  const Coin({
    required this.id,
    required this.name,
    required this.shortName,
    required this.country,
    required this.material,
    required this.composition,
    required this.mint,
    required this.matchPercent,
    required this.marketValueLow,
    required this.marketValueHigh,
    required this.mintage,
    required this.rarity,
    required this.storyTitle,
    required this.storySubtitle,
    required this.storyDuration,
    required this.provenanceTitle,
    required this.authenticityScore,
  });

  final String id;
  final String name;
  final String shortName;
  final String country;
  final String material;
  final String composition;
  final String mint;
  final int matchPercent;
  final int marketValueLow;
  final int marketValueHigh;
  final String mintage;
  final String rarity;
  final String storyTitle;
  final String storySubtitle;
  final String storyDuration;
  final String provenanceTitle;
  final int authenticityScore;

  String get marketValueRange => '\$$marketValueLow–$marketValueHigh';
  String get metadataLine => '$country · $material · $mint';
}

enum CheckStatus { pass, warn, fail }

class PhysicalCheck {
  const PhysicalCheck({
    required this.title,
    required this.detail,
    required this.icon,
    required this.status,
  });

  final String title;
  final String detail;
  final IconData icon;
  final CheckStatus status;
}

class StoryVideo {
  const StoryVideo({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.views,
    required this.gradient,
  });

  final String id;
  final String title;
  final String category;
  final String duration;
  final String views;
  final List<Color> gradient;
}

class EraCard {
  const EraCard({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;
}

class Club {
  const Club({
    required this.id,
    required this.name,
    required this.members,
    required this.subtitle,
    required this.schedule,
    required this.isOnline,
    required this.icon,
    required this.iconColor,
  });

  final String id;
  final String name;
  final int members;
  final String subtitle;
  final String schedule;
  final bool isOnline;
  final IconData icon;
  final Color iconColor;
}

class MarketListing {
  const MarketListing({
    required this.id,
    required this.coin,
    required this.price,
    required this.verified,
    required this.tradeOk,
    required this.listedDaysAgo,
    required this.distance,
  });

  final String id;
  final Coin coin;
  final int price;
  final bool verified;
  final bool tradeOk;
  final int listedDaysAgo;
  final String distance;
}

class Seller {
  const Seller({
    required this.name,
    required this.club,
    required this.memberSince,
    required this.rating,
    required this.deals,
    required this.responseTime,
    required this.verifiedPercent,
    required this.isTrusted,
    required this.isOnline,
  });

  final String name;
  final String club;
  final int memberSince;
  final double rating;
  final int deals;
  final String responseTime;
  final int verifiedPercent;
  final bool isTrusted;
  final bool isOnline;
}
