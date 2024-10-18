import 'package:flutter/material.dart';
import 'package:image_uploader/core/custom_drawer.dart';
import 'package:image_uploader/services/api_service.dart';
import 'package:image_uploader/services/auth_service.dart';
import 'package:image_uploader/utils/docu_colors.dart';
import 'package:image_uploader/views/widgets/auth_state.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadStatisticsPage extends StatefulWidget {
  final ApiService _apiService;

  const UploadStatisticsPage(this._apiService, {super.key});

  @override
  _UploadStatisticsPageState createState() => _UploadStatisticsPageState();
}

class _UploadStatisticsPageState extends State<UploadStatisticsPage> {
  DateTime? startDate;
  DateTime? endDate;
  List<Map<String, dynamic>> statistics = [];
  bool isLoading = false;
  String? userRole;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final AuthService authService = AuthService();
    final role = await authService.fetchUserRole();
    setState(() {
      userRole = role ?? 'staff';
    });
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isStartDate ? startDate ?? DateTime.now() : endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          if (isStartDate) {
            startDate = DateTime(
                picked.year, picked.month, picked.day, time.hour, time.minute);
          } else {
            endDate = DateTime(
                picked.year, picked.month, picked.day, time.hour, time.minute);
          }
        });
      }
    }
  }

  Future<void> _loadStatistics() async {
    setState(() {
      isLoading = true;
    });

    final startFormatted = DateFormat('yyyy-MM-ddTHH:mm:ss').format(startDate!);
    final endFormatted = DateFormat('yyyy-MM-ddTHH:mm:ss').format(endDate!);

    final result =
        await widget._apiService.fetchUploadStats(startFormatted, endFormatted);

    setState(() {
      isLoading = false;
      if (result != null) {
        statistics = result;
      } else {
        // Handle error, maybe show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch upload statistics')),
        );
      }
    });
  }

  String truncateUsername(String username) {
    return username.length > 12 ? '${username.substring(0, 15)}...' : username;
  }

  Map<String, int> calculateTotals(List<Map<String, dynamic>> statistics) {
    int totalUploads = 0;
    int totalProcessed = 0;
    int totalFailed = 0;

    for (var stat in statistics) {
      totalUploads += stat['total_uploads'] as int? ?? 0;
      totalProcessed += stat['processed'] as int? ?? 0;
      totalFailed += stat['failed'] as int? ?? 0;
    }

    return {
      'total_uploads': totalUploads,
      'processed': totalProcessed,
      'failed': totalFailed,
    };
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, int> totals = calculateTotals(statistics);
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      Future.microtask(() {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthenticationState()),
          (Route<dynamic> route) => false,
        );
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      drawer: AppDrawer(
        onLogout: () async {
          final AuthService _authService = AuthService();
          try {
            await _authService.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const AuthenticationState()),
              (Route<dynamic> route) => false,
            );
          } catch (e) {
            print('Logout error: $e');
          }
        },
        userRole: userRole ?? 'staff',
      ),
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: Image.asset(
                'assets/logo-brain.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'DocuBrain',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor:
            Colors.white, // Updated background color for the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectDateTime(context, true),
                    child: Text(startDate == null
                        ? 'Select Start Date'
                        : DateFormat('yyyy-MM-dd HH:mm').format(startDate!)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectDateTime(context, false),
                    child: Text(endDate == null
                        ? 'Select End Date'
                        : DateFormat('yyyy-MM-dd HH:mm').format(endDate!)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : _loadStatistics,
              style: ElevatedButton.styleFrom(
                backgroundColor: DocuColors.geyser,
              ),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Fetch Statistics'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(columnSpacing: 20, columns: const [
                    DataColumn(label: Text('User')),
                    DataColumn(label: Text('Total')),
                    DataColumn(label: Text('Processed')),
                    DataColumn(label: Text('Failed')),
                  ], rows: [
                    ...statistics.map((stat) => DataRow(
                          cells: [
                            DataCell(
                              Tooltip(
                                message: stat['username'] ?? '',
                                child: Text(
                                    truncateUsername(stat['username'] ?? '')),
                              ),
                            ),
                            DataCell(
                                Text(stat['total_uploads']?.toString() ?? '')),
                            DataCell(Text(stat['processed']?.toString() ?? '')),
                            DataCell(Text(stat['failed']?.toString() ?? '')),
                          ],
                        )),
                    DataRow(
                      color: WidgetStateProperty.all(Colors.grey[200]),
                      cells: [
                        const DataCell(Text('Total',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(totals['total_uploads'].toString(),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(totals['processed'].toString(),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(totals['failed'].toString(),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
