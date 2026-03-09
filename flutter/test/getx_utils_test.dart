import 'package:flutter_test/flutter_test.dart';
import 'package:getx_helper/src/getx_utils.dart';

void main() {
  group('GetxUtils.uniqueTag', () {
    test('应该生成唯一的tag', () {
      final tag1 = GetxUtils.uniqueTag();
      final tag2 = GetxUtils.uniqueTag();

      expect(tag1, isNotEmpty);
      expect(tag2, isNotEmpty);
      expect(tag1, isNot(equals(tag2)));
      // 验证生成的tag是否全为数字（随机数 + 时间戳组合）
      expect(RegExp(r'^\d+$').hasMatch(tag1), isTrue);
    });

    test('应该使用默认count参数(3)生成tag', () {
      final tag = GetxUtils.uniqueTag();
      // count=3，前缀是1+3=4位，时间戳毫秒数是13位，共17位
      expect(tag.length, greaterThanOrEqualTo(16));
    });

    for (final count in [1, 5, 10, 0]) {
      test('应该使用自定义count参数($count)生成tag', () {
        final tag = GetxUtils.uniqueTag(count: count);
        expect(tag, isNotEmpty);
        // count 为几，前缀就额外叠加几次。由于每次随机0-9一位数字，前缀总长 count + 1
        // 时间戳毫秒为 13 位数字
        expect(tag.length, equals(count + 1 + 13));
      });
    }
  });

  group('GetxUtils.appendAiTag', () {
    final testCases = [
      (
        desc: 'assignId为true时应该追加ai:1',
        tag: 'test',
        assignId: true,
        expected: 'test|ai:1'
      ),
      (
        desc: 'assignId为false时不追加任何内容',
        tag: 'test',
        assignId: false,
        expected: 'test'
      ),
      (
        desc: 'tag已经包含ai:时不做处理',
        tag: 'test|ai:0',
        assignId: true,
        expected: 'test|ai:0'
      ),
      (
        desc: 'tag已经包含ai:1时且assignId为false不做处理',
        tag: 'test|ai:1',
        assignId: false,
        expected: 'test|ai:1'
      ),
      (
        desc: 'tag以分隔符结尾时应该正确追加',
        tag: 'test|',
        assignId: true,
        expected: 'test|ai:1'
      ),
      (
        desc: '复杂tag应该正确处理',
        tag: 'home|page|detail',
        assignId: true,
        expected: 'home|page|detail|ai:1'
      ),
      (
        desc: '空tag应该正确处理',
        tag: '',
        assignId: true,
        expected: '|ai:1'
      ),
      (
        desc: 'tag包含多个分隔符且assignId为false应该返回原tag',
        tag: 'a|b|c|d',
        assignId: false,
        expected: 'a|b|c|d'
      ),
      (
        desc: 'tag包含ai:在中间位置时不做处理',
        tag: 'test|ai:0|other',
        assignId: true,
        expected: 'test|ai:0|other'
      ),
    ];

    for (final tc in testCases) {
      test(tc.desc, () {
        final result = GetxUtils.appendAiTag(
          tag: tc.tag,
          assignId: tc.assignId,
        );
        expect(result, equals(tc.expected));
      });
    }
  });
}
