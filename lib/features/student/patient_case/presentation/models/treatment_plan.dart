// models for ui , edit when backend is ready

// A single planned procedure on a tooth, e.g. "Tooth #13" -> "Endodontic Access".
class TreatmentPlanRow {
  const TreatmentPlanRow({
    required this.tooth,
    required this.procedure,
  });

  final String tooth;
  final String procedure;
}

// A highlighted summary chip, e.g. "TARGET TOOTH" -> "Tooth #32".
class PlanHighlight {
  const PlanHighlight({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}