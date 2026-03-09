import 'dart:math';

class GetxUtils {
  static const String _separator = '|';
  static const String _assignIdPrefix = 'ai:';

  /// 生成一个唯一的tag
  static String uniqueTag({int count = 3}) {
    String randomStr = Random().nextInt(10).toString();
    for (var i = 0; i < count; i++) {
      var str = Random().nextInt(10);
      randomStr = "$randomStr$str";
    }
    final timeNumber = DateTime.now().millisecondsSinceEpoch;
    final uuid = "$randomStr$timeNumber";
    return uuid;
  }

  /// 拼接 ai:1
  static String appendAiTag({
    required String tag,
    required bool assignId,
  }) {
    // 如果 assignId 为 false 或 tag 已经包含 "ai:"，不做处理
    if (!assignId || tag.contains(_assignIdPrefix)) {
      return tag;
    }

    // 确保以分隔符结尾
    tag = _ensureEndsWithSeparator(tag);

    // 拼接 ai:1
    const String value = '1';
    return '$tag$_assignIdPrefix$value';
  }

  /// 确保字符串以分隔符结尾
  static String _ensureEndsWithSeparator(String tag) {
    if (!tag.endsWith(_separator)) {
      return '$tag$_separator';
    }
    return tag;
  }
}
