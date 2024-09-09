import 'package:flutter/widgets.dart';

mixin AnalyticsMixin {
  void screenTagging({String? route}) {
    _tagging('screen', route: route);
  }

  void clickTagging({String? route}) {
    _tagging('click', route: route);
  }

  void backTagging({String? route}) {
    _tagging('back', route: route);
  }

  void callbackTagging({String? route}) {
    _tagging('callback', route: route);
  }

  void _tagging(
    String event, {
    String? route,
  }) {
    String page = '$runtimeType'.replaceAll('Controller', 'Page');
    debugPrint('Event -> $page - $event - [$route]');
  }
}
