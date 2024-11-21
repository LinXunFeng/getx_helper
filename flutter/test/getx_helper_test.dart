import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:getx_helper/getx_helper.dart';

void main() {
  group(
    'GetxTagProvider',
    () {
      testWidgets('正常使用 - 可以不使用泛型', (tester) async {
        BuildContext? builderContext;
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: GetxTagProvider(
              child: Builder(builder: (context) {
                builderContext = context;
                return Container();
              }),
            ),
          ),
        );

        expect(builderContext, isNotNull);

        final tag1 = GetxTagProvider.standardTag(builderContext!);
        expect(tag1.isNotEmpty, true);

        final tag2 = GetxTagProvider.tag(builderContext!);
        expect(tag2, tag1);
      });

      testWidgets('自定义tag - 使用泛型或ctx', (tester) async {
        BuildContext? builderContext;
        final tag = GetxUtils.uniqueTag();

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: GetxTagProvider<MyGetxLogic>(
              logicTag: tag,
              child: Builder(builder: (context) {
                builderContext = context;
                return Container();
              }),
            ),
          ),
        );

        expect(builderContext, isNotNull);

        final tag1 = GetxTagProvider.standardTag(builderContext!);
        expect(tag1.isNotEmpty, true);

        final tag2 = GetxTagProvider.tag(builderContext!);
        expect(tag2, tag1);
        expect(tag2, tag);
      });

      testWidgets('正常使用 - 页面调用setState后，保持logicTag前后一致', (tester) async {
        BuildContext? builderContext;

        Function(void Function())? _setState;
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: StatefulBuilder(
              builder: (BuildContext context, setState) {
                _setState = setState;
                return GetxTagProvider<MyGetxLogic>(
                  child: Builder(builder: (context) {
                    builderContext = context;
                    return Container();
                  }),
                );
              },
            ),
          ),
        );

        expect(builderContext, isNotNull);

        final tag1 = GetxTagProvider.standardTag(builderContext!);
        expect(tag1.isNotEmpty, true);

        _setState?.call(() {});

        await tester.pumpAndSettle();

        final tag2 = GetxTagProvider.standardTag(builderContext!);
        expect(tag2.isNotEmpty, true);

        expect(tag1, tag2);
      });

      testWidgets('unsafeTag - 在 initState 中使用', (tester) async {
        String tag = '';
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: GetxTagProvider<MyGetxLogic>(
              child: MyStatefulWidget(onInitState: (context) {
                tag = GetxTagProvider.tag(context);
                return Container();
              }),
            ),
          ),
        );

        expect(tag.isNotEmpty, true);
      });

      testWidgets('unsafeTag - 在 onBuild 中使用', (tester) async {
        String tag = '';
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: GetxTagProvider<MyGetxLogic>(
              child: MyStatefulWidget(onBuild: (context) {
                tag = GetxTagProvider.tag(context);
                return Container();
              }),
            ),
          ),
        );

        expect(tag.isNotEmpty, true);
      });
    },
  );

  group(
    'GetxLogic',
    () {
      testWidgets('GetxLogicProvider 与 GetxLogic', (tester) async {
        BuildContext? builderContext;
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: GetxLogicProvider(
              initLogic: (_) => MyGetxLogic(),
              child: MyStatefulWidget(onBuild: (context) {
                builderContext = context;
                return Container();
              }),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(builderContext, isNotNull);

        final standardOfLogic =
            GetxLogic.standardOf<MyGetxLogic>(builderContext!);
        final ofLogic = GetxLogic.of<MyGetxLogic>(builderContext!);
        expect(ofLogic, standardOfLogic);
      });

      testWidgets('自己去put logic，并结合GetxTagProvider取logic', (tester) async {
        BuildContext? builderContext;
        GetxController? createLogic;
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: GetxTagProvider<MyGetxLogic>(
              child: MyStatefulWidget(onBuild: (context) {
                final tag = GetxTagProvider.standardTag(context);
                createLogic = Get.put<MyGetxLogic>(
                  MyGetxLogic(),
                  tag: tag,
                );
                builderContext = context;
                return Container();
              }),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(builderContext, isNotNull);

        final standardOfLogic =
            GetxLogic.standardOf<MyGetxLogic>(builderContext!);
        expect(standardOfLogic, createLogic);

        final ofLogic = GetxLogic.of<MyGetxLogic>(builderContext!);
        expect(ofLogic, standardOfLogic);
      });

      testWidgets('GetxLogicProvider层级变化', (tester) async {
        BuildContext? builderContext1;
        BuildContext? builderContext2;

        Function(void Function())? _setState;
        bool isA = false;
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: StatefulBuilder(
              builder: (BuildContext context, setState) {
                _setState = setState;
                Widget resultWidget = GetxLogicProvider(
                  initLogic: (tag) {
                    return MyGetxLogic();
                  },
                  child: Builder(builder: (context) {
                    if (isA) {
                      builderContext2 = context;
                    } else {
                      builderContext1 = context;
                    }
                    return Container();
                  }),
                );
                if (isA) {
                  resultWidget = Container(child: resultWidget);
                }
                return resultWidget;
              },
            ),
          ),
        );

        expect(builderContext1, isNotNull);
        final ofLogic1 = GetxLogic.standardOf<MyGetxLogic>(builderContext1!);
        final unsafeLogic1 = GetxLogic.of<MyGetxLogic>(builderContext1!);
        expect(ofLogic1, unsafeLogic1);

        _setState?.call(() {
          isA = !isA;
        });
        await tester.pumpAndSettle();

        expect(builderContext2, isNotNull);
        final ofLogic2 = GetxLogic.standardOf<MyGetxLogic>(builderContext2!);
        final unsafeLogic2 = GetxLogic.of<MyGetxLogic>(builderContext2!);
        expect(ofLogic2, unsafeLogic2);
        expect(ofLogic1 != ofLogic2, true);
        expect(unsafeLogic1 != unsafeLogic2, true);
      });

      testWidgets('通过 State 和 BuildContext 获取 Logic', (tester) async {
        BuildContext? builderContext;
        MyGetxLogic? ofLogicByState;
        MyGetxLogic? ofLogicByContext;
        MyGetxLogic? standardLogicByState;
        MyGetxLogic? standardLogicByContext;

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: GetxLogicProvider(
              initLogic: (_) => MyGetxLogic(),
              child: MyStatefulWidget<MyGetxLogic>(
                onBuild: (context) {
                  builderContext = context;
                  return Container();
                },
                ofLogicByState: <MyGetxLogic>(logic) {
                  ofLogicByState = logic;
                },
                ofLogicByContext: <MyGetxLogic>(logic) {
                  ofLogicByContext = logic;
                },
                standardLogicByState: <MyGetxLogic>(logic) {
                  standardLogicByState = logic;
                },
                standardLogicByContext: <MyGetxLogic>(logic) {
                  standardLogicByContext = logic;
                },
              ),
            ),
          ),
        );
        expect(builderContext, isNotNull);
        expect(ofLogicByState, isNotNull);
        expect(ofLogicByContext, isNotNull);
        expect(standardLogicByContext, isNotNull);
        expect(standardLogicByContext, isNotNull);

        final standardOfLogic =
            GetxLogic.standardOf<MyGetxLogic>(builderContext!);
        final ofLogic = GetxLogic.of<MyGetxLogic>(builderContext!);
        expect(ofLogic, standardOfLogic);
        expect(ofLogic, ofLogicByState);
        expect(ofLogic, ofLogicByContext);
        expect(standardOfLogic, standardLogicByState);
        expect(standardOfLogic, standardLogicByContext);
      });

      testWidgets('GetxLogicProvider 与 GetxLogicConsumer', (tester) async {
        BuildContext? builderContext;

        final myLogic = MyGetxLogic();
        MyGetxLogic? logicOnProviderDispose;
        MyGetxLogic? logicOnConsumerDispose;
        MyGetxLogic? logicOnConsumerInitState;
        String? logicTagOnProviderDispose;
        String? logicTagOnConsumerDispose;
        String? logicTagOnConsumerInitState;

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: GetxLogicProvider<MyGetxLogic>(
              initLogic: (_) => myLogic,
              onDispose: (context, logic, logicTag) {
                logicOnProviderDispose = logic;
                logicTagOnProviderDispose = logicTag;
              },
              child: GetxLogicConsumer.get(
                MyGetxLogic.new,
                builder: (context, logic, logicTag) {
                  builderContext = context;
                  return Container();
                },
                onInitState: (context, logic, logicTag) {
                  logicOnConsumerInitState = logic;
                  logicTagOnConsumerInitState = logicTag;
                },
                onDispose: (context, logic, logicTag) {
                  logicOnConsumerDispose = logic;
                  logicTagOnConsumerDispose = logicTag;
                },
              ),
            ),
          ),
        );
        expect(builderContext, isNotNull);
        final ofLogic = GetxLogic.of<MyGetxLogic>(builderContext!);
        final tag = builderContext!.getxTag();
        expect(tag, isNotEmpty);

        expect(logicOnConsumerInitState, isNotNull);
        expect(logicOnProviderDispose, isNull);
        expect(logicOnConsumerDispose, isNull);
        expect(logicTagOnConsumerInitState, isNotNull);
        expect(logicTagOnProviderDispose, isNull);
        expect(logicTagOnConsumerDispose, isNull);

        expect(myLogic, ofLogic);
        expect(myLogic, logicOnConsumerInitState);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Container(),
          ),
        );
        expect(logicOnProviderDispose, isNotNull);
        expect(logicOnConsumerDispose, isNotNull);
        expect(logicTagOnProviderDispose, isNotNull);
        expect(logicTagOnConsumerDispose, isNotNull);

        expect(myLogic, ofLogic);
        expect(myLogic, logicOnProviderDispose);
        expect(myLogic, logicOnConsumerDispose);
        expect(tag, logicTagOnProviderDispose);
        expect(tag, logicTagOnConsumerDispose);
      });

      testWidgets('GetxLogicProvider.put 与 GetxLogicConsumer.get', (tester) async {
        BuildContext? builderContext;

        MyGetxLogic? logicOnProviderDispose;
        MyGetxLogic? logicOnConsumerDispose;
        MyGetxLogic? logicOnConsumerInitState;
        String? logicTagOnProviderDispose;
        String? logicTagOnConsumerDispose;
        String? logicTagOnConsumerInitState;

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: GetxLogicProvider.put(
              MyGetxLogic.new,
              onDispose: (context, logic, logicTag) {
                logicOnProviderDispose = logic;
                logicTagOnProviderDispose = logicTag;
              },
              child: GetxLogicConsumer.get(
                MyGetxLogic.new,
                onInitState: (context, logic, logicTag) {
                  logicOnConsumerInitState = logic;
                  logicTagOnConsumerInitState = logicTag;
                },
                onDispose: (context, logic, logicTag) {
                  logicOnConsumerDispose = logic;
                  logicTagOnConsumerDispose = logicTag;
                },
                builder: (context, logic, logicTag) {
                  builderContext = context;
                  return Container();
                },
              ),
            ),
          ),
        );
        expect(builderContext, isNotNull);
        final ofLogic = GetxLogic.of<MyGetxLogic>(builderContext!);
        final tag = builderContext!.getxTag();
        expect(tag, isNotEmpty);

        expect(logicOnConsumerInitState, isNotNull);
        expect(logicOnProviderDispose, isNull);
        expect(logicOnConsumerDispose, isNull);
        expect(logicTagOnConsumerInitState, isNotNull);
        expect(logicTagOnProviderDispose, isNull);
        expect(logicTagOnConsumerDispose, isNull);
        expect(ofLogic, logicOnConsumerInitState);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Container(),
          ),
        );
        expect(logicOnProviderDispose, isNotNull);
        expect(logicOnConsumerDispose, isNotNull);
        expect(logicTagOnProviderDispose, isNotNull);
        expect(logicTagOnConsumerDispose, isNotNull);

        expect(ofLogic, logicOnProviderDispose);
        expect(ofLogic, logicOnConsumerDispose);
        expect(tag, logicTagOnProviderDispose);
        expect(tag, logicTagOnConsumerDispose);
      });
    },
  );

  group(
    'MyLogicPutMixinWidget',
    () {
      testWidgets('正常使用', (tester) async {
        BuildContext? builderContext;

        MyGetxLogic? logicOnProviderDispose;
        MyGetxLogic? logicOnConsumerDispose;
        MyGetxLogic? logicOnProviderInitState;
        MyGetxLogic? logicOnConsumerInitState;
        String? logicTagOnProviderDispose;
        String? logicTagOnConsumerDispose;
        String? logicTagOnProviderInitState;
        String? logicTagOnConsumerInitState;
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MyLogicPutMixinWidget(
              builder: (context, logic, logicTag) {
                return MyLogicConsumerMixinWidget(
                  onInitState: (context, logic, logicTag) {
                    logicOnConsumerInitState = logic;
                    logicTagOnConsumerInitState = logicTag;
                  },
                  onDispose: (context, logic, logicTag) {
                    logicOnConsumerDispose = logic;
                    logicTagOnConsumerDispose = logicTag;
                  },
                  builder: (context, logic, logicTag) {
                    builderContext = context;
                    return Container();
                  },
                );
              },
              onInitState: (context, logic, logicTag) {
                logicOnProviderInitState = logic;
                logicTagOnProviderInitState = logicTag;
              },
              onDispose: (context, logic, logicTag) {
                logicOnProviderDispose = logic;
                logicTagOnProviderDispose = logicTag;
              },
            ),
          ),
        );
        expect(builderContext, isNotNull);
        final ofLogic = GetxLogic.of<MyGetxLogic>(builderContext!);
        final tag = builderContext!.getxTag();
        expect(tag, isNotEmpty);

        expect(logicOnProviderInitState, isNotNull);
        expect(logicOnConsumerInitState, isNotNull);
        expect(logicOnProviderDispose, isNull);
        expect(logicOnConsumerDispose, isNull);

        expect(ofLogic, logicOnProviderInitState);
        expect(ofLogic, logicOnConsumerInitState);

        expect(logicTagOnProviderInitState, isNotNull);
        expect(logicTagOnConsumerInitState, isNotNull);
        expect(logicTagOnProviderDispose, isNull);
        expect(logicTagOnConsumerDispose, isNull);

        expect(tag, logicTagOnProviderInitState);
        expect(tag, logicTagOnConsumerInitState);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Container(),
          ),
        );

        expect(logicOnProviderDispose, isNotNull);
        expect(logicOnConsumerDispose, isNotNull);
        expect(logicTagOnProviderDispose, isNotNull);
        expect(logicTagOnConsumerDispose, isNotNull);

        expect(ofLogic, logicOnProviderDispose);
        expect(ofLogic, logicOnConsumerDispose);
        expect(tag, logicTagOnProviderDispose);
        expect(tag, logicTagOnConsumerDispose);
      });
      testWidgets('customLogicTag', (tester) async {
        BuildContext? builderContext;

        String customLogicTag = 'customLogicTag';
        MyGetxLogic? logicOnProviderDispose;
        MyGetxLogic? logicOnConsumerDispose;
        MyGetxLogic? logicOnProviderInitState;
        MyGetxLogic? logicOnConsumerInitState;
        String? logicTagOnProviderDispose;
        String? logicTagOnConsumerDispose;
        String? logicTagOnProviderInitState;
        String? logicTagOnConsumerInitState;
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MyLogicPutMixinWidget(
              customLogicTag: () => customLogicTag,
              builder: (context, logic, logicTag) {
                return MyLogicConsumerMixinWidget(
                  onInitState: (context, logic, logicTag) {
                    logicOnConsumerInitState = logic;
                    logicTagOnConsumerInitState = logicTag;
                  },
                  onDispose: (context, logic, logicTag) {
                    logicOnConsumerDispose = logic;
                    logicTagOnConsumerDispose = logicTag;
                  },
                  builder: (context, logic, logicTag) {
                    builderContext = context;
                    return Container();
                  },
                );
              },
              onInitState: (context, logic, logicTag) {
                logicOnProviderInitState = logic;
                logicTagOnProviderInitState = logicTag;
              },
              onDispose: (context, logic, logicTag) {
                logicOnProviderDispose = logic;
                logicTagOnProviderDispose = logicTag;
              },
            ),
          ),
        );
        expect(builderContext, isNotNull);
        final ofLogic = GetxLogic.of<MyGetxLogic>(builderContext!);
        final tag = builderContext!.getxTag();
        expect(tag, isNotEmpty);

        expect(logicOnProviderInitState, isNotNull);
        expect(logicOnConsumerInitState, isNotNull);
        expect(logicOnProviderDispose, isNull);
        expect(logicOnConsumerDispose, isNull);

        expect(ofLogic, logicOnProviderInitState);
        expect(ofLogic, logicOnConsumerInitState);

        expect(logicTagOnProviderInitState, isNotNull);
        expect(logicTagOnConsumerInitState, isNotNull);
        expect(logicTagOnProviderDispose, isNull);
        expect(logicTagOnConsumerDispose, isNull);

        expect(tag, logicTagOnProviderInitState);
        expect(tag, logicTagOnConsumerInitState);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Container(),
          ),
        );

        expect(logicOnProviderDispose, isNotNull);
        expect(logicOnConsumerDispose, isNotNull);
        expect(logicTagOnProviderDispose, isNotNull);
        expect(logicTagOnConsumerDispose, isNotNull);

        expect(ofLogic, logicOnProviderDispose);
        expect(ofLogic, logicOnConsumerDispose);
        expect(tag, logicTagOnProviderDispose);
        expect(tag, logicTagOnConsumerDispose);
        expect(tag, customLogicTag);
      });
      testWidgets('在 initState 中使用 onInit 里初始化的数据', (tester) async {
        bool haveInit = false;
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: MyLogicPutMixinWidget(
              builder: (context, logic, logicTag) {
                return MyLogicConsumerMixinWidget(
                  builder: (context, logic, logicTag) {
                    return Container();
                  },
                );
              },
              onInitState: (context, logic, logicTag) {
                haveInit = logic.haveInit;
              },
            ),
          ),
        );

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Container(),
          ),
        );

        expect(haveInit, true);
      });
    },
  );
  group(
    'GetxLogicConsumerStateMixin',
    () {
      testWidgets('正常使用', (tester) async {
        BuildContext? builderContext;

        MyGetxLogic? logicOnProviderDispose;
        MyGetxLogic? logicOnConsumerDispose;
        MyGetxLogic? logicOnConsumerInitState;
        String? logicTagOnProviderDispose;
        String? logicTagOnConsumerDispose;
        String? logicTagOnConsumerInitState;

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: GetxLogicProvider.put(
              MyGetxLogic.new,
              onDispose: (context, logic, logicTag) {
                logicOnProviderDispose = logic;
                logicTagOnProviderDispose = logicTag;
              },
              child: MyLogicConsumerMixinWidget(
                onInitState: (context, logic, logicTag) {
                  logicOnConsumerInitState = logic;
                  logicTagOnConsumerInitState = logicTag;
                },
                onDispose: (context, logic, logicTag) {
                  logicOnConsumerDispose = logic;
                  logicTagOnConsumerDispose = logicTag;
                },
                builder: (context, logic, logicTag) {
                  builderContext = context;
                  return Container();
                },
              ),
            ),
          ),
        );
        expect(builderContext, isNotNull);
        final ofLogic = GetxLogic.of<MyGetxLogic>(builderContext!);
        final tag = builderContext!.getxTag();
        expect(tag, isNotEmpty);

        expect(logicOnConsumerInitState, isNotNull);
        expect(logicOnProviderDispose, isNull);
        expect(logicOnConsumerDispose, isNull);
        expect(logicTagOnConsumerInitState, isNotNull);
        expect(logicTagOnProviderDispose, isNull);
        expect(logicTagOnConsumerDispose, isNull);
        expect(ofLogic, logicOnConsumerInitState);

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Container(),
          ),
        );
        expect(logicOnProviderDispose, isNotNull);
        expect(logicOnConsumerDispose, isNotNull);
        expect(logicTagOnProviderDispose, isNotNull);
        expect(logicTagOnConsumerDispose, isNotNull);

        expect(ofLogic, logicOnProviderDispose);
        expect(ofLogic, logicOnConsumerDispose);
        expect(tag, logicTagOnProviderDispose);
        expect(tag, logicTagOnConsumerDispose);
      });
    },
  );
}

class MyStatefulWidget<T extends GetxController> extends StatefulWidget {
  const MyStatefulWidget({
    super.key,
    this.onInitState,
    this.onBuild,
    this.ofLogicByState,
    this.ofLogicByContext,
    this.standardLogicByState,
    this.standardLogicByContext,
  });

  final Function(BuildContext context)? onInitState;

  final Function(BuildContext context)? onBuild;

  final Function(T logic)? ofLogicByState;

  final Function(T logic)? ofLogicByContext;

  final Function(T logic)? standardLogicByState;

  final Function(T logic)? standardLogicByContext;

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState<T>();
}

class _MyStatefulWidgetState<T extends GetxController>
    extends State<MyStatefulWidget> {
  @override
  void initState() {
    super.initState();
    widget.onInitState?.call(context);
  }

  @override
  Widget build(BuildContext context) {
    widget.onBuild?.call(context);

    if (widget.ofLogicByState != null) {
      final _logic = getxLogic<T>();
      widget.ofLogicByState!(_logic);
    }

    if (widget.ofLogicByContext != null) {
      final _logic = context.getxLogic<T>();
      widget.ofLogicByContext!(_logic);
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.standardLogicByState != null) {
        final _logic = getxStandardLogic<T>();
        widget.standardLogicByState!(_logic);
      }

      if (widget.standardLogicByContext != null) {
        final _logic = context.getxStandardLogic<T>();
        widget.standardLogicByContext!(_logic);
      }
    });

    return const Placeholder();
  }
}

class MyGetxLogic extends GetxController {
  bool haveInit = false;

  @override
  void onInit() {
    super.onInit();

    haveInit = true;
  }
}

class MyGetxLogic2 extends GetxController {}

class MyLogicPutMixinWidget extends StatefulWidget {
  const MyLogicPutMixinWidget({
    super.key,
    required this.builder,
    this.onInitState,
    this.onDispose,
    this.customLogicTag,
  });

  final Widget Function(
    BuildContext context,
    MyGetxLogic logic,
    String logicTag,
  ) builder;

  final Function(
    BuildContext context,
    MyGetxLogic logic,
    String logicTag,
  )? onInitState;

  final Function(
    BuildContext context,
    MyGetxLogic logic,
    String logicTag,
  )? onDispose;

  final String? Function()? customLogicTag;

  @override
  State<MyLogicPutMixinWidget> createState() => _MyLogicPutMixinWidgetState();
}

typedef MyGetxLogicPutMixin<W extends StatefulWidget>
    = GetxLogicPutStateMixin<MyGetxLogic, W>;

class _MyLogicPutMixinWidgetState extends State<MyLogicPutMixinWidget>
    with MyGetxLogicPutMixin<MyLogicPutMixinWidget> {
  @override
  MyGetxLogic initLogic() {
    return MyGetxLogic();
  }

  @override
  String? customLogicTag() {
    return widget.customLogicTag?.call();
  }

  @override
  Widget buildBody(BuildContext context) {
    return widget.builder.call(context, logic, logicTag);
  }

  @override
  void initState() {
    super.initState();
    widget.onInitState?.call(context, logic, logicTag);
  }

  @override
  void dispose() {
    widget.onDispose?.call(context, logic, logicTag);
    super.dispose();
  }
}

class MyLogicConsumerMixinWidget extends StatefulWidget {
  const MyLogicConsumerMixinWidget({
    super.key,
    this.builder,
    this.onInitState,
    this.onDispose,
  });

  final Widget Function(
    BuildContext context,
    MyGetxLogic logic,
    String logicTag,
  )? builder;

  final Function(
    BuildContext context,
    MyGetxLogic logic,
    String logicTag,
  )? onInitState;

  final Function(
    BuildContext context,
    MyGetxLogic logic,
    String logicTag,
  )? onDispose;

  @override
  State<MyLogicConsumerMixinWidget> createState() =>
      _MyLogicConsumerMixinWidgetState();
}

typedef MyGetxLogicConsumerMixin<W extends StatefulWidget>
    = GetxLogicConsumerStateMixin<MyGetxLogic, W>;

class _MyLogicConsumerMixinWidgetState extends State<MyLogicConsumerMixinWidget>
    with MyGetxLogicConsumerMixin<MyLogicConsumerMixinWidget> {
  @override
  void initState() {
    super.initState();
    widget.onInitState?.call(context, logic, logicTag);
  }

  @override
  void dispose() {
    widget.onDispose?.call(context, logic, logicTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.builder?.call(context, logic, logicTag);
    return const Placeholder();
  }
}