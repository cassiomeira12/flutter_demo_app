import 'package:dependency/dependency.dart';
import 'package:flutter_demo_app/presentation/emergency/widgets/ripple/circle_painter.dart';
import 'package:flutter_demo_app/presentation/emergency/widgets/ripple/curve_wave.dart';

class RipplesAnimation extends StatefulWidget {
  final String text;
  final double size;
  final Rxn<AnimationController> controller;
  final ValueChanged<bool>? onChange;
  final Color? color;

  final Future<int> Function()? functionOptions;
  final Future<void> Function(int)? sendSOS;

  const RipplesAnimation({
    super.key,
    required this.text,
    required this.size,
    required this.controller,
    this.onChange,
    this.color,
    this.functionOptions,
    this.sendSOS,
  });

  @override
  State<RipplesAnimation> createState() => _RipplesAnimationState();
}

class _RipplesAnimationState extends State<RipplesAnimation>
    with TickerProviderStateMixin {
  // AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    widget.controller.value = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    // _controller = widget.controller ??
    //     AnimationController(
    //       duration: const Duration(milliseconds: 900),
    //       vsync: this,
    //     );
  }

  @override
  void dispose() {
    widget.controller.value?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Visibility(
            visible: widget.controller.value!.isAnimating,
            child: Container(
              width: widget.size,
              height: widget.size,
              constraints: const BoxConstraints(
                maxWidth: 350,
                maxHeight: 350,
              ),
              child: CustomPaint(
                painter: CirclePainter(
                  widget.controller.value!,
                  color: widget.color ?? Theme.of(context).primaryColor,
                ),
                child: SizedBox(
                  width: widget.size * 4.6,
                  height: widget.size * 4.6,
                ),
              ),
            ),
          ),
          _button(context),
        ],
      ),
    );
  }

  Widget _button(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: widget.size / 2,
      height: widget.size / 2,
      constraints: const BoxConstraints(maxWidth: 180, maxHeight: 180),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.size),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            offset: Offset(0.0, 1.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                widget.color ?? Theme.of(context).primaryColor,
                Color.lerp(
                      widget.color ?? Theme.of(context).primaryColor,
                      Colors.transparent,
                      .05,
                    ) ??
                    Colors.transparent,
              ],
            ),
          ),
          child: ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(
                parent: widget.controller.value!,
                curve: const CurveWave(),
              ),
            ),
            child: InkWell(
              splashColor: Colors.white,
              borderRadius: BorderRadius.circular(widget.size),
              child: Center(
                child: Text(
                  widget.text,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: widget.size / 8 > 50 ? 50 : widget.size / 8,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
              onTap: () async {
                try {
                  if (!widget.controller.value!.isAnimating) {
                    final int? choice = await widget.functionOptions?.call();
                    if (choice != null) {
                      widget.controller.value!.repeat();
                      widget.onChange?.call(true);
                      await widget.sendSOS?.call(choice);
                    }
                  } else {
                    widget.controller.value!.stop();
                    widget.onChange?.call(false);
                  }
                } catch (error) {
                  widget.controller.value!.stop();
                  widget.onChange?.call(false);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
