import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'widgets/key_button.dart';
import 'widgets/mouse_widget.dart';
import 'widgets/bind_dialog.dart';
import 'services/config_service.dart';

class KeyboardScreen extends StatefulWidget {
  const KeyboardScreen({super.key});

  @override
  State<KeyboardScreen> createState() => _KeyboardScreenState();
}

class _KeyboardScreenState extends State<KeyboardScreen> {
  final ConfigService _configService = ConfigService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tryAutoLoad();
  }

  Future<void> _tryAutoLoad() async {
    setState(() => _isLoading = true);
    final found = await _configService.findConfig();
    if (found) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Config loaded from ${_configService.configPath}', style: const TextStyle(color: Colors.white)),
            backgroundColor: const Color(0xFF2D2D2D),
          ),
        );
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _openConfig() async {
    final controller = TextEditingController();
    final path = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text('Enter Path to keys.cfg', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter the full absolute path to your keys.cfg file.\nExample: C:\\Program Files (x86)\\Steam\\steamapps\\common\\Rust\\cfg\\keys.cfg',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'C:\\...',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Load', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (path != null && path.isNotEmpty) {
      setState(() => _isLoading = true);
      final success = await _configService.setConfigPath(path);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Config loaded from ${_configService.configPath}', style: const TextStyle(color: Colors.white)),
            backgroundColor: const Color(0xFF2D2D2D),
          ),
        );
      } else if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load config from $path', style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.red[900],
          ),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveConfig() async {
    if (_configService.configPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No config file loaded. Please open one first.', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red[900],
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    await _configService.saveConfig();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Config saved successfully!', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green[900],
        ),
      );
    }
    setState(() => _isLoading = false);
  }

  void _handleKeyTap(String keyLabel) {
    String rustKey = keyLabel.toLowerCase();
    
    final specialKeys = {
      'Esc': 'escape',
      'Ctrl': 'leftcontrol',
      'Alt': 'leftalt',
      'Shift': 'leftshift',
      'Space': 'space',
      'Enter': 'return',
      'Backspace': 'backspace',
      'Tab': 'tab',
      'Caps': 'capslock',
      'Win': 'leftcommand',
      'Ins': 'insert',
      'Del': 'delete',
      'Home': 'home',
      'End': 'end',
      'PgUp': 'pageup',
      'PgDn': 'pagedown',
      'Up': 'up',
      'Down': 'down',
      'Left': 'left',
      'Right': 'right',
      'Num': 'numlock',
      'PrtSc': 'print',
      'ScrlLk': 'scrolllock',
      'Pause': 'pause',
    };
    
    if (specialKeys.containsKey(keyLabel)) {
      rustKey = specialKeys[keyLabel]!;
    }

    final currentBind = _configService.getBind(rustKey);

    showDialog(
      context: context,
      builder: (context) => BindDialog(
        keyLabel: keyLabel,
        currentBind: currentBind,
        onSave: (newBind) {
          setState(() {
            _configService.updateBind(rustKey, newBind);
          });
        },
      ),
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: children,
      ),
    );
  }

  Widget _k(String label, {int flex = 2, Color? color}) {
    String rustKey = label.toLowerCase();
     final specialKeys = {
      'Esc': 'escape',
      'Ctrl': 'leftcontrol', 
      'Alt': 'leftalt',
      'Shift': 'leftshift',
      'Space': 'space',
      'Enter': 'return',
      'Backspace': 'backspace',
      'Tab': 'tab',
      'Caps': 'capslock',
      'Win': 'leftcommand',
      'Ins': 'insert',
      'Del': 'delete',
      'Home': 'home',
      'End': 'end',
      'PgUp': 'pageup',
      'PgDn': 'pagedown',
      'Up': 'up',
      'Down': 'down',
      'Left': 'left',
      'Right': 'right',
      'Num': 'numlock',
      'PrtSc': 'print',
      'ScrlLk': 'scrolllock',
      'Pause': 'pause',
    };
    if (specialKeys.containsKey(label)) {
      rustKey = specialKeys[label]!;
    }
    
    final isBound = _configService.getBind(rustKey) != null;
    final primaryColor = Theme.of(context).primaryColor;

    return KeyButton(
      label: label,
      flex: flex,
      onTap: () => _handleKeyTap(label),
      color: isBound ? primaryColor.withOpacity(0.3) : color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rust Key Binder'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Config',
            onPressed: _isLoading ? null : _saveConfig,
          ),
          IconButton(
            icon: const Icon(Icons.folder_open),
            tooltip: 'Open Config',
            onPressed: _isLoading ? null : _openConfig,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: FadeIn(
            duration: const Duration(milliseconds: 500),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                Flexible(
                  flex: 22,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1400),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Main Keyboard
                        Expanded(
                          flex: 15,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                        _buildRow([
                          _k('Esc'),
                          const Spacer(flex: 1),
                          _k('F1'), _k('F2'), _k('F3'), _k('F4'),
                          const Spacer(flex: 1),
                          _k('F5'), _k('F6'), _k('F7'), _k('F8'),
                          const Spacer(flex: 1),
                          _k('F9'), _k('F10'), _k('F11'), _k('F12'),
                        ]),
                        const SizedBox(height: 10),

                        _buildRow([
                          _k('~'), _k('1'), _k('2'), _k('3'), _k('4'), _k('5'),
                          _k('6'), _k('7'), _k('8'), _k('9'), _k('0'), _k('-'), _k('='),
                          _k('Backspace', flex: 4),
                        ]),

                        _buildRow([
                          _k('Tab', flex: 3),
                          _k('Q'), _k('W'), _k('E'), _k('R'), _k('T'), _k('Y'), _k('U'), _k('I'), _k('O'), _k('P'),
                          _k('['), _k(']'), _k('\\', flex: 3),
                        ]),

                        _buildRow([
                          _k('Caps', flex: 4),
                          _k('A'), _k('S'), _k('D'), _k('F'), _k('G'), _k('H'), _k('J'), _k('K'), _k('L'),
                          _k(';'), _k('\''),
                          _k('Enter', flex: 5),
                        ]),

                        _buildRow([
                          _k('Shift', flex: 5),
                          _k('Z'), _k('X'), _k('C'), _k('V'), _k('B'), _k('N'), _k('M'),
                          _k(','), _k('.'), _k('/'),
                          _k('Shift', flex: 5),
                        ]),

                        _buildRow([
                          _k('Ctrl', flex: 3),
                          _k('Win', flex: 3),
                          _k('Alt', flex: 3),
                          _k('Space', flex: 16),
                          _k('Alt', flex: 3),
                          _k('Win', flex: 3),
                          _k('Menu', flex: 3),
                          _k('Ctrl', flex: 3),
                        ]),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 10),
                  
                  // Navigation
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildRow([
                          _k('PrtSc'), _k('ScrlLk'), _k('Pause'),
                        ]),
                        const SizedBox(height: 10),
                        
                        _buildRow([
                          _k('Ins'), _k('Home'), _k('PgUp'),
                        ]),
                        
                        _buildRow([
                          _k('Del'), _k('End'), _k('PgDn'),
                        ]),
                        
                        const SizedBox(height: 20),
                        
                        _buildRow([
                           const Spacer(flex: 2), _k('Up'), const Spacer(flex: 2),
                        ]),
                        _buildRow([
                          _k('Left'), _k('Down'), _k('Right'),
                        ]),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Numpad
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         const SizedBox(height: 60),
                         
                         _buildRow([
                           _k('Num'), _k('/'), _k('*'), _k('-'),
                         ]),
                         
                         Padding(
                           padding: const EdgeInsets.symmetric(vertical: 2.0),
                           child: Row(
                             children: [
                               Expanded(
                                 child: Column(
                                   children: [
                                     Row(children: [_k('7'), _k('8'), _k('9')]),
                                     const SizedBox(height: 4),
                                     Row(children: [_k('4'), _k('5'), _k('6')]),
                                   ],
                                 ),
                               ),
                               const SizedBox(width: 4),
                               Expanded(
                                 flex: 0,
                                 child: SizedBox(
                                   width: 50,
                                   height: 84,
                                   child: Column(
                                     children: [
                                       KeyButton(
                                         label: '+', 
                                         flex: 1, 
                                         onTap: () => _handleKeyTap('+')
                                       ),
                                     ],
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         ),

                         Padding(
                           padding: const EdgeInsets.symmetric(vertical: 2.0),
                           child: Row(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Expanded(
                                 child: Column(
                                   children: [
                                     Row(children: [_k('1'), _k('2'), _k('3')]),
                                     const SizedBox(height: 4),
                                     Row(children: [_k('0', flex: 4), _k('.')]),
                                   ],
                                 ),
                               ),
                               const SizedBox(width: 4),
                               Expanded(
                                 flex: 0,
                                 child: SizedBox(
                                   width: 50,
                                   height: 84,
                                   child: Column(
                                     children: [
                                       KeyButton(
                                         label: 'Enter', 
                                         flex: 1, 
                                         onTap: () => _handleKeyTap('Enter')
                                       ),
                                     ],
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 20),

          // Mouse
          Flexible(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MouseWidget(
                    onButtonTap: _handleKeyTap,
                    isBound: (key) => _configService.getBind(key) != null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
            ),
          ),
        ),
      ),
    );
  }
}
