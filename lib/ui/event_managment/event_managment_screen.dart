import 'package:evently_c20_dokki/core/utils/context_extention.dart';
import 'package:evently_c20_dokki/core/utils/date_time_extension.dart';
import 'package:evently_c20_dokki/core/utils/dialog_utils.dart';
import 'package:evently_c20_dokki/core/utils/icons_extension.dart';
import 'package:evently_c20_dokki/core/utils/numbers_extension.dart';
import 'package:evently_c20_dokki/core/utils/validators.dart';
import 'package:evently_c20_dokki/core/utils/widget_extension.dart';
import 'package:evently_c20_dokki/firebase/firebase_database.dart';
import 'package:evently_c20_dokki/models/category.dart';
import 'package:evently_c20_dokki/models/event.dart';
import 'package:evently_c20_dokki/ui/widgets/custom_tab_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:intl/intl.dart';

class EventManagementScreen extends StatefulWidget {
  static const String routeName = "/event_management";

  const EventManagementScreen({super.key});

  @override
  State<EventManagementScreen> createState() => _EventManagementScreenState();
}

class _EventManagementScreenState extends State<EventManagementScreen> {
  List<Category> categories = [...categoriesList];
  int selectedIndex = 0;

  TextEditingController titleController = TextEditingController(text: "");
  TextEditingController descriptionController = TextEditingController(text: "");

  DateTime? date;
  TimeOfDay? time;

  @override
  Widget build(BuildContext context) {
    var validator = Validator();
    return Scaffold(
      appBar: AppBar(title: Text("Add Event"), centerTitle: true),
      bottomNavigationBar: FilledButton(
        onPressed: () async {
          if (titleController.text.isEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Title is required")));
            return;
          }
          if (descriptionController.text.isEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Description is required")));
            return;
          }
          if (date == null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Date is required")));
            return;
          }
          if (time == null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Time is required")));
            return;
          }
          DialogUtils dialogUtils = DialogUtils();
          dialogUtils.showActionDialog(
            context,
            title: "Add Event",
            message: "Are you sure you want to add event",
            postActionTitle: "Yes",
            negativeActionTitle: "No",
            postAction: () async {
              context.showLoadingDialog();
              await Future.delayed(Duration(seconds: 2));
              final event = Event(
                id: "event2",
                uid: FirebaseAuth.instance.currentUser?.uid ?? "",
                title: titleController.text,
                description: descriptionController.text,
                date: date!,
                timeOfDay: time!,
                category: categories[selectedIndex].id,
              );

              await FirebaseDatabase().addEvent(event);
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        },
        child: Text("Create Event"),
      ).allPadding(16),
      body: ListView(
        children: [
          Stack(
            children: [
              Image.asset(
                "assets/images/${categories[selectedIndex].image} ${context.provider.isDarkMode ? "Dark" : "Light"}.png",
              ).clip(16).allPadding(16),
              AspectRatio(
                aspectRatio: 343 / 193,
                child: SizedBox(width: double.infinity),
              ),
            ],
          ),
          CustomTabBarWidget(
            categories: categories,
            selectItem: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
            selectedIndex: selectedIndex,
          ),
          16.verticalSpace,
          Text("Name").horizontalPadding(16),
          8.verticalSpace,
          TextFormField(
            controller: titleController,
            validator: (text) => validator.nameValidation(text, context.locale),
            autovalidateMode: .onUserInteraction,
            decoration: InputDecoration(hintText: "Enter Title"),
          ).horizontalPadding(16),
          16.verticalSpace,
          Text("Description").horizontalPadding(16),
          8.verticalSpace,
          TextFormField(
            controller: descriptionController,
            validator: (text) => validator.nameValidation(text, context.locale),
            autovalidateMode: .onUserInteraction,
            maxLines: 5,
            decoration: InputDecoration(hintText: "Enter Description  ...."),
          ).horizontalPadding(16),
          16.verticalSpace,
          Row(
            children: [
              Iconsax.calendar_1_outline.toIcon,
              8.horizontalSpace,
              Text("Event Date"),
              Spacer(),
              TextButton(
                onPressed: () async {
                  var selectedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 400)),
                    initialDate: date,
                  );
                  if (selectedDate != null) {
                    date = selectedDate;
                    setState(() {});
                  }
                },
                child: Text(
                  date == null
                      ? "Choose Date"
                      : DateFormat("yyyy / MM / dd").format(date!),
                ),
              ),
            ],
          ).horizontalPadding(16),

          Row(
            children: [
              Iconsax.clock_1_outline.toIcon,
              8.horizontalSpace,
              Text("Event Time"),
              Spacer(),
              TextButton(
                onPressed: () async {
                  var selectedTime = await showTimePicker(
                    context: context,
                    initialTime: time ?? TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    time = selectedTime;
                    setState(() {});
                  }
                },
                child: Text(
                  time == null
                      ? "Choose Time"
                      : DateFormat("hh:mm a").format(time!.dateTime),
                ),
              ),
            ],
          ).horizontalPadding(16),
        ],
      ),
    );
  }
}
