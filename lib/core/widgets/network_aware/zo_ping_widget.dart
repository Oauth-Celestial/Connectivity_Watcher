import 'package:connectivity_watcher/core/service/zo_ping_service.dart';
import 'package:flutter/material.dart';

/// A customizable widget that displays the real-time ping latency in milliseconds,
/// similar to AAA gaming titles like PUBG.
class ZoPingWidget extends StatelessWidget {
  /// Custom text style for the ping text.
  final TextStyle? textStyle;

  /// Icon to display alongside the ping text.
  final IconData? icon;

  /// Custom builder if you want full control over the UI rendering.
  /// If provided, [textStyle] and [icon] are ignored.
  final Widget Function(BuildContext context, int ping, Color color)? builder;

  /// Threshold for green color (default: 100)
  final int goodPingThreshold;

  /// Threshold for orange/yellow color (default: 200). 
  /// Anything above this will be red.
  final int mediumPingThreshold;

  const ZoPingWidget({
    Key? key,
    this.textStyle,
    this.icon = Icons.network_ping,
    this.builder,
    this.goodPingThreshold = 100,
    this.mediumPingThreshold = 200,
  }) : super(key: key);

  Color _getPingColor(int ping) {
    if (ping == -1) return Colors.red; // Timeout/Error
    if (ping <= goodPingThreshold) return Colors.green;
    if (ping <= mediumPingThreshold) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: ZoPingService.instance.pingStream,
      builder: (context, snapshot) {
        // If we don't have data yet, show a loading state
        if (!snapshot.hasData) {
          if (builder != null) {
            return builder!(context, 0, Colors.grey);
          }
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.grey, size: 16),
              const SizedBox(width: 4),
              Text(
                '--- ms',
                style: textStyle?.copyWith(color: Colors.grey) ??
                    const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          );
        }

        final ping = snapshot.data!;
        final color = _getPingColor(ping);
        final pingText = ping == -1 ? 'Err' : '$ping ms';

        if (builder != null) {
          return builder!(context, ping, color);
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              pingText,
              style: textStyle?.copyWith(color: color) ??
                  TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }
}
