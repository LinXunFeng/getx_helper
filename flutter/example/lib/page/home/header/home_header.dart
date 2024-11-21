import 'package:flutter/material.dart';

import 'package:example/page/home/logic/home_logic.dart';

import 'package:getx_helper/getx_helper.dart';

typedef HomeLogicPutMixin<W extends StatefulWidget>
    = GetxLogicPutStateMixin<HomeLogic, W>;

typedef HomeLogicConsumerMixin<W extends StatefulWidget>
    = GetxLogicConsumerStateMixin<HomeLogic, W>;
