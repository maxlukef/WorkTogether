import 'package:flutter/material.dart';
import 'package:work_together_flutter/models/milestone_models/milestone.dart';

class MilestoneDropDown extends StatefulWidget {
  const MilestoneDropDown({
    super.key,
    required this.dropdownValueSetter,
    required this.milestones,
    required this.initialValue,
    this.initialMilestone,
    this.initialMilestoneID,
  });
  final ValueSetter<Milestone> dropdownValueSetter;
  final List<Milestone> milestones;
  final bool initialValue;
  final Milestone? initialMilestone;
  final int? initialMilestoneID;
  @override
  State<MilestoneDropDown> createState() => _MilestoneDropDownState();
}

class _MilestoneDropDownState extends State<MilestoneDropDown> {
  late Milestone dropdownValue;

  @override
  void initState() {
    super.initState();
    getUsersMilestonesCall();
  }

  Future<void> getUsersMilestonesCall() async {
    // Initialize milestone.
    dropdownValue = widget.milestones.first;
    if (widget.initialValue) {
      if (widget.initialMilestone != null) {
        dropdownValue = widget.initialMilestone!;
      }
      if (widget.initialMilestoneID != null) {
        for (Milestone m in widget.milestones) {
          if (m.id == widget.initialMilestoneID) {
            dropdownValue = m;
          }
        }
      }
    }

    // Callback to sync the initial value to the parent widget.
    widget.dropdownValueSetter(dropdownValue);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Milestone>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (Milestone? value) {
        dropdownValue = value!;
        widget.dropdownValueSetter(dropdownValue);
        setState(() {});
      },
      items:
          widget.milestones.map<DropdownMenuItem<Milestone>>((Milestone value) {
        return DropdownMenuItem<Milestone>(
          value: value,
          child: Text(value.title),
        );
      }).toList(),
    );
  }
}
