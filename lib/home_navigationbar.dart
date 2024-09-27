import 'package:flutter/material.dart';
import 'package:bitcoin_icons/bitcoin_icons.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:ssoup/about_map/bigmap.dart';
import 'package:ssoup/home.dart';
import 'package:ssoup/stamp.dart';

class HomePageNavigationBar extends StatelessWidget {
  const HomePageNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 4,
            ),
          ],
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
              (Set<WidgetState> states) {
                final isSelected = states.contains(WidgetState.selected);
                return TextStyle(
                  color: isSelected ? Colors.blue : const Color(0xFF9D9D9D),
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                );
              },
            ),
          ),
          child: NavigationBar(
            backgroundColor: Colors.white,
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            selectedIndex: currentPageIndex,
            destinations: <Widget>[
              const NavigationDestination(
                selectedIcon: Icon(BitcoinIcons.home_outline,
                    color: Colors.blue, size: 31),
                icon: Icon(BitcoinIcons.home_outline, size: 31),
                label: '홈',
              ),
              const NavigationDestination(
                icon: Icon(FluentIcons.stamp_32_light, size: 31),
                selectedIcon: Icon(
                  FluentIcons.stamp_32_light,
                  color: Colors.blue,
                  size: 31,
                ),
                label: '스탬프',
              ),
              const NavigationDestination(
                icon: Icon(Icons.map_outlined, size: 31),
                label: '지도',
              ),
              NavigationDestination(
                icon:
                    Icon(PhosphorIcons.taxi(PhosphorIconsStyle.thin), size: 31),
                selectedIcon: Icon(
                  PhosphorIcons.taxi(PhosphorIconsStyle.thin),
                  color: Colors.blue,
                  size: 31,
                ),
                label: '이동수단',
              ),
            ],
          ),
        ),
      ),
      body: <Widget>[
        const HomePage(),
        const StampPage(),
        const BigMapPage(),
        Container(),
      ][currentPageIndex],
    );
  }
}
