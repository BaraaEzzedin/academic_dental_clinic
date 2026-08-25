import 'package:equatable/equatable.dart';

/// The destinations shown in the student home bottom navigation bar.
/// Order here defines the order in the bar and the [BottomNavState.index].
enum NavTab { home, openCases, patients, profile }

class BottomNavState extends Equatable {
  const BottomNavState({this.tab = NavTab.home});

  final NavTab tab;

  int get index => tab.index;

  BottomNavState copyWith({NavTab? tab}) {
    return BottomNavState(tab: tab ?? this.tab);
  }

  @override
  List<Object?> get props => [tab];
}