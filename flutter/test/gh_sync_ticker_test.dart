import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_helper/src/widget/gh_sync_ticker.dart';

void main() {
  testWidgets('GHSyncTicker should sync ticker status',
      (WidgetTester tester) async {
    bool? tickerEnabled;

    await tester.pumpWidget(
      TickerMode(
        enabled: true,
        child: GHSyncTicker(
          onTickerSync: (enabled, ctx) {
            tickerEnabled = enabled;
          },
        ),
      ),
    );

    expect(tickerEnabled, isTrue);

    await tester.pumpWidget(
      TickerMode(
        enabled: false,
        child: GHSyncTicker(
          onTickerSync: (enabled, ctx) {
            tickerEnabled = enabled;
          },
        ),
      ),
    );

    expect(tickerEnabled, isFalse);
  });
}
