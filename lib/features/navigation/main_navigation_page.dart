import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../shared/providers.dart';
import '../dashboard/presentation/pages/dashboard_page.dart';
import '../quran/presentation/pages/home_page.dart';
import '../ibadah/presentation/pages/ibadah_hub_page.dart';
import '../ibadah/presentation/pages/prayer_collection_page.dart';
import '../settings/presentation/pages/settings_page.dart';

class MainNavigationPage extends ConsumerWidget {
  const MainNavigationPage({super.key});

  final List<Widget> _pages = const [
    HomePage(),             // Index 0: Al-Quran (paling kiri)
    IbadahHubPage(),        // Index 1: Ibadah (tengah kiri)
    DashboardPage(),        // Index 2: Beranda (tengah - FAB)
    PrayerCollectionPage(), // Index 3: Doa (tengah kanan)
    SettingsPage(),         // Index 4: Pengaturan (paling kanan)
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const primaryEmerald = Color(0xff0b3b24);
    const accentGold = Color(0xffd4af37);
    final navBgColor = isDark ? const Color(0xff121814) : Colors.white;
    final navBorderColor = isDark ? const Color(0xff1b241e) : const Color(0xffe5e5e0);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xff070c09) : const Color(0xfff3f6f4),
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),
      extendBody: true, // Allows Scaffold body to flow under the notched bar
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        transform: Matrix4.translationValues(0, currentIndex == 2 ? -4 : 0, 0),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          scale: currentIndex == 2 ? 1.05 : 1.0,
          child: Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: currentIndex == 2
                      ? accentGold.withValues(alpha: 0.25)
                      : Colors.black.withValues(alpha: isDark ? 0.35 : 0.15),
                  blurRadius: currentIndex == 2 ? 14 : 10,
                  spreadRadius: currentIndex == 2 ? 2 : 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () {
                ref.read(bottomNavIndexProvider.notifier).state = 2; // Beranda (Tengah)
              },
              backgroundColor: currentIndex == 2 ? primaryEmerald : (isDark ? const Color(0xff1a221c) : Colors.white),
              elevation: 0,
              shape: CircleBorder(
                side: BorderSide(
                  color: currentIndex == 2 ? accentGold : navBorderColor,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.zero,
          height: 68,
          color: navBgColor,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Tab 0: Al-Quran (Paling Kiri)
              _buildTabItem(
                ref: ref,
                index: 0,
                currentIndex: currentIndex,
                icon: Icons.menu_book_rounded,
                label: 'Al-Quran',
                isDark: isDark,
                accentGold: accentGold,
              ),
              // Tab 1: Ibadah (Tengah Kiri)
              _buildTabItem(
                ref: ref,
                index: 1,
                currentIndex: currentIndex,
                icon: Icons.mosque_rounded, // Mosque icon replacing Compass
                label: 'Ibadah',
                isDark: isDark,
                accentGold: accentGold,
              ),
              // Spacer for Center Notched FAB
              const SizedBox(width: 48),
              // Tab 3: Doa (Tengah Kanan)
              _buildTabItem(
                ref: ref,
                index: 3,
                currentIndex: currentIndex,
                icon: Icons.auto_stories_rounded,
                label: 'Doa',
                isDark: isDark,
                accentGold: accentGold,
              ),
              // Tab 4: Pengaturan (Paling Kanan)
              _buildTabItem(
                ref: ref,
                index: 4,
                currentIndex: currentIndex,
                icon: Icons.settings_rounded,
                label: 'Pengaturan',
                isDark: isDark,
                accentGold: accentGold,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required WidgetRef ref,
    required int index,
    required int currentIndex,
    required IconData icon,
    required String label,
    required bool isDark,
    required Color accentGold,
  }) {
    final isSelected = index == currentIndex;
    final inactiveColor = isDark ? Colors.white38 : Colors.black38;

    return Expanded(
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: () {
            ref.read(bottomNavIndexProvider.notifier).state = index;
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                transform: Matrix4.translationValues(0, isSelected ? -4 : 0, 0),
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  scale: isSelected ? 1.15 : 1.0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isSelected ? accentGold.withValues(alpha: 0.12) : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? accentGold : inactiveColor,
                      size: 25,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                width: isSelected ? 6 : 0,
                height: 6,
                decoration: BoxDecoration(
                  color: accentGold,
                  shape: BoxShape.circle,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: accentGold.withValues(alpha: 0.4),
                            blurRadius: 4,
                            spreadRadius: 1,
                          )
                        ]
                      : [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
