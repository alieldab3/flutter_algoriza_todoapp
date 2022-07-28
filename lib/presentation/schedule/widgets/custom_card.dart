import 'package:flutter/material.dart';
import 'package:flutter_algoriza_todoapp/models/task.dart';
import 'package:provider/provider.dart';

class CustomCard extends StatefulWidget {
  final TaskItem task;
  const CustomCard({Key? key, required this.task}) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 80,
        child: Card(
          color: widget.task.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            title: Text(
              widget.task.startTime.format(context),
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              widget.task.title,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            trailing: Transform.scale(
              scale: 1.3,
              child: Checkbox(
                activeColor: Colors.transparent,
                value: widget.task.isDone,
                shape: const CircleBorder(),
                side: const BorderSide(width: 1.5, color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    widget.task.toggleDoneStatus();
                    Provider.of<Tasks>(context, listen: false)
                        .updateTask(widget.task);
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
