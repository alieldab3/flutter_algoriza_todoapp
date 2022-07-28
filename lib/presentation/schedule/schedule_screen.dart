import 'package:flutter/material.dart';
import 'package:flutter_algoriza_todoapp/presentation/schedule/widgets/custom_card.dart';
import 'package:flutter_algoriza_todoapp/presentation/schedule/widgets/weekday_item.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../../db/tasks_database.dart';
import '../../models/task.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime initialDate = DateTime.now();
  List<bool> daySelect = [true, false, false, false, false, false, false];
  late DateTime selectedDate;
  List<TaskItem> tasksPerDay = [];
  bool isLoading = false;

  @override
  void initState() {
    selectedDate = initialDate;
    refreshTasks();
    super.initState();
  }

  @override
  void dispose() {
    TasksDatabase.instance.close();
    super.dispose();
  }

  Future refreshTasks() async {
    setState(() => isLoading = true);
    tasksPerDay =
        Provider.of<Tasks>(context, listen: false).findTaskbyDate(selectedDate);
    setState(() => isLoading = false);
  }

  void setSingleTrue(int trueIndex) {
    daySelect = List.filled(7, false);
    daySelect[trueIndex] = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Schedule'),
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.keyboard_arrow_left_outlined,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = initialDate;
                          setSingleTrue(0);
                          refreshTasks();
                        });
                      },
                      child: WeekdayItem(
                        date: initialDate,
                        isSelected: daySelect[0],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate =
                              initialDate.add(const Duration(days: 1));
                          setSingleTrue(1);
                          refreshTasks();
                        });
                      },
                      child: WeekdayItem(
                        date: initialDate.add(const Duration(days: 1)),
                        isSelected: daySelect[1],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate =
                              initialDate.add(const Duration(days: 2));
                          setSingleTrue(2);
                          refreshTasks();
                        });
                      },
                      child: WeekdayItem(
                        date: initialDate.add(const Duration(days: 2)),
                        isSelected: daySelect[2],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate =
                              initialDate.add(const Duration(days: 3));
                          setSingleTrue(3);
                          refreshTasks();
                        });
                      },
                      child: WeekdayItem(
                        date: initialDate.add(const Duration(days: 3)),
                        isSelected: daySelect[3],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate =
                              initialDate.add(const Duration(days: 4));
                          setSingleTrue(4);
                          refreshTasks();
                        });
                      },
                      child: WeekdayItem(
                        date: initialDate.add(const Duration(days: 4)),
                        isSelected: daySelect[4],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate =
                              initialDate.add(const Duration(days: 5));
                          setSingleTrue(5);
                          refreshTasks();
                        });
                      },
                      child: WeekdayItem(
                        date: initialDate.add(const Duration(days: 5)),
                        isSelected: daySelect[5],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate =
                              initialDate.add(const Duration(days: 6));
                          setSingleTrue(6);
                          refreshTasks();
                        });
                      },
                      child: WeekdayItem(
                        date: initialDate.add(const Duration(days: 6)),
                        isSelected: daySelect[6],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('EEEE').format(selectedDate),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('d LLL, y').format(selectedDate),
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: tasksPerDay.isEmpty
                    ? const Center(child: Text("No tasks for today"))
                    : ListView.builder(
                        itemCount: tasksPerDay.length,
                        itemBuilder: (_, i) {
                          return CustomCard(
                            task: tasksPerDay[i],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
