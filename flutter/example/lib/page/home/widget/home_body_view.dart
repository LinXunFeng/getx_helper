import 'package:flutter/material.dart';
import 'package:example/page/home/header/home_header.dart';

class HomeBodyView extends StatefulWidget {
  const HomeBodyView({super.key});

  @override
  State<HomeBodyView> createState() => _HomeBodyViewState();
}

class _HomeBodyViewState extends State<HomeBodyView>
    with HomeLogicConsumerMixin<HomeBodyView> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home body'),
    );
  }
}
