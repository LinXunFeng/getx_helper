import 'package:flutter/material.dart';
import 'package:getx_helper/getx_helper.dart';
import 'package:example/common/widget/complex_widget/logic/complex_widget_logic.dart';

typedef ComplexWidgetLogicPutMixin<W extends StatefulWidget>
    = GetxLogicPutStateMixin<ComplexWidgetLogic, W>;

typedef ComplexWidgetLogicConsumerMixin<W extends StatefulWidget>
    = GetxLogicConsumerStateMixin<ComplexWidgetLogic, W>;

enum ComplexWidgetUpdateType {
  number,
}
