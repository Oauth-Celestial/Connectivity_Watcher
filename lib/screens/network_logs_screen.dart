import 'package:connectivity_watcher/core/manager/zo_network_log_manager.dart';
import 'package:connectivity_watcher/core/models/network_log_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ZoNetworkLogsScreen extends StatelessWidget {
  const ZoNetworkLogsScreen({Key? key}) : super(key: key);

  Color _getStatusColor(NetworkLogModel log) {
    if (log.status == NetworkLogStatus.pending) return Colors.orange;
    if (log.status == NetworkLogStatus.error) return Colors.red;
    if (log.statusCode != null &&
        log.statusCode! >= 200 &&
        log.statusCode! < 300) {
      return Colors.green;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ZoNetworkLogManager.instance.clearLogs();
            },
          )
        ],
      ),
      body: ValueListenableBuilder<List<NetworkLogModel>>(
        valueListenable: ZoNetworkLogManager.instance.logsNotifier,
        builder: (context, logs, child) {
          if (logs.isEmpty) {
            return const Center(child: Text('No network logs.'));
          }
          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      log.method,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      log.statusCode?.toString() ?? '...',
                      style: TextStyle(
                        color: _getStatusColor(log),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                title: Text(
                  log.url,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
                subtitle: Text(
                  '${log.startTime.hour}:${log.startTime.minute}:${log.startTime.second}  •  ${log.duration?.inMilliseconds ?? '...'} ms${log.connectionMode != null ? '  •  ${log.connectionMode!.label}' : ''}',
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ZoNetworkLogDetailsScreen(log: log),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ZoNetworkLogDetailsScreen extends StatelessWidget {
  final NetworkLogModel log;

  const ZoNetworkLogDetailsScreen({Key? key, required this.log})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Details'),
        actions: [
          if (log.curlCommand != null)
            IconButton(
              icon: const Icon(Icons.copy),
              tooltip: 'Copy cURL',
              onPressed: () {
                String curlCommmand = log.curlCommand!;
                Clipboard.setData(ClipboardData(text: curlCommmand));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('cURL copied to clipboard!')),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('URL', log.url),
            _buildSection('Method', log.method),
            if (log.connectionMode != null)
              _buildSection('Connection Mode', log.connectionMode!.label),
            _buildSection(
                'Status Code', log.statusCode?.toString() ?? 'Pending'),
            _buildSection(
                'Duration', '${log.duration?.inMilliseconds ?? '...'} ms'),
            const Divider(),
            _buildSection('Request Headers', log.requestHeaders.toString()),
            _buildSection(
                'Request Body', log.requestBody?.toString() ?? 'null'),
            const Divider(),
            _buildSection(
                'Response Headers', log.responseHeaders?.toString() ?? 'null'),
            _buildSection(
                'Response Body', log.responseBody?.toString() ?? 'null'),
            if (log.errorMessage != null) ...[
              const Divider(),
              _buildSection('Error Message', log.errorMessage!),
            ],
            const Divider(),
            _buildSection('cURL Command', log.curlCommand ?? 'Not available'),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          SelectableText(
            content,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          ),
        ],
      ),
    );
  }
}
