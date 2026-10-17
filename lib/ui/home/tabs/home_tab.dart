import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_c20_dokki/core/config/app_config.dart';
import 'package:evently_c20_dokki/core/utils/context_extention.dart';
import 'package:evently_c20_dokki/core/utils/icons_extension.dart';
import 'package:evently_c20_dokki/core/utils/numbers_extension.dart';
import 'package:evently_c20_dokki/core/utils/widget_extension.dart';
import 'package:evently_c20_dokki/firebase/firebase_database.dart';
import 'package:evently_c20_dokki/models/category.dart';
import 'package:evently_c20_dokki/models/event.dart';
import 'package:evently_c20_dokki/ui/widgets/custom_tab_bar_widget.dart';
import 'package:evently_c20_dokki/ui/widgets/event_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<Category> allCategories = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    allCategories.add(
      Category("All", "الكل", "", "all", Iconsax.category_bold),
    );
    allCategories.addAll(categoriesList);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfig>(context);
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(provider),
          CustomTabBarWidget(
            categories: allCategories,
            selectItem: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
            selectedIndex: selectedIndex,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Event>>(
              stream: FirebaseDatabase().getEventsStream(
                category: selectedIndex == 0
                    ? null
                    : allCategories[selectedIndex].id,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == .waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (snapshot.hasData) {
                  var events =
                      snapshot.data?.docs.map((e) => e.data()).toList() ?? [];
                  events.sort((a, b) => b.date!.compareTo(a.date!));
                  if (events.isEmpty) {
                    return const Center(child: Text("No Events Found"));
                  } else {
                    return ListView.separated(
                      padding: EdgeInsets.all(16),
                      itemBuilder: (_, index) =>
                          EventCard(event: events[index]),
                      separatorBuilder: (_, _) => 16.verticalSpace,
                      itemCount: events.length,
                    );
                  }
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppConfig provider) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text("Welcome Back ✨", style: context.text.titleMedium),
              Text(
                FirebaseAuth.instance.currentUser?.displayName ?? "User",
                style: context.text.titleLarge,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            provider.changeTheme(
              provider.isDarkMode ? ThemeMode.light : ThemeMode.dark,
            );
          },
          icon: provider.isDarkMode
              ? Icons.dark_mode.toIcon
              : Icons.light_mode.toIcon,
        ),
        InkWell(
          onTap: () {
            provider.changeLocale(provider.isEn ? "ar" : "en");
          },
          child: Container(
            decoration: BoxDecoration(
              color: context.colors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(8),
            child: Text(
              provider.locale,
              style: context.text.titleMedium!.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    ).allPadding(16);
  }
}
