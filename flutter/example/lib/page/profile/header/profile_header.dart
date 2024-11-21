import 'package:flutter/material.dart';

import 'package:example/page/profile/logic/profile_logic.dart';

import 'package:getx_helper/getx_helper.dart';

typedef ProfileLogicPutMixin<W extends StatefulWidget>
  = GetxLogicPutStateMixin<ProfileLogic, W>;

typedef ProfileLogicConsumerMixin<W extends StatefulWidget>
  = GetxLogicConsumerStateMixin<ProfileLogic, W>;
  