import 'package:example/common/widget/complex_widget/header/complex_widget_header.dart';
import 'package:example/common/widget/complex_widget/logic/complex_widget_logic.dart';
import 'package:example/common/widget/complex_widget/widget/complex_btn.dart';
import 'package:example/common/widget/complex_widget/widget/complex_number_view.dart';
import 'package:flutter/material.dart';

class ComplexWidget extends StatefulWidget {
  const ComplexWidget({super.key});

  @override
  State<ComplexWidget> createState() => _ComplexWidgetState();
}

class _ComplexWidgetState extends State<ComplexWidget>
    with ComplexWidgetLogicPutMixin<ComplexWidget> {
  @override
  ComplexWidgetLogic initLogic() => ComplexWidgetLogic();

  @override
  bool assignId() => true;

  @override
  Widget buildBody(BuildContext context) {
    Widget resultWidget = const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        ComplexNumberView(),
        ComplexBtn(),
      ],
    );
    resultWidget = Container(
      width: 100,
      height: 100,
      color: Colors.red,
      child: resultWidget,
    );
    return resultWidget;
  }
}
