import 'dart:io';

void main() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('lib directory not found!');
    return;
  }

  final stringRegex = RegExp(r'"([^"\n]{1,100})"', multiLine: true);
  final Map<String, String> enStrings = {};
  final List<String> otherLangs = ['fr', 'de', 'es', 'it', 'za'];

  int keyCounter = 1;

  void scanDirectory(Directory dir) {
    for (var entity in dir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        final content = entity.readAsStringSync();
        for (var match in stringRegex.allMatches(content)) {
          final value = match.group(1)!.trim();
          if (value.isEmpty) continue;

          // Skip numbers, URLs, or strings already as keys
          if (RegExp(r'^[0-9\s.,!?%:/\-]+$').hasMatch(value)) continue;
          if (enStrings.containsValue(value)) continue;

          final key = 'key_$keyCounter';
          enStrings[key] = value;
          keyCounter++;
        }
      }
    }
  }

  scanDirectory(libDir);

  // Save en.dart
  final enBuffer = StringBuffer("final Map<String, String> en = {\n");
  enStrings.forEach((k, v) {
    enBuffer.writeln('  "$k": "${v.replaceAll('"', '\\"')}",');
  });
  enBuffer.writeln("};");
  File('lib/core/localization/en.dart').writeAsStringSync(enBuffer.toString());
  print('✅ en.dart generated with ${enStrings.length} strings');

  // Save placeholder files for other languages
  for (var lang in otherLangs) {
    final buffer = StringBuffer('final Map<String, String> $lang = {\n');
    enStrings.forEach((k, v) {
      buffer.writeln('  "$k": "",');
    });
    buffer.writeln('};');
    File('lib/core/localization/$lang.dart').writeAsStringSync(buffer.toString());
    print('✅ $lang.dart generated');
  }
}
