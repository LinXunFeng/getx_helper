import 'package:example/common/widget/complex_widget/logic/complex_widget_logic.dart';
import 'package:flutter/material.dart';
import 'package:example/common/widget/complex_widget/header/complex_widget_header.dart';
import 'package:get/get.dart';

class ComplexNumberView extends StatefulWidget {
  const ComplexNumberView({super.key});

  @override
  State<ComplexNumberView> createState() => _ComplexNumberViewState();
}

class _ComplexNumberViewState extends State<ComplexNumberView>
    with ComplexWidgetLogicConsumerMixin<ComplexNumberView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ComplexWidgetLogic>(
      tag: logicTag,
      id: ComplexWidgetUpdateType.number,
      builder: (_) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    return Text(
      logic.state.number.toString(),
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    );
  }
}
