import 'package:flutter/material.dart';

class PickButton extends StatefulWidget {
  final String labelText;
  final void Function()? onPressed;
  final String selectedText;
  final Icon icon;
  const PickButton(
      {Key? key,
      required this.icon,
      required this.onPressed,
      required this.labelText,
      required this.selectedText})
      : super(key: key);

  @override
  State<PickButton> createState() => _PickButtonState();
}

class _PickButtonState extends State<PickButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.labelText,
              style: const TextStyle(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(widget.selectedText),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(onPressed: widget.onPressed, icon: widget.icon)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
