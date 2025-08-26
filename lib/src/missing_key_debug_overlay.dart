import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'localization_manager.dart';

/// A debug overlay that displays missing translation keys.
/// 
/// This widget is only shown in debug mode and when enabled via
/// LocalizationManager configuration.
class MissingKeyDebugOverlay extends StatefulWidget {
  final Widget child;
  
  const MissingKeyDebugOverlay({super.key, required this.child});
  
  @override
  State<MissingKeyDebugOverlay> createState() => _MissingKeyDebugOverlayState();
}

class _MissingKeyDebugOverlayState extends State<MissingKeyDebugOverlay> {
  bool _isVisible = false;
  Set<String> _missingKeys = <String>{};
  
  @override
  void initState() {
    super.initState();
    LocalizationManager.instance.addListener(_updateMissingKeys);
    _updateMissingKeys();
  }
  
  @override
  void dispose() {
    LocalizationManager.instance.removeListener(_updateMissingKeys);
    super.dispose();
  }
  
  void _updateMissingKeys() {
    if (mounted) {
      setState(() {
        _missingKeys = LocalizationManager.instance.missingKeys;
        _isVisible = LocalizationManager.instance.showDebugOverlay && 
                    _missingKeys.isNotEmpty;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (!kDebugMode || !_isVisible) {
      return widget.child;
    }
    
    return Stack(
      children: [
        widget.child,
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          right: 10,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            color: Colors.red.shade100,
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 300,
                maxHeight: 200,
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.red.shade700,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Missing Keys (${_missingKeys.length})',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          LocalizationManager.instance.clearMissingKeys();
                        },
                        child: Icon(
                          Icons.clear,
                          color: Colors.red.shade700,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _missingKeys.map((key) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            child: Text(
                              '• $key',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red.shade800,
                                fontFamily: 'monospace',
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}