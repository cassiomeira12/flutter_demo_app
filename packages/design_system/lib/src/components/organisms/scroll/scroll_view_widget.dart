import 'package:dependency/dependency.dart';

class ScrollViewWidget extends StatefulWidget {
  final Widget Function(ScrollController scrollController) child;

  const ScrollViewWidget({super.key, required this.child});

  @override
  State<ScrollViewWidget> createState() => _ScrollViewWidgetState();
}

class _ScrollViewWidgetState extends State<ScrollViewWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      interactive: true,
      thumbVisibility: true,
      trackVisibility: true,
      child: widget.child.call(_scrollController),
    );
  }
}
