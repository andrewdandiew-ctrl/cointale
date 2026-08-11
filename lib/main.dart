import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'data/mock_data.dart';
import 'firebase_options.dart';
import 'models/models.dart';
import 'screens/coin/authenticity_screen.dart';
import 'screens/coin/coin_detail_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/auth/sign_up_screen.dart';
import 'screens/main_shell.dart';
import 'screens/market/chat_screen.dart';
import 'screens/market/list_coin_screen.dart';
import 'screens/market/listing_detail_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/scan/scan_screen.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends CoinTaleApp {
  const MyApp({super.key}) : super(firebaseIsReady: true);
}

class CoinTaleApp extends StatelessWidget {
  const CoinTaleApp({super.key, this.firebaseIsReady = true});

  final bool firebaseIsReady;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinTale',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: WelcomeScreen.routeName,
      routes: {
        WelcomeScreen.routeName: (_) => const WelcomeScreen(),
        SignInScreen.routeName: (_) =>
            SignInScreen(firebaseIsReady: firebaseIsReady),
        SignUpScreen.routeName: (_) =>
            SignUpScreen(firebaseIsReady: firebaseIsReady),
        MainShell.routeName: (_) => const MainShell(),
        ScanScreen.routeName: (_) => ScanScreen(
          onViewStory: (context) => Navigator.of(context).pushNamed(
            CoinDetailScreen.routeName,
            arguments: MockData.morganDollar,
          ),
          onVerify: (context) => Navigator.of(context).pushNamed(
            AuthenticityScreen.routeName,
            arguments: MockData.morganDollar,
          ),
        ),
        CoinDetailScreen.routeName: (context) {
          final coin =
              ModalRoute.of(context)!.settings.arguments as Coin? ??
              MockData.morganDollar;
          return CoinDetailScreen(
            coin: coin,
            onVerify: () => Navigator.of(
              context,
            ).pushNamed(AuthenticityScreen.routeName, arguments: coin),
          );
        },
        AuthenticityScreen.routeName: (context) {
          final coin =
              ModalRoute.of(context)!.settings.arguments as Coin? ??
              MockData.morganDollar;
          return AuthenticityScreen(coin: coin);
        },
        ListCoinScreen.routeName: (_) => const ListCoinScreen(),
        ListingDetailScreen.routeName: (context) {
          final listing =
              ModalRoute.of(context)!.settings.arguments as MarketListing? ??
              MockData.listings.first;
          return ListingDetailScreen(
            listing: listing,
            onMessage: () =>
                Navigator.of(context).pushNamed(ChatScreen.routeName),
          );
        },
        ChatScreen.routeName: (_) => const ChatScreen(),
        ProfileScreen.routeName: (_) => const ProfileScreen(),
      },
    );
  }
}
