import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DonutChart extends StatefulWidget {
  DonutChart({
    required this.title,
    required this.size,
    required this.percentComplete,
    Key? key
  }) : super(key: key);

  String title;
  int size;
  int percentComplete;

  @override
  _DonutChartState createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: widget.size.toDouble(),
            width: widget.size.toDouble(),
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: 270,
                    sectionsSpace: 0,
                    centerSpaceRadius: widget.size / 2 - 20,
                    sections: [
                      PieChartSectionData(
                        value: widget.percentComplete.toDouble(),
                        color: const Color(0xFF11DC5C),
                        radius: 10,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: 100 - widget.percentComplete.toDouble(),
                        color: const Color(0x00FFFFFF),
                        radius: 10,
                        showTitle: false,
                      )
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: widget.size.toDouble() - 40,
                        width: widget.size.toDouble() - 40,
                        decoration: const BoxDecoration(
                          color: Color(0x00FFFFFF),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            "${widget.percentComplete}%",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Text(
            widget.title,
            style: TextStyle(fontSize: 16),
          )
        ],
    );
  }
}