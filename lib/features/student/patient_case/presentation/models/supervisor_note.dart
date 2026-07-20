// model for ui , edit when backend is ready
// A supervisor note attached to a specific session of the case.
class SupervisorNote {
  const SupervisorNote({
    required this.reviewer,
    required this.session,
    required this.date,
    required this.timeAgo,
    required this.message,
    this.avatarUrl,
  });

  final String reviewer;
  final int session;
  final String date;
  final String timeAgo;
  final String message;
  final String? avatarUrl;
}