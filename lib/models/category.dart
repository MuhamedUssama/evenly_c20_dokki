import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';

class Category {
  String nameEn;
  String nameAr;
  String image;
  String id;
  IconData icon;

  Category(this.nameEn, this.nameAr, this.image, this.id, this.icon);
}

List<Category> categoriesList = [
  Category("Sport", "رياضة", "Sport", 'sport', Iconsax.cup_bold),
  Category(
    "Book Club",
    "نادي الكتاب",
    "Book Club",
    'book_club',
    Iconsax.book_bold,
  ),
  Category("Birthday", "عيد ميلاد", "Birthday", 'birthday', Iconsax.cake_bold),
  Category(
    "Meeting",
    "اجتماع",
    "Meeting",
    'meeting',
    Iconsax
        .people_bold, // Or Iconsax.briefcase_bold / Iconsax.profile_2user_bold
  ),
  Category(
    "Exhibition",
    "معرض",
    "Exhibition",
    'exhibition',
    Iconsax.gallery_bold, // Or Iconsax.picture_frame_bold / Iconsax.brush_bold
  ),
];

final Map<String, Category> categoriesMap = {
  for (final category in categoriesList) category.id: category,
};
