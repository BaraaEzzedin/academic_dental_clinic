import 'package:flutter_bloc/flutter_bloc.dart';
import 'bottom_nav_state.dart';

/// Holds which tab is currently selected in the student home bottom
/// navigation bar. Kept intentionally small — the bar only needs to know
/// the active destination.
class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(const BottomNavState());

  void selectTab(NavTab tab) {
    if (tab == state.tab) return;
    emit(state.copyWith(tab: tab));
  }

  void selectIndex(int index) {
    if (index < 0 || index >= NavTab.values.length) return;
    selectTab(NavTab.values[index]);
  }
}