import 'package:flutter/material.dart';
import '../../models/index.dart';
import '../../services/index.dart';
import '../../utils/index.dart';

class AddVisitorScreen extends StatefulWidget {
  const AddVisitorScreen({Key? key}) : super(key: key);

  @override
  State<AddVisitorScreen> createState() => _AddVisitorScreenState();
}

class _AddVisitorScreenState extends State<AddVisitorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _visitorService = VisitorService();

  // Form Controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _purposeController;
  late TextEditingController _hostController;
  late TextEditingController _companyController;
  late TextEditingController _documentController;

  String _selectedDocType = 'passport';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _purposeController = TextEditingController();
    _hostController = TextEditingController();
    _companyController = TextEditingController();
    _documentController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _purposeController.dispose();
    _hostController.dispose();
    _companyController.dispose();
    _documentController.dispose();
    super.dispose();
  }

  Future<void> _addVisitor() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final visitor = Visitor(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          purpose: _purposeController.text.trim(),
          hostName: _hostController.text.trim(),
          entryTime: DateTime.now(),
          status: AppConstants.visitorInside,
          companyName: _companyController.text.trim(),
          documentType: _selectedDocType,
          documentNumber: _documentController.text.trim(),
        );

        await _visitorService.addVisitor(visitor);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Visitor added successfully')),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Visitor'),
        backgroundColor: AppTheme.primaryColor,
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMedium),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  validator: Validators.validateName,
                  decoration: InputDecoration(
                    labelText: 'Visitor Name *',
                    prefixIcon: const Icon(Icons.person_outlined),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                TextFormField(
                  controller: _emailController,
                  validator: Validators.validateEmail,
                  decoration: InputDecoration(
                    labelText: 'Email *',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                TextFormField(
                  controller: _phoneController,
                  validator: Validators.validatePhone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number *',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                DropdownButtonFormField<String>(
                  value: _selectedDocType,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedDocType = value);
                    }
                  },
                  items: AppConstants.documentTypes
                      .map((doc) => DropdownMenuItem(
                            value: doc,
                            child: Text(doc.replaceAll('_', ' ')),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'Document Type *',
                    prefixIcon: const Icon(Icons.document_scanner_outlined),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                TextFormField(
                  controller: _documentController,
                  validator: Validators.validateNotEmpty,
                  decoration: InputDecoration(
                    labelText: 'Document Number *',
                    prefixIcon: const Icon(Icons.numbers),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                TextFormField(
                  controller: _purposeController,
                  validator: Validators.validateNotEmpty,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Purpose of Visit *',
                    prefixIcon: const Icon(Icons.note_outlined),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                TextFormField(
                  controller: _hostController,
                  validator: Validators.validateNotEmpty,
                  decoration: InputDecoration(
                    labelText: 'Host Name *',
                    prefixIcon: const Icon(Icons.person_pin_outlined),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                TextFormField(
                  controller: _companyController,
                  validator: Validators.validateNotEmpty,
                  decoration: InputDecoration(
                    labelText: 'Company Name *',
                    prefixIcon: const Icon(Icons.business_outlined),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLarge),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _addVisitor,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text(
                            'Add Visitor',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
