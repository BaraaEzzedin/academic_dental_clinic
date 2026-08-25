import 'package:flutter/material.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../models/treatment_plan.dart';

class TreatmentPlanRowTile extends StatelessWidget {
  const TreatmentPlanRowTile({super.key, required this.row});

  final TreatmentPlanRow row;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(row.tooth, style: AppTextStyles.caseToothLabel),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: Text(
            row.procedure,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caseProcedure,
          ),
        ),
      ],
    );
  }
}