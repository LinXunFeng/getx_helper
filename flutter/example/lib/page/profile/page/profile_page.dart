import 'package:flutter/material.dart';

import 'package:example/page/profile/header/profile_header.dart';
import 'package:example/page/profile/logic/profile_logic.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with ProfileLogicPutMixin<ProfilePage> {
  @override
  ProfileLogic initLogic() => ProfileLogic();

  @override
  Widget buildBody(BuildContext context) {
    return GetBuilder<ProfileLogic>(
      tag: logicTag,
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: Container(),
          floatingActionButton: FloatingActionButton(
            onPressed: logic.handleFABClick,
            child: const Icon(Icons.arrow_back),
          ),
        );
      },
    );
  }
}
