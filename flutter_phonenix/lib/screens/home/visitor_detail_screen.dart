import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/index.dart';
import '../../services/index.dart';
import '../../utils/index.dart';

class VisitorDetailScreen extends StatefulWidget {
  final Visitor visitor;

  const VisitorDetailScreen({super.key, required this.visitor});

  @override
  State<VisitorDetailScreen> createState() => _VisitorDetailScreenState();
}

class _VisitorDetailScreenState extends State<VisitorDetailScreen> {
  final _visitorService = VisitorService();
  bool _isLoading = false;

  Future<void> _markExit() async {
    setState(() => _isLoading = true);
    try {
      await _visitorService.markVisitorExit(widget.visitor.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Visitor marked as exited')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteVisitor() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Visitor'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        await _visitorService.deleteVisitor(widget.visitor.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Visitor deleted')),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitor Details'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          if (widget.visitor.status == 'inside')
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: _isLoading ? null : _markExit,
              tooltip: 'Mark as Exited',
            ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _isLoading ? null : _deleteVisitor,
            tooltip: 'Delete',
          ),
        ],
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DetailField(
                        label: 'Name',
                        value: widget.visitor.name,
                      ),
                      const SizedBox(height: AppTheme.spacingMedium),
                      _DetailField(
                        label: 'Email',
                        value: widget.visitor.email,
                      ),
                      const SizedBox(height: AppTheme.spacingMedium),
                      _DetailField(
                        label: 'Phone',
                        value: widget.visitor.phone,
                      ),
                      const SizedBox(height: AppTheme.spacingMedium),
                      _DetailField(
                        label: 'Company',
                        value: widget.visitor.companyName,
                      ),
                      const SizedBox(height: AppTheme.spacingMedium),
                      _DetailField(
                        label: 'Host Name',
                        value: widget.visitor.hostName,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Security Information',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: AppTheme.spacingMedium),
                      _DetailField(
                        label: 'Document Type',
                        value: widget.visitor.documentType
                            .replaceAll('_', ' ')
                            .toUpperCase(),
                      ),
                      const SizedBox(height: AppTheme.spacingMedium),
                      _DetailField(
                        label: 'Document Number',
                        value: widget.visitor.documentNumber,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Visit Details',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: AppTheme.spacingMedium),
                      _DetailField(
                        label: 'Purpose',
                        value: widget.visitor.purpose,
                      ),
                      const SizedBox(height: AppTheme.spacingMedium),
                      _DetailField(
                        label: 'Entry Time',
                        value: dateFormat.format(widget.visitor.entryTime),
                      ),
                      if (widget.visitor.exitTime != null) ...[
                        const SizedBox(height: AppTheme.spacingMedium),
                        _DetailField(
                          label: 'Exit Time',
                          value: dateFormat.format(widget.visitor.exitTime!),
                        ),
                      ],
                      const SizedBox(height: AppTheme.spacingMedium),
                      _DetailField(
                        label: 'Status',
                        value: widget.visitor.status.toUpperCase(),
                        valueColor: widget.visitor.status == 'inside'
                            ? AppTheme.successColor
                            : AppTheme.textSecondaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailField({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
        ),
      ],
    );
  }
}
