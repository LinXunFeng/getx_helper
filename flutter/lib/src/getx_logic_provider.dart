import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getx_helper/src/getx_logic.dart';
import 'package:getx_helper/src/getx_tag.dart';

import 'package:getx_helper/src/getx_tag_provider.dart';
import 'package:getx_helper/src/getx_utils.dart';

typedef GetxLogicCreate<T extends GetxController> = T Function();

/// 用于提供 logic 的 Widget
class GetxLogicProvider<T extends GetxController> extends StatefulWidget {
  const GetxLogicProvider({
    super.key,
    required this.child,
    this.logicTag,
    this.initLogic,
    this.onDispose,
    @Deprecated('请不要使用这个参数') this.createLogicFn,
  });

  const GetxLogicProvider.put(
    this.createLogicFn, {
    super.key,
    required this.child,
    this.logicTag,
    this.onDispose,
    @Deprecated('请不要使用这个参数') this.initLogic,
  });

  final Widget child;

  final String? logicTag;

  final T Function(String tag)? initLogic;

  final Function(BuildContext context, T? logic, String logicTag)? onDispose;

  final GetxLogicCreate<T>? createLogicFn;

  @override
  State<GetxLogicProvider> createState() => _GetxLogicProviderState<T>();
}

class _GetxLogicProviderState<T extends GetxController>
    extends State<GetxLogicProvider<T>> {
  /// 记录当前的 logic
  T? logic;

  /// 记录当前的 logicTag
  late String logicTag;

  @override
  void dispose() {
    widget.onDispose?.call(context, logic, logicTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetxTagProvider<T>(
      logicTag: widget.logicTag,
      onInit: (tag) {
        logicTag = tag;

        T? innerLogic;
        if (widget.createLogicFn != null) {
          innerLogic = widget.createLogicFn!();
        } else if (widget.initLogic != null) {
          innerLogic = widget.initLogic!(tag);
        }

        if (innerLogic == null) return;
        logic = Get.put<T>(
          innerLogic,
          tag: tag,
        );
      },
      child: widget.child,
    );
  }
}

mixin GetxLogicPutStateMixin<T extends GetxController, W extends StatefulWidget>
    on State<W> implements GetxLogicPutStateMixinBuilder<T> {
  /// 记录当前的 logic
  late T logic;

  /// 记录当前的 logicTag
  late String logicTag;

  @override
  String? customLogicTag() {
    return null;
  }

  @override
  void initState() {
    super.initState();

    logicTag = customLogicTag.call() ?? GetxUtils.uniqueTag();
    logic = initLogic();

    // 在这里 put，logic 的 onInit 方法就会走 这样在使用时就可以在 initState 里放心使用
    // logic.onInit 里初始化的数据了
    Get.put<T>(
      logic,
      tag: logicTag,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetxTagProvider<T>(
      logicTag: logicTag,
      child: buildBody(context),
    );
  }
}

abstract class GetxLogicPutStateMixinBuilder<T extends GetxController> {
  /// 初始化 logic
  T initLogic();

  /// 自定义 logicTag
  String? customLogicTag();

  /// 构建 body
  Widget buildBody(BuildContext context);
}

class GetxLogicConsumer<T extends GetxController> extends StatefulWidget {
  @Deprecated(
    '因为经常忘记传泛型，导致运行时报错，不安全，不推荐使用，请使用 GetxLogicConsumer.get',
  )
  const GetxLogicConsumer({
    super.key,
    required this.builder,
    this.onInitState,
    this.onDispose,
    @Deprecated('请不要使用这个参数') this.createLogicFn,
  });

  const GetxLogicConsumer.get(
    this.createLogicFn, {
    super.key,
    required this.builder,
    this.onInitState,
    this.onDispose,
  });

  final GetxLogicCreate<T>? createLogicFn;

  final Widget Function(BuildContext context, T logic, String logicTag) builder;

  final Function(BuildContext context, T logic, String logicTag)? onInitState;

  final Function(BuildContext context, T logic, String logicTag)? onDispose;

  @override
  State<GetxLogicConsumer<T>> createState() => _GetxLogicConsumerState<T>();
}

class _GetxLogicConsumerState<T extends GetxController>
    extends State<GetxLogicConsumer<T>>
    with GetxLogicConsumerStateMixin<T, GetxLogicConsumer<T>> {
  @override
  void initState() {
    super.initState();
    widget.onInitState?.call(context, logic, logicTag);
  }

  @override
  void dispose() {
    widget.onDispose?.call(context, logic, logicTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, logic, logicTag);
  }
}

mixin GetxLogicConsumerStateMixin<T extends GetxController,
    W extends StatefulWidget> on State<W> {
  /// 记录当前的 logic
  late T logic;

  /// 记录当前的 logicTag
  late String logicTag;

  @override
  void initState() {
    super.initState();

    logicTag = getxTag();
    logic = getxLogic<T>();
  }
}
