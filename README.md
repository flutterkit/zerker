<div align=center><img src="https://github.com/flutterkit/zerkerdocs/blob/master/logo/logo.png?raw=true"/></div>

## What is Zerker

Zerker is a flexible and lightweight flutter canvas graphic animation library.

With Zerker, you can create a lot of seemingly cumbersome animation effects, such as animated animations, pop-up animations, scene transitions, icon effects, and more.

At the same time, you can create a lot of simple games with Zerker. Zerker contains elements such as sprites, scrolling backgrounds, and atlases, making it easy to create game worlds with them.

![An image](https://flutterkit.github.io/zerkerdocs/images/fp.png)

## Installation


CODE:

```dart
Altas fire = await ZKAssets.loadAltas(
  key: "fire", 
  json: "assets/a.json", 
  image: "assets/fire.png"
);

Altas ball = await ZKAssets.loadImage(
  key: "ball",  
  image: "assets/ball.png"
);

ZKAssets.loadAssets(
  urls: ["a.png", "b.png", ...],
  baseUrl: "assets/",
  onLoad: (){
    ...
  }
);
```

![An image](/images/fp.png)


---

## Install

### Use this package as a library
#### 1. Depend on it
Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  zerker: ^1.0.1
```

#### 2. Install it
You can install packages from the command line:
with Flutter:

```shell
$ flutter pub get
```

Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

#### 3. Import it
Now in your Dart code, you can use:

```dart
import 'package:zerker/zerker.dart';
```
