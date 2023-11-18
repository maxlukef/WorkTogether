import 'package:flutter/material.dart';
import 'package:work_together_flutter/global_components/our_colors.dart';

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
      height: 16.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        color: ourLightPrimaryColor(),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Text(
          widget.text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
