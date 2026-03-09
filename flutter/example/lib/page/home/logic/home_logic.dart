import 'package:example/common/route/route.dart';
import 'package:example/page/home/header/home_header.dart';
import 'package:example/page/home/state/home_state.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class HomeLogic extends GetxController {
  final HomeState state = HomeState();

  @override
  void onInit() async {
    super.onInit();

    // 接收路由参数
    final parameter = Get.parameters['parameter'] ?? "";
    debugPrint('home parameter: $parameter');
  }

  void handleFABClick() async {
    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      state.showComplexWidget = true;
      update([HomeUpdateType.body]);
    });

    final result = await Get.toNamed(
      AppRoute.profile,
      parameters: {
        'parameter': 'home push',
      },
    );
    debugPrint('profile pop result: $result');
  }
}
