import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as p;
import 'package:sandbox/gen/assets.gen.dart';
import 'package:sandbox/generated/painters/professor_painter.dart';
import 'package:vector_graphics_codec/vector_graphics_codec.dart';

Future<void> parseSvg(BuildContext context, String assetName, {bool generateCode = false}) async {
  final assetBundle = SvgAssetLoader(assetName);

  final result = await assetBundle.loadBytes(context);

  // final result = vg.encodeSvg(xml: svgString, debugName: '').buffer.asByteData();

  const codec = VectorGraphicsCodec();

  if (generateCode) {
    final generator = _CustomPainterGenerator();
    codec.decode(result, generator);

    final assetFilename = p.basenameWithoutExtension(assetName);
    final widgetName = _snakeToPascalCase(assetFilename);
    final painterName = '${widgetName}Painter';
    final generatedCode = generator.getFileContent(widgetName, painterName);

    // Преобразуем имя файла в snake_case для соответствия конвенциям Dart.
    final outputFilename = assetFilename.replaceAll('-', '_');

    final outputDir = p.join('lib', 'generated', 'painters');
    await Directory(outputDir).create(recursive: true);

    final outputPath = p.join(outputDir, '${outputFilename}_painter.dart');
    await File(outputPath).writeAsString(generatedCode);
  } else {
    final listener = _DebugVectorGraphicsListener();
    codec.decode(result, listener);
    print(listener.buffer.toString());
  }
}

String _snakeToPascalCase(String snakeCase) =>
    snakeCase.split(RegExp('[_-]')).where((s) => s.isNotEmpty).map((s) => s[0].toUpperCase() + s.substring(1)).join('');

void main() => runZonedGuarded<void>(
  () => runApp(const MaterialApp(home: App())),
  // ignore: avoid_print
  (error, stackTrace) => print('Top level exception: $error\n$stackTrace'),
);

/// {@template svg2dart}
/// App widget.
/// {@endtemplate}
class App extends StatefulWidget {
  /// {@macro svg2dart}
  const App({
    super.key, // ignore: unused_element
  });

  @override
  State<App> createState() => _AppState();
}

/// State for widget App.
class _AppState extends State<App> {
  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    // Initial state initialization
    convert();
  }

  Future<void> convert() async {
    await parseSvg(context, Assets.icons.thumbsUp, generateCode: true);
  }

  @override
  void didUpdateWidget(covariant App oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Widget configuration changed
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The configuration of InheritedWidgets has changed
    // Also called after initState but before build
  }

  @override
  void dispose() {
    // Permanent removal of a tree stent
    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) => const Center(child: Professor());
}

String _intToColor(int value) => 'Color(0x${(value & 0xFFFFFFFF).toRadixString(16).padLeft(8, '0')})';

class _CustomPainterGenerator extends VectorGraphicsCodecListener {
  final StringBuffer _definitions = StringBuffer();
  final StringBuffer _drawCommands = StringBuffer();

  final Map<int, String> _paints = <int, String>{};
  final Map<int, String> _paths = <int, String>{};
  final Map<int, String> _shaders = <int, String>{};

  // Paint по умолчанию, если у пути нет своего стиля.
  static const String _emptyPaint = 'Paint()';

  // Paint для маски, аналогично FlutterVectorGraphicsListener
  static const String _grayscaleDstInPaint =
      'Paint()..blendMode = BlendMode.dstIn..colorFilter = const ColorFilter.matrix(<double>[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.2126,0.7152,0.0722,0,0,])';

  StringBuffer? _currentPathBuffer;
  int _currentPathId = -1;

  Size _size = Size.zero;

  String _colorToCode(int value) => 'const Color(0x${(value & 0xFFFFFFFF).toRadixString(16).padLeft(8, '0')})';

  String getFileContent(String widgetName, String painterName) {
    final buffer = StringBuffer();
    buffer.writeln('''
// ignore_for_file: cascade_invocations

import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';

/// {@template $widgetName}
/// $widgetName widget.
/// {@endtemplate}
class $widgetName extends StatelessWidget {
  /// {@macro $widgetName}
  const $widgetName({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width ?? ${_size.width}, height ?? ${_size.height}),
      painter: $painterName(),
    );
  }
}

class $painterName extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: Implement scaling based on size.
    // The current implementation uses the original SVG size and does not scale.
    // You can use size.width and size.height to calculate a scale factor.
    // final scaleX = size.width / ${_size.width};
    // final scaleY = size.height / ${_size.height};
    // canvas.scale(scaleX, scaleY);
''');
    buffer.writeln(_definitions.toString());
    buffer.writeln();
    buffer.writeln(_drawCommands.toString());
    buffer.writeln('''
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
''');
    return buffer.toString();
  }

  @override
  void onSize(double width, double height) {
    _size = Size(width, height);
  }

  @override
  void onPaintObject({
    required int color,
    required int? strokeCap,
    required int? strokeJoin,
    required int blendMode,
    required double? strokeMiterLimit,
    required double? strokeWidth,
    required int paintStyle,
    required int id,
    required int? shaderId,
  }) {
    final paintVar = 'paint$id${paintStyle == 0 ? 'Fill' : 'Stroke'}';
    _paints[id] = paintVar;
    _definitions.writeln(
      '    final $paintVar = Paint()..isAntiAlias = true..style = PaintingStyle.${paintStyle == 0 ? 'fill' : 'stroke'};',
    );
    if (shaderId != null && _shaders.containsKey(shaderId)) {
      _definitions.writeln('    $paintVar.shader = ${_shaders[shaderId]};');
    } else {
      _definitions.writeln('    $paintVar.color = ${_colorToCode(color)};');
    }
    if (paintStyle == 1) {
      // Stroke
      // SVG's default stroke width is 1.0. Flutter's default is 0.0.
      if (strokeWidth != null && strokeWidth != 0.0) {
        _definitions.writeln('    $paintVar.strokeWidth = $strokeWidth;');
      }
      if (strokeCap != null && strokeCap != 0) {
        _definitions.writeln('    $paintVar.strokeCap = StrokeCap.${StrokeCap.values[strokeCap].name};');
      }
      if (strokeJoin != null && strokeJoin != 0) {
        _definitions.writeln('    $paintVar.strokeJoin = StrokeJoin.${StrokeJoin.values[strokeJoin].name};');
      }
      if (strokeMiterLimit != null && strokeMiterLimit != 4.0) {
        _definitions.writeln('    $paintVar.strokeMiterLimit = $strokeMiterLimit;');
      }
    }
    if (blendMode != 0) {
      _definitions.writeln('    $paintVar.blendMode = BlendMode.${BlendMode.values[blendMode].name};');
    }
    _definitions.writeln();
  }

  @override
  void onPathStart(int id, int fillType) {
    _currentPathId = id;
    final pathVar = 'path_$id';
    _paths[id] = pathVar;
    _currentPathBuffer = StringBuffer('    var $pathVar = Path()');
  }

  @override
  void onPathMoveTo(double x, double y) {
    _currentPathBuffer!.write('..moveTo($x, $y)');
  }

  @override
  void onPathLineTo(double x, double y) {
    _currentPathBuffer!.write('..lineTo($x, $y)');
  }

  @override
  void onPathCubicTo(double x1, double y1, double x2, double y2, double x3, double y3) {
    _currentPathBuffer!.write('..cubicTo($x1, $y1, $x2, $y2, $x3, $y3)');
  }

  @override
  void onPathClose() {
    _currentPathBuffer!.write('..close()');
  }

  @override
  void onPathFinished() {
    _currentPathBuffer!.write(';');
    _definitions.writeln(_currentPathBuffer.toString());
    _currentPathBuffer = null;
    _currentPathId = -1;
  }

  @override
  void onDrawPath(int pathId, int? paintId, int? patternId) {
    final pathVar = _paths[pathId];
    final paintVar = paintId != null ? _paints[paintId] : _emptyPaint;
    if (pathVar != null) {
      _drawCommands.writeln('    canvas.drawPath($pathVar, $paintVar!);');
    }
  }

  @override
  void onLinearGradient(
    double fromX,
    double fromY,
    double toX,
    double toY,
    Int32List colors,
    Float32List? offsets,
    int tileMode,
    int id,
  ) {
    final shaderVar = 'shader$id';
    _shaders[id] = shaderVar;
    final colorsList = colors.map(_colorToCode).join(', ');
    final offsetsList = offsets?.isNotEmpty == true ? '      ${offsets!.join(',\n      ')}' : null;
    _definitions.writeln(
      '    final $shaderVar = ui.Gradient.linear(\n'
      '      const Offset($fromX, $fromY),\n'
      '      const Offset($toX, $toY),\n'
      '      [$colorsList],\n'
      '      ${offsetsList != null ? '[\n$offsetsList\n      ]' : 'null'},\n'
      '      TileMode.${TileMode.values[tileMode].name},\n'
      '    );',
    );
  }

  // Stubs for unused methods
  // Реализуем недостающие методы
  @override
  void onClipPath(int pathId) {
    _drawCommands.writeln('    canvas.save();');
    _drawCommands.writeln('    canvas.clipPath(${_paths[pathId]});');
  }

  @override
  void onDrawImage(int imageId, double x, double y, double width, double height, Float64List? transform) {}
  @override
  void onDrawText(int textId, int? fillId, int? strokeId, int? patternId) {}
  @override
  void onDrawVertices(Float32List vertices, Uint16List? indices, int? paintId) {}
  @override
  void onImage(int imageId, int format, Uint8List data, {VectorGraphicsErrorListener? onError}) {}
  @override
  void onMask() {
    _drawCommands.writeln('    canvas.saveLayer(null, $_grayscaleDstInPaint);');
  }

  @override
  void onPatternStart(int patternId, double x, double y, double width, double height, Float64List transform) {}
  @override
  void onRadialGradient(
    double centerX,
    double centerY,
    double radius,
    double? focalX,
    double? focalY,
    Int32List colors,
    Float32List? offsets,
    Float64List? transform,
    int tileMode,
    int id,
  ) {}
  @override
  void onRestoreLayer() {
    _drawCommands.writeln('    canvas.restore();');
  }

  @override
  void onSaveLayer(int paintId) {
    _drawCommands.writeln('    canvas.saveLayer(null, ${_paints[paintId]});');
  }

  @override
  void onTextConfig(
    String text,
    String? fontFamily,
    double xAnchorMultiplier,
    int fontWeight,
    double fontSize,
    int decoration,
    int decorationStyle,
    int decorationColor,
    int id,
  ) {}
  @override
  void onTextPosition(int id, double? x, double? y, double? dx, double? dy, bool reset, Float64List? transform) {}
  @override
  void onUpdateTextPosition(int id) {}
}

class _DebugVectorGraphicsListener extends VectorGraphicsCodecListener {
  final StringBuffer buffer = StringBuffer();

  @override
  void onClipPath(int pathId) {
    buffer.writeln('DrawClip: id:$pathId');
  }

  @override
  void onDrawImage(int imageId, double x, double y, double width, double height, Float64List? transform) {
    buffer.writeln('DrawImage: id:$imageId (Rect.fromLTWH($x, $y, $width, $height), transform: $transform)');
  }

  @override
  void onDrawPath(int pathId, int? paintId, int? patternId) {
    final patternContext = patternId != null ? ', patternId:$patternId' : '';
    buffer.writeln('DrawPath: id:$pathId (paintId:$paintId$patternContext)');
  }

  @override
  void onDrawText(int textId, int? fillId, int? strokeId, int? patternId) {
    buffer.writeln('DrawText: id:$textId (fill: $fillId, stroke: $strokeId, pattern: $patternId)');
  }

  @override
  void onDrawVertices(Float32List vertices, Uint16List? indices, int? paintId) {
    buffer.writeln('DrawVertices: $vertices ($indices, paintId: $paintId)');
  }

  @override
  void onImage(int imageId, int format, Uint8List data, {VectorGraphicsErrorListener? onError}) {
    buffer.writeln('StoreImage: id:$imageId (format:$format, byteLength:${data.lengthInBytes}');
  }

  @override
  void onLinearGradient(
    double fromX,
    double fromY,
    double toX,
    double toY,
    Int32List colors,
    Float32List? offsets,
    int tileMode,
    int id,
  ) {
    buffer.writeln(
      'StoreGradient: id:$id Linear(\n'
      '  from: ($fromX, $fromY)\n'
      '  to: ($toX, $toY)\n'
      '  colors: [${colors.map(_intToColor).join(',')}]\n'
      '  offsets: $offsets\n'
      '  tileMode: ${TileMode.values[tileMode].name}',
    );
  }

  @override
  void onMask() {
    buffer.writeln('BeginMask:');
  }

  @override
  void onPaintObject({
    required int color,
    required int? strokeCap,
    required int? strokeJoin,
    required int blendMode,
    required double? strokeMiterLimit,
    required double? strokeWidth,
    required int paintStyle,
    required int id,
    required int? shaderId,
  }) {
    // Fill
    if (paintStyle == 0) {
      buffer.writeln(
        'StorePaint: id:$id Fill(${_intToColor(color)}, blendMode: ${BlendMode.values[blendMode].name}, shader: $shaderId)',
      );
    } else {
      buffer.writeln(
        'StorePaint: id:$id Stroke(${_intToColor(color)}, strokeCap: $strokeCap, $strokeJoin: $strokeJoin, '
        'blendMode: ${BlendMode.values[blendMode].name}, strokeMiterLimit: $strokeMiterLimit, strokeWidth: $strokeWidth, shader: $shaderId)',
      );
    }
  }

  @override
  void onPathClose() {
    buffer.writeln('  close()');
  }

  @override
  void onPathCubicTo(double x1, double y1, double x2, double y2, double x3, double y3) {
    buffer.writeln('  cubicTo(($x1, $y1), ($x2, $y2), ($x3, $y3)');
  }

  @override
  void onPathFinished() {
    buffer.writeln('EndPath:');
  }

  @override
  void onPathLineTo(double x, double y) {
    buffer.writeln('  lineTo($x, $y)');
  }

  @override
  void onPathMoveTo(double x, double y) {
    buffer.writeln('  moveTo($x, $y)');
  }

  @override
  void onPathStart(int id, int fillType) {
    buffer.writeln('PathStart: id:$id ${fillType == 0 ? 'nonZero' : 'evenOdd'}');
  }

  @override
  void onPatternStart(int patternId, double x, double y, double width, double height, Float64List transform) {
    buffer.writeln('StorePattern: $patternId (Rect.fromLTWH($x, $y, $width, $height), transform: $transform)');
  }

  @override
  void onRadialGradient(
    double centerX,
    double centerY,
    double radius,
    double? focalX,
    double? focalY,
    Int32List colors,
    Float32List? offsets,
    Float64List? transform,
    int tileMode,
    int id,
  ) {
    final hasFocal = focalX != null;
    buffer.writeln(
      'StoreGradient: id:$id Radial(\n'
      'center: ($centerX, $centerY)\n'
      'radius: $radius\n'
      '${hasFocal ? 'focal: ($focalX, $focalY)\n' : ''}'
      'colors: [${colors.map(_intToColor).join(',')}]\n'
      'offsets: $offsets\n'
      'transform: $transform\n'
      'tileMode: ${TileMode.values[tileMode].name}',
    );
  }

  @override
  void onRestoreLayer() {
    buffer.writeln('Restore:');
  }

  @override
  void onSaveLayer(int paintId) {
    buffer.writeln('SaveLayer: $paintId');
  }

  @override
  void onSize(double width, double height) {
    buffer.writeln('RecordSize: Size($width, $height)');
  }

  @override
  void onTextConfig(
    String text,
    String? fontFamily,
    double xAnchorMultiplier,
    int fontWeight,
    double fontSize,
    int decoration,
    int decorationStyle,
    int decorationColor,
    int id,
  ) {
    buffer.writeln(
      'RecordText: id:$id ($text, ($xAnchorMultiplier x-anchoring), weight: $fontWeight, size: $fontSize, decoration: $decoration, decorationStyle: $decorationStyle, decorationColor: 0x${decorationColor.toRadixString(16)}, family: $fontFamily)',
    );
  }

  @override
  void onTextPosition(int id, double? x, double? y, double? dx, double? dy, bool reset, Float64List? transform) {
    buffer.writeln('StoreTextPosition: id:$id (($x, $y) d($dx, $dy), reset: $reset, transform: $transform)');
  }

  @override
  void onUpdateTextPosition(int id) {
    buffer.writeln('UpdateTextPosition: id:$id');
  }
}
