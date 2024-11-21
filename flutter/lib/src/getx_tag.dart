import 'package:flutter/material.dart';

import 'package:getx_helper/src/getx_tag_provider.dart';

extension StateGetxTag on State {
  /// 获取 tag
  ///
  /// 用法: state.getxTag();
  String getxTag() {
    return GetxTagProviderInheritedWidget.tag(context);
  }

  /// 获取 tag
  ///
  /// 用法: state.getxStandardTag();
  String getxStandardTag() {
    return GetxTagProviderInheritedWidget.standardTag(context);
  }
}

extension BuildContextGetxTag on BuildContext {
  /// 获取 tag
  ///
  /// 用法: context.getxTag();
  String getxTag() {
    return GetxTagProviderInheritedWidget.tag(this);
  }

  /// 获取 tag
  ///
  /// 用法: context.getxStandardTag();
  String getxStandardTag() {
    return GetxTagProviderInheritedWidget.standardTag(this);
  }
}
