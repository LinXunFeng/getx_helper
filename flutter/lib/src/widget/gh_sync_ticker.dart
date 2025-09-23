import 'package:flutter/material.dart';

/// 同步 ticker 状态
class GHSyncTicker extends StatelessWidget {
  final void Function(bool tickingEnabled) onTickerSync;

  const GHSyncTicker({
    super.key,
    required this.onTickerSync,
  });

  @override
  Widget build(BuildContext context) {
    final tickingEnabled = TickerMode.of(context);
    onTickerSync(tickingEnabled);
    return const SizedBox.shrink();
  }
}
