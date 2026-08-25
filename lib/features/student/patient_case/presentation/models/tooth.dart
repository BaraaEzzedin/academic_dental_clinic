import 'package:flutter/material.dart';

// Clinical model for the dental chart (odontogram). FDI numbering.

/// Visual/clinical condition of a tooth on the chart.
enum ToothStatus { healthy, treated, pending, approved, rejected, extracted }

/// Anatomical tooth class, derived from the FDI number.
enum ToothType { incisor, canine, premolar, molar }

/// Supervisor review state of a single procedure.
enum ApprovalStatus { pendingReview, approved, rejected, completed }

/// Common dental procedures.
enum ProcedureType {
  compositeFilling,
  amalgamFilling,
  rootCanal,
  crown,
  bridge,
  extraction,
  implant,
  scalingPolishing,
  veneer,
  temporaryRestoration,
}

extension ProcedureTypeX on ProcedureType {
  String get label => switch (this) {
        ProcedureType.compositeFilling => 'Composite filling',
        ProcedureType.amalgamFilling => 'Amalgam filling',
        ProcedureType.rootCanal => 'Root canal treatment (RCT)',
        ProcedureType.crown => 'Crown',
        ProcedureType.bridge => 'Bridge',
        ProcedureType.extraction => 'Extraction',
        ProcedureType.implant => 'Implant',
        ProcedureType.scalingPolishing => 'Scaling & polishing',
        ProcedureType.veneer => 'Veneer',
        ProcedureType.temporaryRestoration => 'Temporary restoration',
      };

  /// Distinct marker color per procedure family — used for the subtle
  /// tick markers on the crown and for the timeline dots.
  Color get markerColor => switch (this) {
        ProcedureType.compositeFilling => const Color(0xFF38BDF8), // sky
        ProcedureType.amalgamFilling => const Color(0xFF64748B), // slate
        ProcedureType.rootCanal => const Color(0xFF8B5CF6), // violet
        ProcedureType.crown => const Color(0xFFEAB308), // gold
        ProcedureType.bridge => const Color(0xFF6366F1), // indigo
        ProcedureType.extraction => const Color(0xFFE5484D), // red
        ProcedureType.implant => const Color(0xFF0E9384), // teal
        ProcedureType.scalingPolishing => const Color(0xFF06B6D4), // cyan
        ProcedureType.veneer => const Color(0xFFEC4899), // pink
        ProcedureType.temporaryRestoration => const Color(0xFF98A2B3), // gray
      };
}

extension ApprovalStatusX on ApprovalStatus {
  String get label => switch (this) {
        ApprovalStatus.pendingReview => 'Pending review',
        ApprovalStatus.approved => 'Approved',
        ApprovalStatus.rejected => 'Rejected',
        ApprovalStatus.completed => 'Completed',
      };
}

/// One entry in a tooth's treatment history.
class ProcedureRecord {
  const ProcedureRecord({
    required this.type,
    required this.date,
    required this.student,
    required this.approval,
    this.supervisor,
    this.notes,
  });

  final ProcedureType type;
  final DateTime date;
  final String student;
  final ApprovalStatus approval;
  final String? supervisor;
  final String? notes;
}

/// Full clinical record of one tooth. Supports any number of procedures.
class ToothRecord {
  const ToothRecord({this.procedures = const [], this.extracted = false});

  final List<ProcedureRecord> procedures;
  final bool extracted;

  /// Procedures newest-first for timeline display.
  List<ProcedureRecord> get chronological {
    final list = [...procedures]..sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  /// Derived chart status. Precedence: extracted > pending review >
  /// latest decision (approved / rejected) > any history (treated).
  ToothStatus get status {
    if (extracted) return ToothStatus.extracted;
    if (procedures.isEmpty) return ToothStatus.healthy;
    if (procedures.any((p) => p.approval == ApprovalStatus.pendingReview)) {
      return ToothStatus.pending;
    }
    final latest = chronological.first;
    return switch (latest.approval) {
      ApprovalStatus.approved => ToothStatus.approved,
      ApprovalStatus.rejected => ToothStatus.rejected,
      _ => ToothStatus.treated,
    };
  }
}

/// Resolves the anatomical class from an FDI number (e.g. 16 -> molar).
ToothType toothTypeOf(int fdi) {
  final p = fdi % 10;
  if (p <= 2) return ToothType.incisor;
  if (p == 3) return ToothType.canine;
  if (p <= 5) return ToothType.premolar;
  return ToothType.molar;
}

/// Human-readable clinical name, e.g. "Upper right first molar".
String toothNameOf(int fdi) {
  const names = [
    'central incisor', 'lateral incisor', 'canine', 'first premolar',
    'second premolar', 'first molar', 'second molar', 'third molar',
  ];
  const quadrants = {
    1: 'Upper right',
    2: 'Upper left',
    3: 'Lower left',
    4: 'Lower right',
  };
  return '${quadrants[fdi ~/ 10]} ${names[fdi % 10 - 1]}';
}

/// Everything the chart knows about one tooth — passed to overlay builders.
class ToothInfo {
  const ToothInfo({
    required this.fdi,
    required this.type,
    required this.status,
    required this.selected,
    required this.isUpper,
    this.record,
  });

  final int fdi;
  final ToothType type;
  final ToothStatus status;
  final bool selected;
  final bool isUpper;
  final ToothRecord? record;

  int get quadrant => fdi ~/ 10;
}
