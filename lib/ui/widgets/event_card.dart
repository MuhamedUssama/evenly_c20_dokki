import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_c20_dokki/core/config/app_config.dart';
import 'package:evently_c20_dokki/core/utils/context_extention.dart';
import 'package:evently_c20_dokki/core/utils/icons_extension.dart';
import 'package:evently_c20_dokki/core/utils/numbers_extension.dart';
import 'package:evently_c20_dokki/firebase/firebase_database.dart';
import 'package:evently_c20_dokki/models/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/category.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({required this.event, super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfig>(context);
    return AspectRatio(
      aspectRatio: 343 / 193,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/${categoriesMap[event.category]?.image ?? "Meeting"} ${provider.isDarkMode ? "Dark" : "Light"}.png",
            ),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: .spaceBetween,
          crossAxisAlignment: .start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.colors.primary, width: 0.2),
              ),
              padding: EdgeInsets.all(8),
              child: Text(
                DateFormat("MMM dd").format(event.date!),
                style: context.text.titleLarge!.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.colors.primary, width: 0.2),
              ),
              child: Row(
                children: [
                  16.horizontalSpace,
                  Expanded(
                    child: Text(
                      event.title!,
                      style: context.text.titleMedium!.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      var uid = FirebaseAuth.instance.currentUser?.uid ?? "";
                      if (event.likes.contains(uid)) {
                        event.likes.remove(uid);
                      } else {
                        event.likes.add(uid);
                      }
                      FirebaseDatabase().updateEvent(event);
                    },
                    icon:
                        event.likes.contains(
                          FirebaseAuth.instance.currentUser?.uid ?? "",
                        )
                        ? Iconsax.heart_bold.toIcon
                        : Iconsax.heart_outline.toIcon,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
