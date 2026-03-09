import 'package:example/common/widget/complex_widget/header/complex_widget_header.dart';
import 'package:example/common/widget/complex_widget/state/complex_widget_state.dart';
import 'package:get/get.dart';

class ComplexWidgetLogic extends GetxController {
  final ComplexWidgetState state = ComplexWidgetState();

  void handleBtnClick() {
    state.number++;
    update([ComplexWidgetUpdateType.number]);
  }
}
