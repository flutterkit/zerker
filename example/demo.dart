import 'dart:math';
import 'package:flutter/material.dart';

import '../lib/zerker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zerker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Zerker Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _width = 350;
  bool _show = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  this.setState(() {
                    _show = !_show;
                  });
                },
                child: const Text('click me reset', style: TextStyle(fontSize: 20)),
              ),
              Text(
                'The Zerker Demo',
              ),
              Container(
                color: Colors.amber[600],
                width: _width,
                height: 350.0,
                child: Zerker(app: MyZKApp()),
              ),
            ],
          ),
        ));
  }
}

class MyZKApp extends ZKApp {
  ZKNode _node;
  ZKRect _rect;
  ZKSprite dino;
  ZKSprite bigboy;
  ZKText _text;
  ZKScene _scene;
  ZKGraphic _graphic;
  ZKContainer _container;
  bool _loaded = false;

  @override
  bool interactive = true;

  @override
  bool clip = true;

  @override
  init() {
    super.init();
    this.ratio = 2;

    Map urls = {
      "dino": {"json": "dino/dino.json", "image": "dino/dino.png"},
      "bigboy": {"image": "bigboy.png", "width": 32.0, "height": 32.0}
    };

    ZKAssets.preload(
        baseUrl: "example/assets/",
        urls: urls,
        onProgress: (scale) {
          print("Assets loading ${scale * 100}%");
        },
        onLoad: () {
          initScene();
          _loaded = true;
          print("Assets load Complete");
        });

    stage.color = Colors.purple;
  }

  initScene() {
    _scene = ZKScene();

    // create zk _node
    _node = ZKNode()
      ..debug = true
      ..position.x = size.width / 2
      ..position.y = size.height / 2
      ..color = Colors.indigo;
    _scene.addChild(_node);

    // create zk _rect
    _rect = ZKRect(30, 30);
    stage.addChild(_rect);

    // create zk _text
    _text = ZKText()
      ..position.x = 300
      ..position.y = 300
      ..text = "hello world"
      ..setStyle(color: Colors.blueGrey, backgroundColor: Colors.red[50]);
    stage.addChild(_text);

    // create zk _graphic
    _graphic = ZKGraphic()
      ..position.x = 10
      ..position.y = 10
      ..drawRect(0.0, 0.0, 100.0, 100.0)
      ..setStyle(color: Colors.cyan)
      ..drawRect(-10.0, -110.0, 20.0, 100.0)
      ..setStyle(color: Colors.red)
      ..drawCircle(-120.0, -10.0, 50.0)
      ..setStyle(color: Colors.green)
      ..drawTriangle(120.0, -10.0, 50.0, 50.0, 150.0, 250.0);
    stage.addChild(_graphic);

    // create zk ZKSprite
    int index = 0;
    bigboy = ZKSprite(key: "bigboy")
      ..scale.x = 6
      ..scale.y = 6
      ..position.x = size.width / 2
      ..position.y = size.height / 2
      ..animator.make("front", ['0-4'])
      ..animator.make("left", ['5-9'])
      ..animator.make("after", ['10-14'])
      ..animator.make("right", ['15-19'])
      ..onTapDown = (event) {
        index++;
        var list = ["front", "left", "after", "right"];
        bigboy.animator.play(list[index % 4], 8, true);
        // hum.animator.stop(list[index % 4]);
      };

    bigboy.animator.play("front", 8, true);
    _scene.addChild(bigboy);

    /////
    dino = ZKSprite(key: "dino")
      ..id = "dino"
      ..debug = true
      ..expansion = 0
      ..anchor.x = 0.1
      ..anchor.y = 0.9
      ..position.x = 50
      ..position.y = 330
      ..setScale(.6)
      ..animator.make("run");

    dino.animator.play("run", 8, true);
    _scene.addChild(dino);

    stage.addChild(_scene);
    _scene.moveIn(time: 1000, y: 300, ease: Ease.back.easeOut);

    this._addAnyDot();
  }

  _addAnyDot() {
    _container = ZKContainer();
    double angle = 0;
    var r = 50;
    var l = 8;
    for (int i = 0; i < l; i++) {
      var dot;
      if (i % 2 == 0)
        dot = ZKRect(10, 10, getRandomColor());
      else
        dot = ZKCircle(5, getRandomColor());

      angle = (i * pi * 2) / l;
      dot.setPosition(r * cos(angle), r * sin(angle));
      _container.addChild(dot);
    }
    _container.setPosition(150, 100);
    stage.addChild(_container);
  }

  @override
  update(int time) {
    if (!_loaded) return;
    super.update(time);

    dino.position.x = cos(dino.expansion += 0.01) * 100 + 150;

    _node.position.x += 0.1;
    _node.position.y += 0.13;
    _node.rotation -= 1;

    _graphic.rotation -= 0.2;
    _text.rotation++;

    _container.rotation--;
  }

  @override
  customDraw(Canvas canvas) {}

  @override
  onTapDown(ZKEvent event) {
    super.onTapDown(event);
    ZKTween(_text.position).to({"x": event.dx, "y": event.dy}, 2000).easing(Ease.elastic.easeOut).start();

    var scale = Random().nextDouble() * 12;
    ZKTween(bigboy)
        .to({"x": event.dx + 100, "y": event.dy + 100, "scaleX": scale, "scaleY": scale}, 1000)
        .easing(Ease.back.easeInOut)
        .start();
  }

  @override
  void dispose() {
    super.dispose();

    ZKBus.off("SHOW");
  }
}
