import 'package:evently_c20_dokki/core/utils/context_extention.dart';
import 'package:evently_c20_dokki/core/utils/icons_extension.dart';
import 'package:evently_c20_dokki/ui/event_managment/event_managment_screen.dart';
import 'package:evently_c20_dokki/ui/home/tabs/favorite_tab.dart';
import 'package:evently_c20_dokki/ui/home/tabs/home_tab.dart';
import 'package:evently_c20_dokki/ui/home/tabs/maps_tab/provider/map_tab_provider.dart';
import 'package:evently_c20_dokki/ui/home/tabs/maps_tab/screen/map_tab.dart';
import 'package:evently_c20_dokki/ui/home/tabs/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  List<Widget> tabs = [
    HomeTab(),
    ChangeNotifierProvider(
      create: (context) => MapTabProvider(),
      child: MapTab(),
    ),
    FavoriteTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, EventManagementScreen.routeName);
        },
        child: Icons.add.toIcon,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Iconsax.home_outline.toIcon,
            activeIcon: Iconsax.home_bold.toIcon,
            label: context.locale.home,
          ),
          BottomNavigationBarItem(
            icon: Iconsax.location_outline.toIcon,
            activeIcon: Iconsax.location_bold.toIcon,
            label: 'Maps',
          ),
          BottomNavigationBarItem(
            icon: Iconsax.heart_outline.toIcon,
            activeIcon: Iconsax.heart_bold.toIcon,
            label: context.locale.favorite,
          ),
          BottomNavigationBarItem(
            icon: Iconsax.user_outline.toIcon,
            activeIcon: Iconsax.user_bold.toIcon,
            label: context.locale.profile,
          ),
        ],
      ),
    );
  }
}
