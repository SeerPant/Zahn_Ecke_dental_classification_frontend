import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../utils/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportScreen> {
  List<dynamic> _reports = [];
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  static const int _perPage = 3;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final authService = context.read<AuthService>();
      final token = authService.token;

      final response = await http.get(
        Uri.parse(ApiConfig.reports),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        setState(() {
          _reports = data['reports'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = data['message'] ?? 'Failed to load reports';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network error: $e';
        _isLoading = false;
      });
    }
  }

  int get _totalPages => (_reports.length / _perPage).ceil().clamp(1, 999);

  List<dynamic> get _currentPageReports {
    final start = (_currentPage - 1) * _perPage;
    final end = (start + _perPage).clamp(0, _reports.length);
    return _reports.sublist(start, end);
  }

  String _formatDate(String isoDate) {
    final dt = DateTime.parse(isoDate).toLocal();
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}';
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reports',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _fetchReports,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _reports.isEmpty
                  ? const Center(
                      child: Text(
                        'No reports yet.\nUpload a photo to get started!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recent Reports',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Report cards
                          ..._currentPageReports.map((report) => Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _capitalize(report['condition'] ?? ''),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      _formatDate(report['createdAt']),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const Spacer(),
                          // Pagination
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.arrow_back_ios, size: 16),
                                onPressed: _currentPage > 1
                                    ? () => setState(() => _currentPage--)
                                    : null,
                                color: _currentPage > 1
                                    ? Colors.black
                                    : Colors.grey[300],
                              ),
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1A1AE6),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '$_currentPage',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward_ios,
                                    size: 16),
                                onPressed: _currentPage < _totalPages
                                    ? () => setState(() => _currentPage++)
                                    : null,
                                color: _currentPage < _totalPages
                                    ? Colors.black
                                    : Colors.grey[300],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
    );
  }
}
