import 'package:flutter/material.dart';
import 'dental_chart_theme.dart';

class DentalChartLegend extends StatelessWidget {
  const DentalChartLegend({super.key, this.theme = const DentalChartTheme()});
  final DentalChartTheme theme;

  @override
  Widget build(BuildContext context) {
    Widget chip(Color c, String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(color: c, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 11.5,
                    color: theme.label,
                    fontWeight: FontWeight.w500)),
          ],
        );

    return Wrap(
      spacing: 14,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        chip(theme.outline, 'Healthy'),
        chip(theme.treated, 'Treated'),
        chip(theme.pending, 'Pending'),
        chip(theme.approved, 'Approved'),
        chip(theme.rejected, 'Rejected'),
        chip(theme.extracted, 'Extracted'),
      ],
    );
  }
}