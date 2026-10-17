import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_c20_dokki/core/config/app_config.dart';
import 'package:evently_c20_dokki/core/utils/context_extention.dart';
import 'package:evently_c20_dokki/core/utils/icons_extension.dart';
import 'package:evently_c20_dokki/core/utils/numbers_extension.dart';
import 'package:evently_c20_dokki/core/utils/widget_extension.dart';
import 'package:evently_c20_dokki/firebase/firebase_database.dart';
import 'package:evently_c20_dokki/models/event.dart';
import 'package:evently_c20_dokki/ui/widgets/event_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';

class FavoriteTab extends StatefulWidget {
  const FavoriteTab({super.key});

  @override
  State<FavoriteTab> createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Search",
              suffixIcon: Iconsax.search_normal_1_outline.toIcon,
            ),
          ).allPadding(16),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Event>>(
              stream: FirebaseDatabase().getEventsStream(
                uid: FirebaseAuth.instance.currentUser?.uid,
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
