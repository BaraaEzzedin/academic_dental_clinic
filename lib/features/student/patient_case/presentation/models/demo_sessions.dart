import 'session.dart';

/// Placeholder session data for the Treatment Sessions screen.
///
/// The Case Details API does not yet return a sessions payload; the in-treatment
/// add/edit-session workflow still operates on this in-memory list. Replace with
/// a real sessions endpoint when the backend exposes one.
List<Session> demoSessions() => const [
      Session(
        title: 'Initial Assessment & Access',
        date: 'Aug 12, 2023',
        status: SessionStatus.completed,
        items: [
          SessionItem(label: 'Diagnostic work-up', done: true),
          SessionItem(label: 'Access cavity preparation', done: true),
        ],
        treatmentItems: [
          SessionTreatmentItem(
            tooth: 'Tooth #13',
            procedure: 'Endodontic Access',
            status: SessionStatus.completed,
          ),
        ],
        note: 'Diagnostic work-up completed. Access cavities prepared under '
            'rubber dam isolation.',
      ),
      Session(
        title: 'Canal Shaping & Cleaning',
        date: 'Sep 04, 2023',
        status: SessionStatus.inProgress,
        items: [
          SessionItem(label: 'Working length determination', done: true),
          SessionItem(label: 'Canal instrumentation', done: false),
        ],
        treatmentItems: [
          SessionTreatmentItem(
            tooth: 'Tooth #13',
            procedure: 'Endodontic Access',
            status: SessionStatus.inProgress,
          ),
        ],
        note: 'Working length confirmed radiographically. Continue '
            'instrumentation to the master apical file.',
      ),
    ];
