import 'package:example/common/widget/complex_widget/complex_widget.dart';
import 'package:example/page/home/header/home_header.dart';
import 'package:example/page/home/logic/home_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBodyView extends StatefulWidget {
  const HomeBodyView({super.key});

  @override
  State<HomeBodyView> createState() => _HomeBodyViewState();
}

class _HomeBodyViewState extends State<HomeBodyView>
    with HomeLogicConsumerMixin<HomeBodyView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeLogic>(
      tag: logicTag,
      id: HomeUpdateType.body,
      builder: (_) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    return Center(
      child: logic.state.showComplexWidget
          ? const ComplexWidget()
          : const Text('Home body'),
    );
  }
}
