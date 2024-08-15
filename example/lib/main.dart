import 'package:flutter/material.dart';
import 'package:zerker/zerker.dart';
//import './zerker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zerker Basic Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Zerker Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isZerkerVisible = true;

  void _toggleZerkerVisibility() {
    setState(() {
      _isZerkerVisible = !_isZerkerVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _isZerkerVisible
            ? Zerker(
                app: MyZKApp(),
                clip: true,
                interactive: true,
                width: 350,
                height: 350,
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleZerkerVisibility,
        child: Icon(_isZerkerVisible ? Icons.visibility_off : Icons.visibility),
        tooltip: _isZerkerVisible ? 'Hide Zerker' : 'Show Zerker',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

class MyZKApp extends ZKApp {
  bool _loaded = false;
  bool _jumping = false;
  ZKSprite? boy;
  ZKText? title;
  ZKScrollBg? bg;

  @override
  init() {
    super.init();
    stage.color = Colors.blueGrey;

    Map<String, dynamic> urls = {
      "boy": {"json": "assets/boy.json", "image": "assets/boy.png"},
      "bg": "assets/bg.png",
    };

    // preload all assets
    ZKAssets.preload(
        urls: urls,
        onProgress: (scale) {
          print("Assets loading ${scale * 100}%");
        },
        onLoad: () {
          initScene();
          _loaded = true;
          print("Assets load Complete");
        });
  }

  @override
  mounted() {
    //.... layouted
  }

  initScene() {
    // add title
    title = ZKText()
      ..position.x = appWidth / 2
      ..position.y = 20
      ..text = "Please click anywhere"
      ..setStyle(
          color: Colors.blueGrey,
          backgroundColor: Colors.greenAccent,
          textAlign: TextAlign.center);
    stage.addChild(title!);

    // add boy
    boy = ZKSprite(key: "boy")
      ..setScale(1)
      ..anchor.y = 1
      ..position.x = size.width / 2
      ..position.y = appHeight - 16
      ..animator.make("run", ["Run ({1-15}).png"])
      ..animator.make("jump", ["Jump ({1-15}).png"])
      ..animator.make("dead", ["Dead ({1-15}).png"])
      ..animator.play("run", 25, true);
    stage.addChild(boy!);

    // add bg
    bg = ZKScrollBg(key: "bg", time: 4 * 1000)
      ..setScale(0.5)
      ..position.y = appHeight
      ..anchor.y = 1;
    stage.addChildAt(bg!, 0);

    _addAction();
  }

  _addAction() {
    boy?.onTapDown = (event) {
      bg?.stop();
      _jumping = false;
      boy?.animator.play("dead", 20);
    };

    stage.onTapDown = (event) {
      if (event.target == boy) return;
      if (_jumping) return;

      bg?.play();
      _jumping = true;
      boy?.animator.play("jump", 20);
      ZKTween(boy)
          .to({"y": appHeight - 120}, 500)
          .easing(Ease.circ.easeOut)
          .chain(ZKTween(boy)
              .to({"y": appHeight - 16}, 500)
              .easing(Ease.circ.easeIn)
              .onComplete((obj) {
                boy?.animator.play("run", 25, true);
                _jumping = false;
              }))
          .start();
    };
  }

  @override
  update(int time) {
    if (!_loaded) return;
    super.update(time);
  }
}
