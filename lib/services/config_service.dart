import 'dart:io';
import 'package:flutter/foundation.dart';

class ConfigService {
  String? _configPath;
  final Map<String, String> _binds = {};
  List<String> _originalLines = [];

  String? get configPath => _configPath;
  Map<String, String> get binds => _binds;

  // Constants
  final List<String> _possiblePaths = [
    r'C:\Program Files (x86)\Steam\steamapps\common\Rust\cfg\keys.cfg',
    r'D:\SteamLibrary\steamapps\common\Rust\cfg\keys.cfg',
    r'E:\SteamLibrary\steamapps\common\Rust\cfg\keys.cfg',
    r'C:\Steam\steamapps\common\Rust\cfg\keys.cfg',
  ];

  Future<bool> findConfig() async {
    for (final path in _possiblePaths) {
      if (await File(path).exists()) {
        _configPath = path;
        await readConfig();
        return true;
      }
    }
    return false;
  }

  Future<bool> setConfigPath(String path) async {
    final file = File(path);
    if (await file.exists()) {
      _configPath = path;
      await readConfig();
      return true;
    }
    return false;
  }

  String? getBind(String key) => _binds[key];

  Future<void> readConfig() async {
    if (_configPath == null) return;
    
    try {
      final file = File(_configPath!);
      _originalLines = await file.readAsLines();
      _binds.clear();
      
      final bindRegex = RegExp(r'^bind\s+([^\s]+)\s+(.+)$');

      for (var line in _originalLines) {
        line = line.trim();
        if (line.isEmpty || line.startsWith('//') || line.startsWith('#')) continue;
        
        final match = bindRegex.firstMatch(line);
        if (match != null) {
          final key = match.group(1)!;
          String command = match.group(2)!;
          
          if (command.startsWith('"') && command.endsWith('"')) {
            command = command.substring(1, command.length - 1);
          }
          
          command = command.replaceAll(r'\"', '"');
          
          _binds[key] = command;
        }
      }
      debugPrint('Loaded ${_binds.length} binds from $_configPath');
    } catch (e) {
      debugPrint('Error reading config: $e');
    }
  }

  Future<void> saveConfig() async {
    if (_configPath == null) return;

    try {
      final file = File(_configPath!);
      final buffer = StringBuffer();
      
      final Set<String> writtenKeys = {};
      
      final bindRegex = RegExp(r'^bind\s+([^\s]+)\s+');
      
      for (var line in _originalLines) {
        final trimLine = line.trim();
        final match = bindRegex.firstMatch(trimLine);
        
        if (match != null && !trimLine.startsWith('//') && !trimLine.startsWith('#')) {
          final key = match.group(1)!;
          
          if (_binds.containsKey(key)) {
             final command = _binds[key]!;
             final escapedCommand = command.replaceAll('"', r'\"');
             buffer.writeln('bind $key "$escapedCommand"');
             writtenKeys.add(key);
          } 
        } else {
          buffer.writeln(line);
        }
      }
      
      _binds.forEach((key, command) {
        if (!writtenKeys.contains(key)) {
           final escapedCommand = command.replaceAll('"', r'\"');
           buffer.writeln('bind $key "$escapedCommand"');
        }
      });

      await file.writeAsString(buffer.toString());
      
      _originalLines = await file.readAsLines();
      
      debugPrint('Saved config to $_configPath');
    } catch (e) {
      debugPrint('Error saving config: $e');
    }
  }

  void updateBind(String key, String command) {
    if (command.isEmpty) {
      _binds.remove(key);
    } else {
      _binds[key] = command;
    }
  }
}
