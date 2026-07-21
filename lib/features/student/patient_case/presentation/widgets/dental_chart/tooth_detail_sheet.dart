import 'package:flutter/material.dart';
import '../../models/tooth.dart';
import 'dental_chart_theme.dart';
import 'tooth_painter.dart';

/// Opens the (view-only) detail sheet for [fdi]. Returns when dismissed.
Future<void> showToothDetailSheet(
  BuildContext context, {
  required int fdi,
  ToothRecord? record,
  DentalChartTheme theme = const DentalChartTheme(),
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.62,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scroll) => ToothDetailSheet(
        fdi: fdi,
        record: record ?? const ToothRecord(),
        theme: theme,
        scrollController: scroll,
      ),
    ),
  );
}

class ToothDetailSheet extends StatelessWidget {
  const ToothDetailSheet({
    super.key,
    required this.fdi,
    required this.record,
    required this.theme,
    this.scrollController,
  });

  final int fdi;
  final ToothRecord record;
  final DentalChartTheme theme;
  final ScrollController? scrollController;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static String _fmt(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

  @override
  Widget build(BuildContext context) {
    final status = record.status;
    final statusC = theme.statusColor(status);
    final history = record.chronological;
    final latest = history.isEmpty ? null : history.first;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE4EAF1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              children: [
                _header(status, statusC),
                const SizedBox(height: 18),
                _metaCard(latest),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Text(
                      'Treatment history',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: theme.labelStrong,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F5F8),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${history.length}',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: theme.label,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (history.isEmpty)
                  _emptyHistory()
                else
                  for (int i = 0; i < history.length; i++)
                    _TimelineEntry(
                      record: history[i],
                      isLast: i == history.length - 1,
                      theme: theme,
                      dateText: _fmt(history[i].date),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(ToothStatus status, Color statusC) {
    return Row(
      children: [
        // Mini anatomical preview of the tooth in its current status.
        Container(
          width: 64,
          height: 64,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE7ECF2)),
          ),
          child: CustomPaint(
            painter: ToothPainter(
              type: toothTypeOf(fdi),
              status: status,
              theme: theme,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tooth $fdi',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: theme.labelStrong,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                toothNameOf(fdi),
                style: TextStyle(fontSize: 13, color: theme.label),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusC.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration:
                          BoxDecoration(color: statusC, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      theme.statusLabel(status),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusC,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _metaCard(ProcedureRecord? latest) {
    Widget cell(IconData icon, String label, String value) => Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 14, color: theme.label),
                  const SizedBox(width: 5),
                  Text(label, style: TextStyle(fontSize: 11, color: theme.label)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.labelStrong,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7ECF2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              cell(Icons.person_outline_rounded, 'Treating student',
                  latest?.student ?? '—'),
              cell(Icons.event_outlined, 'Last treatment',
                  latest == null ? '—' : _fmt(latest.date)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              cell(Icons.verified_outlined, 'Supervisor',
                  latest?.supervisor ?? '—'),
              cell(Icons.fact_check_outlined, 'Approval',
                  latest?.approval.label ?? '—'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyHistory() => Container(
        padding: const EdgeInsets.symmetric(vertical: 26),
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(Icons.health_and_safety_outlined,
                size: 30, color: theme.label.withValues(alpha: 0.5)),
            const SizedBox(height: 8),
            Text(
              'No procedures recorded — healthy tooth',
              style: TextStyle(fontSize: 13, color: theme.label),
            ),
          ],
        ),
      );
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.record,
    required this.isLast,
    required this.theme,
    required this.dateText,
  });

  final ProcedureRecord record;
  final bool isLast;
  final DentalChartTheme theme;
  final String dateText;

  Color get _approvalColor => switch (record.approval) {
        ApprovalStatus.pendingReview => theme.pending,
        ApprovalStatus.approved => theme.approved,
        ApprovalStatus.rejected => theme.rejected,
        ApprovalStatus.completed => theme.treated,
      };

  @override
  Widget build(BuildContext context) {
    final marker = record.type.markerColor;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline rail: colored dot per procedure + connector.
          SizedBox(
            width: 26,
            child: Column(
              children: [
                const SizedBox(height: 4),
                Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    color: marker,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                          color: marker.withValues(alpha: 0.35), blurRadius: 5)
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: const Color(0xFFE7ECF2)),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          record.type.label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: theme.labelStrong,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _approvalColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          record.approval.label,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: _approvalColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$dateText · ${record.student}'
                    '${record.supervisor != null ? ' · Sup. ${record.supervisor}' : ''}',
                    style: TextStyle(fontSize: 12, color: theme.label),
                  ),
                  if (record.notes != null && record.notes!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEDF1F6)),
                      ),
                      child: Text(
                        record.notes!,
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.45,
                          color: theme.labelStrong.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}