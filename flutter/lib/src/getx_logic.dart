import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_helper/src/getx_tag_provider.dart';

/// 获取 logic
///
/// 用法: GetxLogic.of<MyGetxLogic>(context);
class GetxLogic {
  /// 获取 logic
  ///
  /// 对应 GetxTagProvider.standardTag
  /// 注: 请仅在 build 方法中使用，不要在 initState/dispose 方法中使用，会报错！
  static T standardOf<T extends GetxController>(BuildContext context) {
    final tag = GetxTagProviderInheritedWidget.standardTag(context);
    return Get.find<T>(tag: tag);
  }

  /// 获取 logic
  ///
  /// 对应 GetxLogicTagProvider.tag
  /// 注: 请不要在 dispose 方法中使用，会报错！
  static T of<T extends GetxController>(BuildContext context) {
    final tag = GetxTagProviderInheritedWidget.tag(context);
    return Get.find<T>(tag: tag);
  }
}

extension StateGetxLogic on State {
  /// 获取 logic
  ///
  /// 用法: getxLogic<MyGetxLogic>();
  T getxLogic<T extends GetxController>() {
    return GetxLogic.of<T>(context);
  }

  /// 获取 logic
  ///
  /// 用法: getxStandardLogic<MyGetxLogic>();
  T getxStandardLogic<T extends GetxController>() {
    return GetxLogic.standardOf<T>(context);
  }
}

extension BuildContextGetxLogic on BuildContext {
  /// 获取 logic
  ///
  /// 用法: context.getxLogic<MyGetxLogic>();
  T getxLogic<T extends GetxController>() {
    return GetxLogic.of<T>(this);
  }

  /// 获取 logic
  ///
  /// 用法: context.getxStandardLogic<MyGetxLogic>();
  T getxStandardLogic<T extends GetxController>() {
    return GetxLogic.standardOf<T>(this);
  }
}
