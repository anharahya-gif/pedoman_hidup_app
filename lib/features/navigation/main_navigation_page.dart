import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/providers.dart';
import '../dashboard/presentation/pages/dashboard_page.dart';
import '../quran/presentation/pages/home_page.dart';
import '../ibadah/presentation/pages/ibadah_hub_page.dart';
import '../ibadah/presentation/pages/prayer_collection_page.dart';
import '../settings/presentation/pages/settings_page.dart';

class MainNavigationPage extends ConsumerWidget {
  const MainNavigationPage({super.key});

  final List<Widget> _pages = const [
    DashboardPage(),
    HomePage(),
    IbadahHubPage(),
    PrayerCollectionPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const accentGold = Color(0xffd4af37);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
              blurRadius: 15,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            ref.read(bottomNavIndexProvider.notifier).state = index;
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? const Color(0xff0b100d) : Colors.white,
          selectedItemColor: accentGold,
          unselectedItemColor: isDark ? Colors.white30 : Colors.black26,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home_rounded, color: accentGold),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              activeIcon: Icon(Icons.menu_book_rounded, color: accentGold),
              label: 'Al-Quran',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mosque_rounded),
              activeIcon: Icon(Icons.mosque_rounded, color: accentGold),
              label: 'Ibadah',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_stories_rounded),
              activeIcon: Icon(Icons.auto_stories_rounded, color: accentGold),
              label: 'Doa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              activeIcon: Icon(Icons.settings_rounded, color: accentGold),
              label: 'Pengaturan',
            ),
          ],
        ),
      ),
    );
  }
}
