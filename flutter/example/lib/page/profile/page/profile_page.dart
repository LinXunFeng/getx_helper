import 'package:example/page/profile/header/profile_header.dart';
import 'package:example/page/profile/logic/profile_logic.dart';
import 'package:example/page/profile/state/profile_state.dart';
import 'package:example/page/profile/widget/profile_flutter_dash_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_helper/getx_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with ProfileLogicPutMixin<ProfilePage> {
  ProfileState get state => logic.state;

  @override
  ProfileLogic initLogic() => ProfileLogic();

  @override
  Widget buildBody(BuildContext context) {
    return GetBuilder<ProfileLogic>(
      tag: logicTag,
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: _buildBody(),
          floatingActionButton: FloatingActionButton(
            onPressed: logic.handleFABClick,
            child: const Icon(Icons.arrow_back),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    Widget resultWidget = const ProfileFlutterDashIcon();

    resultWidget = GHHero(
      tag: 'flutter_dash',
      logicTag: logicTag,
      child: resultWidget,
    );

    resultWidget = Container(
      margin: EdgeInsets.only(
        left: 50,
        top: state.isFromProfile ? 200 : 100,
      ),
      child: resultWidget,
    );
    return resultWidget;
  }
}
