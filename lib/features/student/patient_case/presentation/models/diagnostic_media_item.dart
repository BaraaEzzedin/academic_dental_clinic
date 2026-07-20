// model for ui , edit when backend is ready
// [imageUrl] is null until the backend provides media; the UI shows a
// placeholder in that case.
class DiagnosticMediaItem {
  const DiagnosticMediaItem({
    required this.label,
    required this.date,
    this.imageUrl,
  });

  final String label;
  final String date;
  final String? imageUrl;
}