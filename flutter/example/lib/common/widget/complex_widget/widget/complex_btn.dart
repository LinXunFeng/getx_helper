import 'package:example/common/widget/complex_widget/logic/complex_widget_logic.dart';
import 'package:flutter/material.dart';
import 'package:example/common/widget/complex_widget/header/complex_widget_header.dart';
import 'package:getx_helper/getx_helper.dart';

class ComplexBtn extends StatefulWidget {
  const ComplexBtn({super.key});

  @override
  State<ComplexBtn> createState() => _ComplexBtnState();
}

class _ComplexBtnState extends State<ComplexBtn>
    with ComplexWidgetLogicConsumerMixin<ComplexBtn> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // logic.handleBtnClick();
        GetxLogic.of<ComplexWidgetLogic>(context).handleBtnClick();
      },
      child: const Text('按钮'),
    );
  }
}
