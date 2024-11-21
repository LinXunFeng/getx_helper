import 'package:flutter/material.dart';

import 'package:example/page/home/header/home_header.dart';
import 'package:example/page/home/logic/home_logic.dart';
import 'package:example/page/home/widget/home_body_view.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with HomeLogicPutMixin<HomePage> {
  @override
  HomeLogic initLogic() => HomeLogic();

  @override
  Widget buildBody(BuildContext context) {
    return GetBuilder<HomeLogic>(
      tag: logicTag,
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            centerTitle: true,
          ),
          body: const HomeBodyView(),
          floatingActionButton: FloatingActionButton(
            onPressed: logic.handleFABClick,
            child: const Icon(Icons.arrow_forward),
          ),
        );
      },
    );
  }
}
