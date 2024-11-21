import 'package:flutter/material.dart';

import 'package:example/common/route/route.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Application',
      getPages: AppPage.routes,
      initialRoute: AppRoute.home,
    );
  }
}
