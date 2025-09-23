import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_helper/getx_helper.dart';

/// 封装以解决在 Hero 动画过程中 GetxLogicConsumerStateMixin 报 logicTag 找不到的问题
class GHHero<T extends GetxController> extends StatefulWidget {
  // ====== 原参数 ======
  final String tag;
  final CreateRectTween? createRectTween;
  final HeroFlightShuttleBuilder? flightShuttleBuilder;
  final HeroPlaceholderBuilder? placeholderBuilder;
  final bool transitionOnUserGestures;
  final Widget child;

  // ====== 自定义参数 ======
  final String logicTag;

  const GHHero({
    super.key,
    // ====== 原参数 ======
    required this.tag,
    required this.child,
    this.createRectTween,
    this.flightShuttleBuilder,
    this.placeholderBuilder,
    this.transitionOnUserGestures = false,

    // ====== 自定义参数 ======
    required this.logicTag,
  });

  @override
  State<GHHero<T>> createState() => _GHHeroState<T>();
}

class _GHHeroState<T extends GetxController> extends State<GHHero<T>> {
  @override
  Widget build(BuildContext context) {
    Widget resultWidget = widget.child;
    resultWidget = GetxTagProvider<T>(
      logicTag: widget.logicTag,
      child: resultWidget,
    );

    resultWidget = Hero(
      tag: widget.tag,
      createRectTween: widget.createRectTween,
      flightShuttleBuilder: widget.flightShuttleBuilder,
      placeholderBuilder: widget.placeholderBuilder,
      transitionOnUserGestures: widget.transitionOnUserGestures,
      child: resultWidget,
    );

    return resultWidget;
  }
}
