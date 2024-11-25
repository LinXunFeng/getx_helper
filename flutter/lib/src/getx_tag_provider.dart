import 'package:flutter/material.dart';

import 'package:getx_helper/src/getx_utils.dart';

class GetxTagProvider<T> extends StatefulWidget {
  const GetxTagProvider({
    super.key,
    required this.child,
    this.logicTag,
    this.onInit,
  });

  final Widget child;

  final String? logicTag;

  final Function(String tag)? onInit;

  @override
  State<GetxTagProvider<T>> createState() => _GetxTagProviderState<T>();

  // 定义一个便捷方法，方便子树中的widget获取共享数据
  //
  // 该方法面对 StatefulWidget 时，会依赖当前 widget 的状态，请在 build 方法中使用，
  // 不要在 initState 中使用，否则会抛异常，这是正常的！
  // 如果你一定要在 initState 中取 logicTag，请使用 tag 方法
  static String standardTag(BuildContext context) {
    return GetxTagProviderInheritedWidget.standardTag(context);
  }

  // 定义一个便捷方法，方便子树中的widget获取共享数据
  static String tag(BuildContext context) {
    return GetxTagProviderInheritedWidget.tag(context);
  }
}

class _GetxTagProviderState<T> extends State<GetxTagProvider<T>> {
  String logicTag = '';

  @override
  void initState() {
    super.initState();

    logicTag = widget.logicTag ?? GetxUtils.uniqueTag();

    // 把 logicTag 通过 onInit 回调传递给外部
    widget.onInit?.call(logicTag);
  }

  @override
  Widget build(BuildContext context) {
    return GetxTagProviderInheritedWidget(
      logicTag: logicTag,
      child: widget.child,
    );
  }
}

class GetxTagProviderInheritedWidget extends InheritedWidget {
  const GetxTagProviderInheritedWidget({
    super.key,
    required super.child,
    required this.logicTag,
  });

  /// 存储 logicTag
  final String logicTag;

  @override
  bool updateShouldNotify(GetxTagProviderInheritedWidget oldWidget) {
    return oldWidget.logicTag != logicTag;
  }

  // 定义一个便捷方法，方便子树中的widget获取共享数据
  static GetxTagProviderInheritedWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GetxTagProviderInheritedWidget>();
  }

  // 定义一个便捷方法，方便子树中的widget获取共享数据
  static GetxTagProviderInheritedWidget? element(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<
        GetxTagProviderInheritedWidget>();
    final widget = element?.widget;
    if (widget is! GetxTagProviderInheritedWidget) {
      return null;
    }
    return widget;
  }

  // 定义一个便捷方法，方便子树中的widget获取共享数据
  //
  // 该方法面对 StatefulWidget 时，会依赖当前 widget 的状态，请在 build 方法中使用，
  // 不要在 initState 中使用，否则会抛异常，这是正常的！
  // 如果你一定要在 initState 中取 logicTag，请使用 tag 方法
  static String standardTag(BuildContext context) {
    final logicTag = GetxTagProviderInheritedWidget.of(context)?.logicTag;
    assert(
      logicTag != null,
      "你的用法有问题, 请确保有正确使用GetxTagProvider!",
    );
    return logicTag ?? '';
  }

  // 定义一个便捷方法，方便子树中的widget获取共享数据
  static String tag(BuildContext context) {
    final logicTag = GetxTagProviderInheritedWidget.element(context)?.logicTag;
    assert(
      logicTag != null,
      "你的用法有问题, 请确保有正确使用GetxTagProvider!",
    );
    return logicTag ?? '';
  }
}
