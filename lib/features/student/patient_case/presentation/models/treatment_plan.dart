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