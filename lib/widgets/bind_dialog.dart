import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class BindDialog extends StatefulWidget {
  final String keyLabel;
  final String? currentBind;
  final Function(String) onSave;

  const BindDialog({
    super.key,
    required this.keyLabel,
    this.currentBind,
    required this.onSave,
  });

  @override
  State<BindDialog> createState() => _BindDialogState();
}

class _BindDialogState extends State<BindDialog> {
  final TextEditingController _customCommandController = TextEditingController();
  final TextEditingController _toastController = TextEditingController();
  final List<String> _activeCommands = [];
  bool _isCycle = false;

  // Presets
  final Map<String, Map<String, String>> _presets = {
    'Movement': {
      'Auto Run': 'forward;sprint',
      'Jump Crouch': '+jump;+sprint;+duck',
      'Auto Swim': 'forward;sprint;jump',
      'Crouch Jump': '+jump;+duck',
      'Permanent Crouch': 'duck',
      'Hold Crouch': '+duck',
    },
    'Combat': {
      'Combat Log': 'consoletoggle;combatlog',
      'Auto Attack': 'attack',
      'Suicide': 'kill',
      'Flashlight on Fire': '+lighttoggle;+attack',
      'Auto Attack Crouch': '+attack;+duck',
      'Jump Attack': '+attack;+jump',
      'Zoom Low': '+attack2;+input.sensitivity .45;input.sensitivity 1.0',
    },
    'Utility': {
      'Teleport Home 1': 'chat.say "/home 1"',
      'Teleport Home (Custom)': 'chat.say "/home {name}"',
      'Teleport Accept': 'chat.say "/tpa"',
      'Remove Building': 'chat.say "/remove"',
      'Open Map': 'map.open',
      'Disconnect': 'disconnect',
      'Hover Loot': '+hoverloot;+attack2',
      'Craft Bandage': 'craft.add -2072273936 1',
      'FOV Toggle': 'graphics.fov 90;graphics.fov 70',
      'Volume Low (0.2)': 'audio.game 0.2',
      'Volume High (1.0)': 'audio.game 1',
      'Upgrade Building': 'building.upgrade',
      'Open Backpack': 'backpack.open',
      'Kit': 'chat.say /kit',
      'Trade Accept': 'chat.say "/trade yes"',
      'Fast Heal / Use Slot 2': '+slot2;+attack',
    },
  };

  @override
  void initState() {
    super.initState();
    if (widget.currentBind != null && widget.currentBind!.isNotEmpty) {
      String bind = widget.currentBind!;
      if (bind.startsWith('~')) {
        _isCycle = true;
        bind = bind.substring(1);
      }
      
      _activeCommands.addAll(bind.split(';').where((s) => s.isNotEmpty));
    }
  }

  @override
  void dispose() {
    _customCommandController.dispose();
    _toastController.dispose();
    super.dispose();
  }

  void _addCommand(String cmd) {
    setState(() {
      _activeCommands.add(cmd);
    });
  }

  void _removeCommand(int index) {
    setState(() {
      _activeCommands.removeAt(index);
    });
  }

  void _handlePresetSelect(String key, String value) async {
    if (value.contains('{name}')) {
      final controller = TextEditingController();
      final name = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF2D2D2D),
          title: const Text('Enter Home Name', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'e.g. main, base',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
            ),
            autofocus: true,
            onSubmitted: (val) => Navigator.pop(context, val),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Add', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        ),
      );
      
      if (name != null && name.isNotEmpty) {
        _addCommand(value.replaceAll('{name}', name));
      }
    } else {
      _addCommand(value);
    }
  }

  void _editCommandAt(int index) async {
    final controller = TextEditingController(text: _activeCommands[index]);
    final newCmd = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text('Edit Command', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter command',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
          ),
          autofocus: true,
          onSubmitted: (val) => Navigator.pop(context, val),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save', style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );

    if (newCmd != null && newCmd.isNotEmpty) {
      setState(() {
        _activeCommands[index] = newCmd;
      });
    }
  }

  void _save() {
    String bindString = _activeCommands.join(';');
    if (_isCycle && bindString.isNotEmpty) {
      bindString = '~$bindString';
    }
    widget.onSave(bindString);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: FadeInUp(
        duration: const Duration(milliseconds: 300),
        child: Container(
          width: size.width * 0.9,
          height: size.height * 0.85,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D2D),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primaryColor.withOpacity(0.5), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: primaryColor),
                        ),
                        child: Text(
                          widget.keyLabel,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Configuration',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // COLUMN 1: PRESETS (Source)
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Select Presets',
                              style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _presets.length,
                              itemBuilder: (context, index) {
                                final sectionTitle = _presets.keys.elementAt(index);
                                final items = _presets.values.elementAt(index);
                                
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        sectionTitle,
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.1,
                                        ),
                                      ),
                                    ),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2, // 2 Columns for narrower space
                                        childAspectRatio: 2.2,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8,
                                      ),
                                      itemCount: items.length,
                                      itemBuilder: (context, itemIndex) {
                                        final key = items.keys.elementAt(itemIndex);
                                        final value = items.values.elementAt(itemIndex);
                                        return InkWell(
                                          onTap: () => _handlePresetSelect(key, value),
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF3D3D3D),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.transparent),
                                            ),
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  key,
                                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  value.replaceAll('{name}', '...'),
                                                  style: TextStyle(color: Colors.grey[400], fontSize: 9, overflow: TextOverflow.ellipsis),
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const VerticalDivider(width: 32, color: Colors.white10),

                    // COLUMN 2: ACTIVE CHAIN (Result)
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Active Command Chain',
                              style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E1E1E),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: _activeCommands.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No commands bound.\nSelect a preset or add custom command.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.all(8),
                                      itemCount: _activeCommands.length,
                                      itemBuilder: (context, index) {
                                        return FadeInLeft(
                                          delay: Duration(milliseconds: index * 50),
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 4),
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF333333),
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: Colors.white12),
                                            ),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 8,
                                                  backgroundColor: Colors.white10,
                                                  child: Text('${index + 1}', style: const TextStyle(fontSize: 9, color: Colors.white)),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    _activeCommands[index],
                                                    style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.edit, size: 16, color: Colors.blueAccent),
                                                  tooltip: 'Edit Command',
                                                  constraints: const BoxConstraints(),
                                                  padding: const EdgeInsets.all(4),
                                                  onPressed: () => _editCommandAt(index),
                                                ),
                                                const SizedBox(width: 4),
                                                IconButton(
                                                  icon: const Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                                                  constraints: const BoxConstraints(),
                                                  padding: const EdgeInsets.all(4),
                                                  onPressed: () => _removeCommand(index),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const VerticalDivider(width: 32, color: Colors.white10),

                    // COLUMN 3: TOOLS (Configuration)
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Tools & Settings',
                              style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SwitchListTile(
                            title: const Text('Cycle / Toggle Mode (~)', style: TextStyle(color: Colors.white, fontSize: 14)),
                            subtitle: const Text('Cycles through commands on each press', style: TextStyle(color: Colors.grey, fontSize: 11)),
                            value: _isCycle,
                            onChanged: (val) => setState(() => _isCycle = val),
                            activeColor: primaryColor,
                            contentPadding: EdgeInsets.zero,
                          ),
                          const Divider(color: Colors.white10, height: 24),
                          
                          const Text('Custom Command:', style: TextStyle(color: Colors.white70)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _customCommandController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'e.g. chat.say "Hello"',
                                    hintStyle: TextStyle(color: Colors.grey[600]),
                                    filled: true,
                                    fillColor: const Color(0xFF1E1E1E),
                                    isDense: true,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                  onSubmitted: (val) {
                                    if (val.isNotEmpty) {
                                      _addCommand(val);
                                      _customCommandController.clear();
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  if (_customCommandController.text.isNotEmpty) {
                                    _addCommand(_customCommandController.text);
                                    _customCommandController.clear();
                                  }
                                },
                                style: IconButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.add, size: 20),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text('Add On-Screen Message:', style: TextStyle(color: Colors.white70)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _toastController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'e.g. Teleporting...',
                                    hintStyle: TextStyle(color: Colors.grey[600]),
                                    filled: true,
                                    fillColor: const Color(0xFF1E1E1E),
                                    isDense: true,
                                    prefixIcon: const Icon(Icons.message, color: Colors.grey, size: 18),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                  onSubmitted: (val) {
                                    if (val.isNotEmpty) {
                                      _addCommand('gametip.showtoast 2 "$val"');
                                      _toastController.clear();
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  if (_toastController.text.isNotEmpty) {
                                    _addCommand('gametip.showtoast 2 "${_toastController.text}"');
                                    _toastController.clear();
                                  }
                                },
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.add_comment, size: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _save,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Bind'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
