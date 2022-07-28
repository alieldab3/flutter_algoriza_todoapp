import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/task.dart';
import 'widgets/pick_button.dart';
import '../shared_widgets/custom_button.dart';
import 'widgets/pick_button.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _form = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  String selectedTitle = '';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  late TimeOfDay selectedEndTime;
  String selectedRemind = '1 Hour Before';
  String selectedRepeat = 'No Repeat';

  final _titleFocusNode = FocusNode();
  var remindItems = [
    '10 Min Before',
    '30 Min Before',
    '1 Hour Before',
    '1 Day Before',
  ];
  var repeatItems = [
    'No Repeat',
    'Daily',
    'Weekly',
    'Monthly',
  ];

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    selectedEndTime =
        selectedStartTime.replacing(hour: selectedStartTime.hour + 1);
    _titleFocusNode.requestFocus();
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    TimeOfDay initialTime = TimeOfDay.now();
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null && pickedTime != selectedStartTime) {
      setState(() {
        selectedStartTime = pickedTime;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    TimeOfDay initialTime = TimeOfDay.now();
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null && pickedTime != selectedEndTime) {
      setState(() {
        selectedEndTime = pickedTime;
      });
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    // setState(() {
    //   _isLoading = true;
    // });

    try {
      TaskItem saved = TaskItem(
        title: selectedTitle,
        date: selectedDate,
        startTime: selectedStartTime,
        endTime: selectedEndTime,
        remind: selectedRemind,
        repeat: selectedRepeat,
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      );

      Provider.of<Tasks>(context, listen: false).addTask(saved).then((value) {
        FocusManager.instance.primaryFocus?.unfocus();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task is Created Successfully!'),
            padding: EdgeInsets.all(16),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );

        late TimeOfDay startReminder;
        if (selectedRemind == remindItems[0]) {
          //10 Min Before
          startReminder = TimeOfDay.fromDateTime(
            DateTime(1969, 1, 1, selectedStartTime.hour,
                    selectedStartTime.minute)
                .subtract(
              const Duration(minutes: 10),
            ),
          );
        } else if (selectedRemind == remindItems[1]) {
          //30 Min Before
          startReminder = TimeOfDay.fromDateTime(
            DateTime(1969, 1, 1, selectedStartTime.hour,
                    selectedStartTime.minute)
                .subtract(
              const Duration(minutes: 30),
            ),
          );
        } else if (selectedRemind == remindItems[2]) {
          //1 Hour Before
          startReminder = TimeOfDay.fromDateTime(
            DateTime(1969, 1, 1, selectedStartTime.hour,
                    selectedStartTime.minute)
                .subtract(
              const Duration(hours: 1),
            ),
          );
        } else if (selectedRemind == remindItems[3]) {
          //1 Day Before
          startReminder = TimeOfDay.fromDateTime(
            DateTime(1969, 1, 1, selectedStartTime.hour,
                    selectedStartTime.minute)
                .subtract(
              const Duration(days: 1),
            ),
          );
        }
        FlutterAlarmClock.createAlarm(startReminder.hour, startReminder.minute,
            title: selectedTitle);
        _titleController.text = '';
      });
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: const Text('Something went wrong.'),
          actions: <Widget>[
            OutlinedButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    // setState(() {
    //   _isLoading = false;
    // });
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight =
        MediaQuery.of(context).viewInsets.bottom + 100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Add task'),
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
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Form(
                key: _form,
                child: SizedBox(
                  height: screenHeight - keyboardHeight,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Title",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Colors.white70,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(14)),
                                controller: _titleController,
                                focusNode: _titleFocusNode,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please provide a valid title.';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    selectedTitle = value;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      PickButton(
                        icon: const Icon(Icons.keyboard_arrow_down_outlined),
                        onPressed: () => _selectDate(context),
                        selectedText:
                            DateFormat('yyyy-MM-dd').format(selectedDate),
                        labelText: 'Date',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: PickButton(
                              icon: const Icon(Icons.watch_later_outlined),
                              onPressed: () => _selectStartTime(context),
                              selectedText: selectedStartTime.format(context),
                              labelText: 'Start time',
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: PickButton(
                              icon: const Icon(Icons.watch_later_outlined),
                              onPressed: () => _selectEndTime(context),
                              selectedText: selectedEndTime.format(context),
                              labelText: 'End time',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Remind",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Colors.white70,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                child: DropdownButton<String>(
                                  value: selectedRemind,
                                  icon: const Icon(
                                      Icons.keyboard_arrow_down_outlined),
                                  borderRadius: BorderRadius.circular(15),
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedRemind = newValue!;
                                    });
                                  },
                                  items: remindItems.map((String remindItem) {
                                    return DropdownMenuItem<String>(
                                      value: remindItem,
                                      child: Text(remindItem),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Repeat",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Colors.white70,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                child: DropdownButton<String>(
                                  value: selectedRepeat,
                                  icon: const Icon(
                                      Icons.keyboard_arrow_down_outlined),
                                  borderRadius: BorderRadius.circular(15),
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedRepeat = newValue!;
                                    });
                                  },
                                  items: repeatItems.map((String repeatItem) {
                                    return DropdownMenuItem<String>(
                                      value: repeatItem,
                                      child: Text(repeatItem),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Create a Task',
                onPressed: _saveForm,
              ))
        ]),
      ),
    );
  }
}
