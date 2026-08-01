import 'package:connectivity_watcher/connectivity_watcher.dart';
import 'package:connectivity_watcher/core/manager/socket_internet_checker.dart';
import 'package:dio/dio.dart';

import 'package:example/no_internet.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  

  ZoConnectivityWatcher().setUp(
  
   checkInterval: Duration(seconds: 1)
      );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ZoConnectivityWrapper(
      /// connectivityStyle: NoConnectivityStyle.CUSTOM,
      navigationKey: navigatorKey,
      connectivityStyle: NoConnectivityStyle.CUSTOM,
      customAlert: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Row(
          children: [
            Icon(
              Icons.wifi_off,
              color: Colors.redAccent,
            ),
            SizedBox(width: 8.0),
            Text(
              'No Internet Connection',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'It looks like you are not connected to the internet. Please check your connection and try again.',
          style: TextStyle(fontSize: 16.0),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('CANCEL', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('RETRY'),
          ),
        ],
      ),

      offlineWidget: CustomNoInternetWrapper(
        builder: (context) {
          return CustomNoInternet();
        },
      ),
      // Place your custom no internet Widget
      builder: (context, connectionKey) {
        return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Connectivity_Watcher',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: ApiTestDashboard());
      },
    );
  }
}

class ApiTestDashboard extends StatefulWidget {
  @override
  _ApiTestDashboardState createState() => _ApiTestDashboardState();
}

class _ApiTestDashboardState extends State<ApiTestDashboard> {
  late final Dio _dio;
  String _lastResult = '';

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    ZoConnectivityWatcher().setupDioLogger(_dio);
  }

  void _showResult(String method, dynamic response) {
    if (mounted) {
      setState(() {
        _lastResult = '$method → ${response.statusCode}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$method completed — ${response.statusCode}'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _showError(String method, dynamic e) {
    if (mounted) {
      setState(() {
        _lastResult = '$method → ERROR';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$method failed'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('API Test Dashboard'),
        backgroundColor: const Color(0xFF1E1E2C),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: ZoPingWidget(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.monitor_heart_outlined),
            tooltip: 'Network Logs',
            onPressed: () {
              ZoConnectivityWatcher().showNetworkLogsScreen(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Connection status
            ZoNetworkAwareWidget(
              builder: (context, status) {
                final isConnected =
                    status == ConnectivityWatcherStatus.connected;
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isConnected
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isConnected
                          ? Colors.green.shade300
                          : Colors.red.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isConnected ? Icons.wifi : Icons.wifi_off,
                        color: isConnected ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isConnected ? 'Connected' : 'Disconnected',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isConnected
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Last result
            if (_lastResult.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Last: $_lastResult',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Section: GET Requests
            _buildSectionHeader('GET Requests', Icons.download),
            const SizedBox(height: 8),
            _buildRequestButton(
              label: 'GET Single Post',
              subtitle: '/posts/1',
              color: Colors.blue,
              icon: Icons.article,
              onTap: () async {
                try {
                  final res = await _dio.get(
                    "https://jsonplaceholder.typicode.com/posts/1",
                  );
                  _showResult('GET', res);
                } catch (e) {
                  _showError('GET', e);
                }
              },
            ),
            const SizedBox(height: 8),
            _buildRequestButton(
              label: 'GET with Query Params',
              subtitle: '/comments?postId=1',
              color: Colors.blue.shade700,
              icon: Icons.filter_list,
              onTap: () async {
                try {
                  final res = await _dio.get(
                    "https://jsonplaceholder.typicode.com/comments",
                    queryParameters: {"postId": 1},
                  );
                  _showResult('GET (query)', res);
                } catch (e) {
                  _showError('GET (query)', e);
                }
              },
            ),
            const SizedBox(height: 8),
            _buildRequestButton(
              label: 'GET All Users',
              subtitle: '/users',
              color: Colors.blue.shade400,
              icon: Icons.people,
              onTap: () async {
                try {
                  final res = await _dio.get(
                    "https://jsonplaceholder.typicode.com/users",
                  );
                  _showResult('GET Users', res);
                } catch (e) {
                  _showError('GET Users', e);
                }
              },
            ),
            const SizedBox(height: 20),

            // Section: POST Requests
            _buildSectionHeader('POST Requests', Icons.upload),
            const SizedBox(height: 8),
            _buildRequestButton(
              label: 'POST JSON Body',
              subtitle: '/posts (create new)',
              color: Colors.green,
              icon: Icons.add_circle,
              onTap: () async {
                try {
                  final res = await _dio.post(
                    "https://jsonplaceholder.typicode.com/posts",
                    data: {
                      "title": "Network Inspector Test",
                      "body": "Testing POST request",
                      "userId": 1,
                    },
                  );
                  _showResult('POST', res);
                } catch (e) {
                  _showError('POST', e);
                }
              },
            ),
            const SizedBox(height: 8),
            _buildRequestButton(
              label: 'POST FormData (Multipart)',
              subtitle: 'httpbin.org/post',
              color: Colors.green.shade700,
              icon: Icons.attach_file,
              onTap: () async {
                try {
                  final formData = FormData.fromMap({
                    "name": "connectivity_watcher",
                    "version": "3.0.6",
                    "description": "Testing FormData upload",
                  });
                  final res = await _dio.post(
                    "https://httpbin.org/post",
                    data: formData,
                  );
                  _showResult('POST FormData', res);
                } catch (e) {
                  _showError('POST FormData', e);
                }
              },
            ),
            const SizedBox(height: 20),

            // Section: PUT / PATCH
            _buildSectionHeader('PUT / PATCH Requests', Icons.edit),
            const SizedBox(height: 8),
            _buildRequestButton(
              label: 'PUT Full Update',
              subtitle: '/posts/1',
              color: Colors.orange,
              icon: Icons.sync,
              onTap: () async {
                try {
                  final res = await _dio.put(
                    "https://jsonplaceholder.typicode.com/posts/1",
                    data: {
                      "id": 1,
                      "title": "Updated Title",
                      "body": "Updated Body",
                      "userId": 1,
                    },
                  );
                  _showResult('PUT', res);
                } catch (e) {
                  _showError('PUT', e);
                }
              },
            ),
            const SizedBox(height: 8),
            _buildRequestButton(
              label: 'PATCH Partial Update',
              subtitle: '/posts/1 (title only)',
              color: Colors.orange.shade700,
              icon: Icons.edit_note,
              onTap: () async {
                try {
                  final res = await _dio.patch(
                    "https://jsonplaceholder.typicode.com/posts/1",
                    data: {"title": "Patched Title"},
                  );
                  _showResult('PATCH', res);
                } catch (e) {
                  _showError('PATCH', e);
                }
              },
            ),
            const SizedBox(height: 20),

            // Section: DELETE
            _buildSectionHeader('DELETE Request', Icons.delete_outline),
            const SizedBox(height: 8),
            _buildRequestButton(
              label: 'DELETE Post',
              subtitle: '/posts/1',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () async {
                try {
                  final res = await _dio.delete(
                    "https://jsonplaceholder.typicode.com/posts/1",
                  );
                  _showResult('DELETE', res);
                } catch (e) {
                  _showError('DELETE', e);
                }
              },
            ),
            const SizedBox(height: 20),

            // Section: Error
            _buildSectionHeader('Error Scenarios', Icons.error_outline),
            const SizedBox(height: 8),
            _buildRequestButton(
              label: 'GET 404 Not Found',
              subtitle: '/posts/99999',
              color: Colors.grey.shade700,
              icon: Icons.broken_image,
              onTap: () async {
                try {
                  final res = await _dio.get(
                    "https://jsonplaceholder.typicode.com/posts/99999",
                  );
                  _showResult('GET 404', res);
                } catch (e) {
                  _showError('GET 404', e);
                }
              },
            ),
            const SizedBox(height: 8),
            _buildRequestButton(
              label: 'GET Invalid URL',
              subtitle: 'https://invalid.url.test/',
              color: Colors.grey.shade600,
              icon: Icons.link_off,
              onTap: () async {
                try {
                  final res = await _dio.get("https://invalid.url.test/");
                  _showResult('GET Invalid', res);
                } catch (e) {
                  _showError('GET Invalid', e);
                }
              },
            ),
            const SizedBox(height: 24),

            // View Network Logs
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E1E2C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.monitor_heart),
                label: const Text(
                  'View Network Logs',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  ZoConnectivityWatcher().showNetworkLogsScreen(context);
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildRequestButton({
    required String label,
    required String subtitle,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}




