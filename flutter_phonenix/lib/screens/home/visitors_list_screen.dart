import 'package:flutter/material.dart';
import '../../models/index.dart';
import '../../services/index.dart';
import '../../utils/index.dart';
import 'visitor_detail_screen.dart';

class VisitorsListScreen extends StatefulWidget {
  const VisitorsListScreen({Key? key}) : super(key: key);

  @override
  State<VisitorsListScreen> createState() => _VisitorsListScreenState();
}

class _VisitorsListScreenState extends State<VisitorsListScreen> {
  final _visitorService = VisitorService();
  String _filterStatus = 'all'; // 'all', 'inside', 'exited'
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitor List'),
        backgroundColor: AppTheme.primaryColor,
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Filter Buttons
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            child: Row(
              children: [
                Expanded(
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(label: Text('All'), value: 'all'),
                      ButtonSegment(label: Text('Inside'), value: 'inside'),
                      ButtonSegment(label: Text('Exited'), value: 'exited'),
                    ],
                    selected: {_filterStatus},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() => _filterStatus = newSelection.first);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Visitors List
          Expanded(
            child: StreamBuilder<List<Visitor>>(
              stream: _visitorService.streamVisitors(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                List<Visitor> visitors = snapshot.data ?? [];

                // Apply filter
                if (_filterStatus != 'all') {
                  visitors = visitors
                      .where((v) => v.status == _filterStatus)
                      .toList();
                }

                if (visitors.isEmpty) {
                  return Center(
                    child: Text(
                      'No visitors found',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: visitors.length,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMedium,
                  ),
                  itemBuilder: (context, index) {
                    final visitor = visitors[index];
                    return Card(
                      margin:
                          const EdgeInsets.only(bottom: AppTheme.spacingSmall),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: visitor.status == 'inside'
                              ? AppTheme.successColor
                              : AppTheme.disabledColor,
                          child: Text(
                            visitor.name[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          visitor.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'Host: ${visitor.hostName}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              visitor.status == 'inside'
                                  ? 'Status: Inside'
                                  : 'Status: Exited',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: visitor.status == 'inside'
                                        ? AppTheme.successColor
                                        : AppTheme.textSecondaryColor,
                                  ),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            size: 16),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  VisitorDetailScreen(visitor: visitor),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
