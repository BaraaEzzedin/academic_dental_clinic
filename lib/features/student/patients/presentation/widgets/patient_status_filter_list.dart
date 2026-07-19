import 'package:flutter/material.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../models/assigned_patient.dart';
import 'patient_status_filter_chip.dart';


class PatientStatusFilterList extends StatelessWidget {
  const PatientStatusFilterList({
    super.key,
    required this.selected,
    required this.onSelected,
    this.filters = PatientStatusFilter.values,
  });

  final List<PatientStatusFilter> filters;
  final PatientStatusFilter selected;
  final ValueChanged<PatientStatusFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenHorizontalPadding,
        ),
        itemCount: filters.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppDimensions.sm),
        itemBuilder: (context, index) {
          final filter = filters[index];
          return PatientStatusFilterChip(
            label: filter.label,
            selected: filter == selected,
            onTap: () => onSelected(filter),
          );
        },
      ),
    );
  }
}