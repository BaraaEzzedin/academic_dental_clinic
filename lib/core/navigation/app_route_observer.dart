import 'package:flutter/material.dart';

/// App-wide observer for full-screen page routes.
///
/// Screens can subscribe as [RouteAware] to react when a route pushed on top of
/// them is popped and they become visible again (`didPopNext`). Registered in
/// `MaterialApp.navigatorObservers`.
final RouteObserver<PageRoute<dynamic>> appRouteObserver =
    RouteObserver<PageRoute<dynamic>>();
