import 'package:flutter/material.dart';

class Tag extends StatefulWidget {
  const Tag({super.key, required this.text});
  final String text;
  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 23.0,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Color.fromARGB(255, 120, 212, 255),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
        child: Text(
          widget.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
