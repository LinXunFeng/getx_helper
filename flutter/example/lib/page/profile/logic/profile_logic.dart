import 'package:example/common/route/route.dart';
import 'package:flutter/material.dart';

import 'package:example/page/profile/state/profile_state.dart';
import 'package:get/get.dart';

class ProfileLogic extends GetxController {
  final ProfileState state = ProfileState();

  @override
  void onInit() async {
    super.onInit();

    // 接收路由参数
    final parameter = Get.parameters['parameter'] ?? "";
    state.parameter = parameter;
    debugPrint('profile parameter: $parameter');
  }

  void handleFABClick() async {
    Get.back(result: {
      'parameter': 'profile pop',
    });
  }

  void handleFlutterDashIconClick() {
    Get.toNamed(
      AppRoute.profile,
      parameters: {
        'parameter': 'profile push',
      },
    );
  }
}
