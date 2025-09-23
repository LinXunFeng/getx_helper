import 'package:example/page/profile/header/profile_header.dart';
import 'package:example/page/profile/state/profile_state.dart';
import 'package:flutter/material.dart';

class ProfileFlutterDashIcon extends StatefulWidget {
  const ProfileFlutterDashIcon({super.key});

  @override
  State<ProfileFlutterDashIcon> createState() => _ProfileFlutterDashIconState();
}

class _ProfileFlutterDashIconState extends State<ProfileFlutterDashIcon>
    with ProfileLogicConsumerMixin<ProfileFlutterDashIcon> {
  ProfileState get state => logic.state;
  @override
  Widget build(BuildContext context) {
    Widget resultWidget = Icon(
      Icons.flutter_dash,
      size: state.isFromProfile ? 150 : 100,
      color: state.isFromProfile ? Colors.blue : Colors.red,
    );
    resultWidget = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: logic.handleFlutterDashIconClick,
      child: resultWidget,
    );

    return resultWidget;
  }
}
